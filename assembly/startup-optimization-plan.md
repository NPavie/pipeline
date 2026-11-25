# CLI launch speed optimization — profiling and reduction plan

Scope: embedded CLI/UI of the assembly (`pipeline2 cli <script> ...` and `pipeline2 ui <script> ...`),
version 1.15.5 of the pipeline core modules. The problem reported: the **“Starting the embedded pipeline API …”**
stage takes several seconds before the script lookup happens, notably on Windows.

## 1. What actually happens during that stage

The message is printed by the `SimpleAPI` constructor
(`assembly/src/main/java/api/SimpleAPI.java`). The constructor is invoked while
`SimpleAPI.getInstance()` iterates all `CreateOnStart` service providers
(`org.daisy.common.spi.ServiceLoader.load(CreateOnStart.class)`). Everything between
“Starting the embedded pipeline API …” and “Loading conversion script …” is that iteration:

1. **Provider scan**: `java.util.ServiceLoader` must locate the `META-INF/services/org.daisy.common.spi.CreateOnStart`
   file across the whole classpath: `system\common\*` (~150 jars), `modules\*` (~50 module jars),
   optionally `system\persistence\*`. Each **distinct service interface** loaded later (ScriptRegistry,
   DatatypeRegistry, JobFactory, ScriptService, …) triggers a **new scan of every jar** on the classpath
   (`framework/…/ds-to-spi` generates one `META-INF/services` entry per OSGi component).
   The distribution bundles a **Java 17 Temurin JRE built with jlink**, so the JDK already caches each
   jar's `services` directory after it has been read once (`ServicesCatalog`): repeated
   `ServiceLoader.load` calls for different interfaces are cheap **after** the first sweep, but that
   first sweep still has to open and read the central directory of every one of the ~200 classpath jars
   (on Java 8, which re-reads jar directories per lookup, this stage is significantly worse — that is
   the classic Linux/macOS-vs-Windows gap when running an old system JVM).
2. **Recursive service wiring**: instantiating a provider instantiates its `@Reference` graph
   (generated SPI classes in `ds-to-spi`):
   - `DefaultModuleRegistry` parses **every** `module.xml` of all ~45 modules eagerly
     (`framework/modules-registry/…/DefaultModuleRegistry.java`);
   - `SaxonConfigurator.setModuleRegistry` iterates all modules and **opens and registers every XSLT
     package source** (`framework/saxon-adapter/…/SaxonConfigurator.java:195`);
   - `DatatypeRegistry` constructs all datatype objects;
   - `ScriptRegistry.update()` activates every script service (properties/activate per module jar).
3. **Windows amplifiers** (why seconds, not hundreds of ms):
   - real-time antivirus (Windows Defender) re-scans each jar at open time — the single most common
     cause of a several-second gap between platforms;
   - `bin/pipeline2.bat` runs `checkJavaVersion.bat` **before** java starts, which can spawn up to
     several additional `java -version` processes and registry queries if `JAVA`/`JAVA_HOME` are not set;
   - cold `%APPDATA%\DAISY Pipeline 2` (logs) and `%TEMP%` I/O;
   - `jabswitch.exe` enable attempt for `ui` mode.

So the script lookup itself (`scriptRegistry.getScript(name)` — a `ConcurrentHashMap` get) is
**not** the bottleneck: the bottleneck is the eager construction of the whole engine (service scan +
module registry + Saxon packages + datatype registry) that must happen before any script can be found.

## 2. How to profile on the target machine

This PR adds an opt-in timing to `SimpleAPI`:

```
set JAVA_OPTS=-Dorg.daisy.pipeline.cli.timing=true
pipeline2 cli <script> ...
```

which prints one line per `CreateOnStart` provider with its instantiation time, plus the total.
Additional profiling commands (on the user’s machine, any OS):

```
# class loading costs (which jars are slow to open)
"%JAVA%" -Xlog:class+load:file=classload.log ... -classpath ... CommandLineInterface ...
# full profile, approximately 30 s run, no overhead when not recording
"%JAVA%" -XX:StartFlightRecording=filename=startup.jfr,settings=profile,duration=30s ... CommandLineInterface ...
```

Open `startup.jfr` in JDK Mission Control (Event Browser → Class Loading / JVM Information) —
on Windows the gap between “Starting the embedded pipeline API” and the next message will typically
show up as time in `JarLoader`/file opens (AV), `DefaultModuleRegistry`, `SaxonConfigurator`,
and Saxon/Catalog initialization.

