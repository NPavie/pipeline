modules/nlp/lexers/ruled-lexer/VERSION := 1.0.5-SNAPSHOT

$(TARGET_DIR)/state/modules/nlp/lexers/ruled-lexer/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/nlp/lexers/ruled-lexer/modified-since-release_ : modules/nlp/lexers/ruled-lexer/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/modules/nlp/nlp-common/modified-since-release \
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

.SECONDARY : modules/nlp/lexers/ruled-lexer/.test
modules/nlp/lexers/ruled-lexer/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5-SNAPSHOT/nlp-ruled-lexer-1.0.5-SNAPSHOT.pom : modules/nlp/lexers/ruled-lexer/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5-SNAPSHOT/nlp-ruled-lexer-1.0.5-SNAPSHOT% : modules/nlp/lexers/ruled-lexer/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install.pom
modules/nlp/lexers/ruled-lexer/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/lexers/ruled-lexer");

modules/nlp/lexers/ruled-lexer/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install.jar
modules/nlp/lexers/ruled-lexer/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install
modules/nlp/lexers/ruled-lexer/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-doc.jar
modules/nlp/lexers/ruled-lexer/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-xprocdoc.jar
modules/nlp/lexers/ruled-lexer/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-doc
modules/nlp/lexers/ruled-lexer/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.compile-dependencies modules/nlp/lexers/ruled-lexer/.test-dependencies
modules/nlp/lexers/ruled-lexer/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar
modules/nlp/lexers/ruled-lexer/.test-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5/nlp-ruled-lexer-1.0.5.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5/nlp-ruled-lexer-1.0.5-% : modules/nlp/lexers/ruled-lexer/.release
	+//

.SECONDARY : modules/nlp/lexers/ruled-lexer/.release
modules/nlp/lexers/ruled-lexer/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("nlp/lexers/ruled-lexer");

modules/nlp/lexers/ruled-lexer/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar

clean : modules/nlp/lexers/ruled-lexer/.clean
.PHONY : modules/nlp/lexers/ruled-lexer/.clean
modules/nlp/lexers/ruled-lexer/.clean :
	rm("modules/nlp/lexers/ruled-lexer/target");
