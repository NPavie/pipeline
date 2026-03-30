modules/tts/tts-mocks/VERSION := 1.0.6-SNAPSHOT

$(TARGET_DIR)/state/modules/tts/tts-mocks/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/tts/tts-mocks/modified-since-release_ : modules/tts/tts-mocks/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/modules/tts/tts-common/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/tts/tts-mocks/.test
modules/tts/tts-mocks/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-mocks/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-mocks/1.0.6-SNAPSHOT/tts-mocks-1.0.6-SNAPSHOT.pom : modules/tts/tts-mocks/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-mocks/1.0.6-SNAPSHOT/tts-mocks-1.0.6-SNAPSHOT% : modules/tts/tts-mocks/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-mocks/.install.pom
modules/tts/tts-mocks/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-mocks");

modules/tts/tts-mocks/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/tts/tts-mocks/.install.jar
modules/tts/tts-mocks/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-mocks/.install
modules/tts/tts-mocks/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-mocks/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/tts/tts-mocks/.install-doc.jar
modules/tts/tts-mocks/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-mocks/.install-xprocdoc.jar
modules/tts/tts-mocks/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-mocks/.install-doc
modules/tts/tts-mocks/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-mocks/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-mocks/.compile-dependencies modules/tts/tts-mocks/.test-dependencies
modules/tts/tts-mocks/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1-SNAPSHOT/tts-common-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8-SNAPSHOT/audio-common-5.1.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar
modules/tts/tts-mocks/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-mocks/1.0.6/tts-mocks-1.0.6.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-mocks/1.0.6/tts-mocks-1.0.6-% : modules/tts/tts-mocks/.release
	+//

.SECONDARY : modules/tts/tts-mocks/.release
modules/tts/tts-mocks/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("tts/tts-mocks");

modules/tts/tts-mocks/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1/tts-common-8.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8/audio-common-5.1.8.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2/fileset-utils-7.0.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1/css-utils-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1.jar

clean : modules/tts/tts-mocks/.clean
.PHONY : modules/tts/tts-mocks/.clean
modules/tts/tts-mocks/.clean :
	rm("modules/tts/tts-mocks/target");