Same machine quick A/B tests to isolate environmental factors:
- add the installation directory to Defender exclusions and re-run;
- run twice in a row (warm) vs. after reboot (cold);
- confirm the same behavior in a Linux VM with the identical bundled JRE: if Linux is fast there,
  the extra seconds on Windows are environmental (AV / disk), not JVM version related.

Expected findings on Windows: warm run after Defender exclusion typically drops from several seconds
to well under a second for the whole engine-start stage; the remaining time is dominated by
module registry construction and classloading, which both scale with the module count.

## 3. Options to reduce the bottleneck

The options below are ordered by expected effort/risk; they are independent and composable.

### Option 1 — Runtime/OS level, no code change (quick win, do first)
- Document and/or automate (installer task) **Windows Defender exclusions** for the install dir
  and `%APPDATA%\DAISY Pipeline 2`.
- The bundled Java 17 jlink JRE already benefits from per-jar `services` caching (no JDK-version
  work needed; keep the JRE current for further classloading improvements).
- Zero risk to code, potentially the largest single win on Windows — the eager engine
  construction (Option 4) is the only code-side lever that can match it.

### Option 2 — CDS / startup flags (low risk, no API change)
- Train an **AppCDS archive** at install time (or first run) on the target machine (the bundled
  Java 17 JRE fully supports this):
  `java -XX:ArchiveClassesAtExit=...\app.jsa -cp <same classpath> ...` (or the classic
  `-Xshare:dump` + class list), then run with `-XX:SharedArchiveFile`. Typically removes
  30–50 % of classloading time and also speeds up JAR descriptor verification.
  Must be created on the same machine & classpath (Windows path/casing aware); regenerate on update.
- Optionally add `-XX:TieredStopAtLevel=1` for the CLI-only process (faster JIT warmup, converts
  only at interpreter/C1 speed — jobs are mostly XML processing that still benefits from C2; measure first).

### Option 3 — Launcher / batching (low risk, Windows specific)
- In `pipeline2.bat`: skip `checkJavaVersion.bat`’s multi-probe path when `JAVA`/`JAVA_HOME` is already
  set (already partly done); avoid spawning `java -version` (parse `java -XshowSettings:properties -version`
  once); guard the `jabswitch` call with `if exist`.
- Replace the `system\common\*` wildcard entries with an explicit, minimal classpath for cli/ui mode
  (exclude jars only needed by the webservice/persistence) so fewer jars are ever opened.

### Option 4 — Lazy engine start in `SimpleAPI` (medium risk, biggest structural win)
Make the embedded API start **on demand** instead of eagerly wiring the full graph:
- the `CreateOnStart` contract forces all immediate components; for the CLI use-case only a subset is
  needed to answer `scriptRegistry.getScript(id)`;
- make `DefaultModuleRegistry` / `SaxonConfigurator` initialization deferred to first job creation
  (job construction is where XSLT/entity resolution is actually needed), keeping the script lookup on
  the cheap service-descriptor path (`ScriptService.activate`’s properties only, without `load()`).
Estimated effect: script lookup after the “Starting … API” message becomes near-instant; module/Saxon
costs move to job start where they are perceived as “conversion running” instead of “engine starting”.

### Option 5 — Persistent daemon (larger scope, not embedded anymore)
- For repeated CLI conversions, keep the webservice (or a resident embedded engine) running locally and
  have `pipeline2 cli` submit to it (the existing webservice mode already exposes this). Removes the JVM
  + engine-start cost entirely from per-conversion latency; out of scope of the embedded product
  positioning, listed for completeness.

## 4. Recommended sequencing

1. Merge the timing instrumentation and collect measurements on a Windows machine
   (baseline: total engine-start ms, top-3 providers, with/without Defender exclusion).
2. Apply Option 1 (Defender + JRE version) — verify the measured gain.
3. If still > ~1 s, add Option 2 (CDS) and Option 3 (launcher).
4. Keep Option 4 as the structural follow-up: split “engine start” from “job start” in the embedded API
   (would also benefit the `ui` mode and its planned single-window design).

## 5. Acceptance criteria

- Warm CLI start (`pipeline2 cli <any-script> --help`-equivalent path) reaches the
  “Loading conversion script …” line in ≤ 1 s on a mid-range Windows machine with warm OS cache.
- Timing lines available without extra tooling when `-Dorg.daisy.pipeline.cli.timing=true`.
- No behavior change with the property unset (default off).
