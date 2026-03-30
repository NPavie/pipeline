modules/scripts-utils/metadata-utils/VERSION := 2.0.3-SNAPSHOT

$(TARGET_DIR)/state/modules/scripts-utils/metadata-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/scripts-utils/metadata-utils/modified-since-release_ : modules/scripts-utils/metadata-utils/pom.xml $(TARGET_DIR)/state/modules/parent/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/scripts-utils/metadata-utils/.test
modules/scripts-utils/metadata-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/metadata-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3-SNAPSHOT/metadata-utils-2.0.3-SNAPSHOT.pom : modules/scripts-utils/metadata-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3-SNAPSHOT/metadata-utils-2.0.3-SNAPSHOT% : modules/scripts-utils/metadata-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/metadata-utils/.install.pom
modules/scripts-utils/metadata-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/metadata-utils");

modules/scripts-utils/metadata-utils/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts-utils/metadata-utils/.install.jar
modules/scripts-utils/metadata-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/metadata-utils/.install
modules/scripts-utils/metadata-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/metadata-utils/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts-utils/metadata-utils/.install-doc.jar
modules/scripts-utils/metadata-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/metadata-utils/.install-xprocdoc.jar
modules/scripts-utils/metadata-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/metadata-utils/.install-doc
modules/scripts-utils/metadata-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/metadata-utils/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/metadata-utils/.compile-dependencies modules/scripts-utils/metadata-utils/.test-dependencies
modules/scripts-utils/metadata-utils/.compile-dependencies : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom
modules/scripts-utils/metadata-utils/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3/metadata-utils-2.0.3.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3/metadata-utils-2.0.3-% : modules/scripts-utils/metadata-utils/.release
	+//

.SECONDARY : modules/scripts-utils/metadata-utils/.release
modules/scripts-utils/metadata-utils/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("scripts-utils/metadata-utils");

modules/scripts-utils/metadata-utils/.release : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom

clean : modules/scripts-utils/metadata-utils/.clean
.PHONY : modules/scripts-utils/metadata-utils/.clean
modules/scripts-utils/metadata-utils/.clean :
	rm("modules/scripts-utils/metadata-utils/target");
