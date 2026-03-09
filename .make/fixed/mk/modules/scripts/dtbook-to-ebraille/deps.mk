modules/scripts/dtbook-to-ebraille/VERSION := 1.1.2-SNAPSHOT

$(TARGET_DIR)/state/modules/scripts/dtbook-to-ebraille/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/scripts/dtbook-to-ebraille/modified-since-release_ : modules/scripts/dtbook-to-ebraille/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/framework/common-utils/modified-since-release \
	$(TARGET_DIR)/state/framework/framework-core/modified-since-release \
	$(TARGET_DIR)/state/framework/calabash-adapter/modified-since-release \
	$(TARGET_DIR)/state/modules/common/common-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/file-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/fileset-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/dtbook-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/epub-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts-utils/css-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/braille-common/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/braille-css-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-epub3/modified-since-release \
	$(TARGET_DIR)/state/modules/braille/liblouis-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/scripts/dtbook-to-pef/modified-since-release \
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

.SECONDARY : modules/scripts/dtbook-to-ebraille/.test
modules/scripts/dtbook-to-ebraille/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.1.2-SNAPSHOT/dtbook-to-ebraille-1.1.2-SNAPSHOT.pom : modules/scripts/dtbook-to-ebraille/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.1.2-SNAPSHOT/dtbook-to-ebraille-1.1.2-SNAPSHOT% : modules/scripts/dtbook-to-ebraille/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install.pom
modules/scripts/dtbook-to-ebraille/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-ebraille");

modules/scripts/dtbook-to-ebraille/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install.jar
modules/scripts/dtbook-to-ebraille/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install
modules/scripts/dtbook-to-ebraille/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-doc.jar
modules/scripts/dtbook-to-ebraille/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-xprocdoc.jar
modules/scripts/dtbook-to-ebraille/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-doc
modules/scripts/dtbook-to-ebraille/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.compile-dependencies modules/scripts/dtbook-to-ebraille/.test-dependencies
modules/scripts/dtbook-to-ebraille/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2-SNAPSHOT/fileset-utils-7.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11-SNAPSHOT/zip-utils-2.1.11-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.0.1-SNAPSHOT/dtbook-utils-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1-SNAPSHOT/mediatype-utils-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3-SNAPSHOT/validation-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1-SNAPSHOT/css-utils-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26-SNAPSHOT/jstyleparser-1.20-p26-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0-SNAPSHOT/braille-css-1.28.0-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3-SNAPSHOT/metadata-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1-SNAPSHOT/mathml-utils-1.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1-SNAPSHOT/tts-common-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8-SNAPSHOT/audio-common-5.1.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1-SNAPSHOT/epub-utils-2.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.5.1-SNAPSHOT/html-utils-6.5.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4-SNAPSHOT/smil-utils-4.0.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7-SNAPSHOT/odf-utils-1.0.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1-SNAPSHOT/daisy3-utils-4.2.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15-SNAPSHOT/epubcheck-adapter-1.1.15-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12-SNAPSHOT/ace-adapter-1.0.12-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1-SNAPSHOT/braille-common-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1-SNAPSHOT/braille-css-utils-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9-SNAPSHOT/dotify.library-1.0.9-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-epub3/2.7.2-SNAPSHOT/dtbook-to-epub3-2.7.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-zedai/4.1.2-SNAPSHOT/dtbook-to-zedai-4.1.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-utils/1.3.1-SNAPSHOT/zedai-utils-1.3.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-epub3/2.6.2-SNAPSHOT/zedai-to-epub3-2.6.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-epub3/2.5.2-SNAPSHOT/html-to-epub3-2.5.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-html/2.6.2-SNAPSHOT/zedai-to-html-2.6.2-SNAPSHOT.jar
modules/scripts/dtbook-to-ebraille/.test-dependencies : \
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
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3-SNAPSHOT/liblouis-utils-6.3.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1-SNAPSHOT/braille-common-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1-SNAPSHOT/braille-css-utils-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9-SNAPSHOT/dotify.library-1.0.9-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1-SNAPSHOT/pef-utils-8.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dtbook-to-pef/12.0.1-SNAPSHOT/dtbook-to-pef-12.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.0.1-SNAPSHOT/dtbook-utils-6.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3-SNAPSHOT/validation-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3-SNAPSHOT/metadata-utils-2.0.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1-SNAPSHOT/mathml-utils-1.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1-SNAPSHOT/tts-common-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8-SNAPSHOT/audio-common-5.1.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-epub3/2.7.2-SNAPSHOT/dtbook-to-epub3-2.7.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-zedai/4.1.2-SNAPSHOT/dtbook-to-zedai-4.1.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-utils/1.3.1-SNAPSHOT/zedai-utils-1.3.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1-SNAPSHOT/epub-utils-2.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4-SNAPSHOT/smil-utils-4.0.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7-SNAPSHOT/odf-utils-1.0.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1-SNAPSHOT/daisy3-utils-4.2.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15-SNAPSHOT/epubcheck-adapter-1.1.15-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12-SNAPSHOT/ace-adapter-1.0.12-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-epub3/2.6.2-SNAPSHOT/zedai-to-epub3-2.6.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-epub3/2.5.2-SNAPSHOT/html-to-epub3-2.5.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-html/2.6.2-SNAPSHOT/zedai-to-html-2.6.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2-SNAPSHOT/libhyphen-utils-3.4.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3-SNAPSHOT/liblouis-utils-6.3.3-SNAPSHOT-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2-SNAPSHOT/libhyphen-utils-3.4.2-SNAPSHOT-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7-SNAPSHOT/logging-appender-2.1.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.1.2/dtbook-to-ebraille-1.1.2.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.1.2/dtbook-to-ebraille-1.1.2-% : modules/scripts/dtbook-to-ebraille/.release
	+//

