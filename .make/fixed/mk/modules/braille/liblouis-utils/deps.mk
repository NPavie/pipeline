modules/braille/liblouis-utils/VERSION := 6.3.3-SNAPSHOT

$(TARGET_DIR)/state/modules/braille/liblouis-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/braille/liblouis-utils/modified-since-release_ : modules/braille/liblouis-utils/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/framework/common-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/braille-common/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/braille-css-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/pef-utils/modified-since-release \
	$(TARGET_DIR)/state/framework/calabash-adapter/modified-since-release \
	$(TARGET_DIR)/state/modules/common/common-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/file-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/fileset-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/libhyphen-utils/modified-since-release \
	$(TARGET_DIR)/state/framework/modules-registry/modified-since-release \
	$(TARGET_DIR)/state/framework/logging-appender/modified-since-release \
	$(TARGET_DIR)/state/framework/webservice/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/braille/liblouis-utils/.test
modules/braille/liblouis-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3-SNAPSHOT/liblouis-utils-6.3.3-SNAPSHOT.pom : modules/braille/liblouis-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3-SNAPSHOT/liblouis-utils-6.3.3-SNAPSHOT% : modules/braille/liblouis-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/liblouis-utils/.install.pom
modules/braille/liblouis-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/liblouis-utils");

modules/braille/liblouis-utils/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.install.jar
modules/braille/liblouis-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/liblouis-utils/.install
modules/braille/liblouis-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.install-doc.jar
modules/braille/liblouis-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-xprocdoc.jar
modules/braille/liblouis-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-javadoc.jar
modules/braille/liblouis-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-doc
modules/braille/liblouis-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.compile-dependencies modules/braille/liblouis-utils/.test-dependencies
modules/braille/liblouis-utils/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1-SNAPSHOT/braille-common-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11-SNAPSHOT/zip-utils-2.1.11-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26-SNAPSHOT/jstyleparser-1.20-p26-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0-SNAPSHOT/braille-css-1.28.0-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1-SNAPSHOT/braille-css-utils-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9-SNAPSHOT/dotify.library-1.0.9-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1-SNAPSHOT/pef-utils-8.0.1-SNAPSHOT.jar
modules/braille/liblouis-utils/.test-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2-SNAPSHOT/libhyphen-utils-3.4.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1-SNAPSHOT/braille-common-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11-SNAPSHOT/zip-utils-2.1.11-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26-SNAPSHOT/jstyleparser-1.20-p26-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0-SNAPSHOT/braille-css-1.28.0-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1-SNAPSHOT/braille-css-utils-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9-SNAPSHOT/dotify.library-1.0.9-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2-SNAPSHOT/libhyphen-utils-3.4.2-SNAPSHOT-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7-SNAPSHOT/logging-appender-2.1.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3/liblouis-utils-6.3.3.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3/liblouis-utils-6.3.3-% : modules/braille/liblouis-utils/.release
	+//

.SECONDARY : modules/braille/liblouis-utils/.release
modules/braille/liblouis-utils/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("braille/liblouis-utils");

modules/braille/liblouis-utils/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1/braille-common-6.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1/css-utils-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2/fileset-utils-7.0.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11/zip-utils-2.1.11.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26/jstyleparser-1.20-p26.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0/braille-css-1.28.0.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1/braille-css-utils-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9/dotify.library-1.0.9.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1/pef-utils-8.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2/libhyphen-utils-3.4.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2/libhyphen-utils-3.4.2-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7/logging-appender-2.1.7.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar

clean : modules/braille/liblouis-utils/.clean
.PHONY : modules/braille/liblouis-utils/.clean
modules/braille/liblouis-utils/.clean :
	rm("modules/braille/liblouis-utils/target");
