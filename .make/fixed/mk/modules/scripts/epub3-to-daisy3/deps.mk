modules/scripts/epub3-to-daisy3/VERSION := 1.0.13-SNAPSHOT

$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy3/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy3/modified-since-release_ : modules/scripts/epub3-to-daisy3/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/framework/framework-core/modified-since-release \
	$(TARGET_DIR)/state/modules/common/common-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/fileset-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/html-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/epub-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/dtbook-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/daisy3-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/smil-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts/html-to-dtbook/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/epub3-to-html/modified-since-release \
	$(TARGET_DIR)/state/framework/modules-registry/modified-since-release \
	$(TARGET_DIR)/state/framework/logging-appender/modified-since-release \
	$(TARGET_DIR)/state/framework/webservice/modified-since-release \
	$(TARGET_DIR)/state/framework/calabash-adapter/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/scripts/epub3-to-daisy3/.test
modules/scripts/epub3-to-daisy3/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13-SNAPSHOT/epub3-to-daisy3-1.0.13-SNAPSHOT.pom : modules/scripts/epub3-to-daisy3/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13-SNAPSHOT/epub3-to-daisy3-1.0.13-SNAPSHOT% : modules/scripts/epub3-to-daisy3/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/epub3-to-daisy3/.install.pom
modules/scripts/epub3-to-daisy3/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/epub3-to-daisy3");

modules/scripts/epub3-to-daisy3/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.install.jar
modules/scripts/epub3-to-daisy3/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/epub3-to-daisy3/.install
modules/scripts/epub3-to-daisy3/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-doc.jar
modules/scripts/epub3-to-daisy3/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-xprocdoc.jar
modules/scripts/epub3-to-daisy3/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-doc
modules/scripts/epub3-to-daisy3/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.compile-dependencies modules/scripts/epub3-to-daisy3/.test-dependencies
modules/scripts/epub3-to-daisy3/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11-SNAPSHOT/zip-utils-2.1.11-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.5.1-SNAPSHOT/html-utils-6.5.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26-SNAPSHOT/jstyleparser-1.20-p26-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0-SNAPSHOT/braille-css-1.28.0-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1-SNAPSHOT/epub-utils-2.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4-SNAPSHOT/smil-utils-4.0.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7-SNAPSHOT/odf-utils-1.0.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1-SNAPSHOT/daisy3-utils-4.2.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.0.1-SNAPSHOT/dtbook-utils-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3-SNAPSHOT/validation-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3-SNAPSHOT/metadata-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1-SNAPSHOT/mathml-utils-1.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1-SNAPSHOT/tts-common-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8-SNAPSHOT/audio-common-5.1.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15-SNAPSHOT/epubcheck-adapter-1.1.15-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12-SNAPSHOT/ace-adapter-1.0.12-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-dtbook/2.0.10-SNAPSHOT/html-to-dtbook-2.0.10-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-html/1.0.2-SNAPSHOT/epub3-to-html-1.0.2-SNAPSHOT.jar
modules/scripts/epub3-to-daisy3/.test-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.5.1-SNAPSHOT/html-utils-6.5.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11-SNAPSHOT/zip-utils-2.1.11-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26-SNAPSHOT/jstyleparser-1.20-p26-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0-SNAPSHOT/braille-css-1.28.0-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7-SNAPSHOT/logging-appender-2.1.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13/epub3-to-daisy3-1.0.13.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13/epub3-to-daisy3-1.0.13-% : modules/scripts/epub3-to-daisy3/.release
	+//

.SECONDARY : modules/scripts/epub3-to-daisy3/.release
modules/scripts/epub3-to-daisy3/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("scripts/epub3-to-daisy3");

modules/scripts/epub3-to-daisy3/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2/fileset-utils-7.0.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11/zip-utils-2.1.11.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.5.1/html-utils-6.5.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1/css-utils-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26/jstyleparser-1.20-p26.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0/braille-css-1.28.0.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1/epub-utils-2.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4/smil-utils-4.0.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7/odf-utils-1.0.7.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1/daisy3-utils-4.2.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.0.1/dtbook-utils-6.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3/validation-utils-2.0.3.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3/metadata-utils-2.0.3.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1/mathml-utils-1.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1/tts-common-8.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8/audio-common-5.1.8.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15/epubcheck-adapter-1.1.15.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12/ace-adapter-1.0.12.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-dtbook/2.0.10/html-to-dtbook-2.0.10.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-html/1.0.2/epub3-to-html-1.0.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7/logging-appender-2.1.7.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar

clean : modules/scripts/epub3-to-daisy3/.clean
.PHONY : modules/scripts/epub3-to-daisy3/.clean
modules/scripts/epub3-to-daisy3/.clean :
	rm("modules/scripts/epub3-to-daisy3/target");