.SECONDARY : modules/scripts/dtbook-to-ebraille/.release
modules/scripts/dtbook-to-ebraille/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("scripts/dtbook-to-ebraille");

modules/scripts/dtbook-to-ebraille/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/7.0.2/fileset-utils-7.0.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zip-utils/2.1.11/zip-utils-2.1.11.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.0.1/dtbook-utils-6.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3/validation-utils-2.0.3.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/7.0.1/css-utils-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jstyleparser/1.20-p26/jstyleparser-1.20-p26.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/braille/braille-css/1.28.0/braille-css-1.28.0.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/metadata-utils/2.0.3/metadata-utils-2.0.3.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1/mathml-utils-1.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/8.1.1/tts-common-8.1.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8/audio-common-5.1.8.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1/epub-utils-2.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.5.1/html-utils-6.5.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4/smil-utils-4.0.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7/odf-utils-1.0.7.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1/daisy3-utils-4.2.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15/epubcheck-adapter-1.1.15.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12/ace-adapter-1.0.12.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/6.0.1/braille-common-6.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1/braille-css-utils-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/dotify/dotify.library/1.0.9/dotify.library-1.0.9.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-epub3/2.7.2/dtbook-to-epub3-2.7.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-zedai/4.1.2/dtbook-to-zedai-4.1.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-utils/1.3.1/zedai-utils-1.3.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-epub3/2.6.2/zedai-to-epub3-2.6.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-epub3/2.5.2/html-to-epub3-2.5.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-html/2.6.2/zedai-to-html-2.6.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3/liblouis-utils-6.3.3.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1/pef-utils-8.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dtbook-to-pef/12.0.1/dtbook-to-pef-12.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2/libhyphen-utils-3.4.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.3.3/liblouis-utils-6.3.3-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.4.2/libhyphen-utils-3.4.2-mac.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7/logging-appender-2.1.7.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar

clean : modules/scripts/dtbook-to-ebraille/.clean
.PHONY : modules/scripts/dtbook-to-ebraille/.clean
modules/scripts/dtbook-to-ebraille/.clean :
	rm("modules/scripts/dtbook-to-ebraille/target");
