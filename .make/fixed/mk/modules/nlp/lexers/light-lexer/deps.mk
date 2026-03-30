modules/nlp/lexers/light-lexer/VERSION := 1.0.1-SNAPSHOT

$(TARGET_DIR)/state/modules/nlp/lexers/light-lexer/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/nlp/lexers/light-lexer/modified-since-release_ : modules/nlp/lexers/light-lexer/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/modules/nlp/nlp-common/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/nlp/lexers/light-lexer/.test
modules/nlp/lexers/light-lexer/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/light-lexer/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-light-lexer/1.0.1-SNAPSHOT/nlp-light-lexer-1.0.1-SNAPSHOT.pom : modules/nlp/lexers/light-lexer/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-light-lexer/1.0.1-SNAPSHOT/nlp-light-lexer-1.0.1-SNAPSHOT% : modules/nlp/lexers/light-lexer/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/lexers/light-lexer/.install.pom
modules/nlp/lexers/light-lexer/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/lexers/light-lexer");

modules/nlp/lexers/light-lexer/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/lexers/light-lexer/.install.jar
modules/nlp/lexers/light-lexer/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/lexers/light-lexer/.install
modules/nlp/lexers/light-lexer/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/light-lexer/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/lexers/light-lexer/.install-doc.jar
modules/nlp/lexers/light-lexer/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/light-lexer/.install-xprocdoc.jar
modules/nlp/lexers/light-lexer/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/light-lexer/.install-doc
modules/nlp/lexers/light-lexer/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/light-lexer/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/light-lexer/.compile-dependencies modules/nlp/lexers/light-lexer/.test-dependencies
modules/nlp/lexers/light-lexer/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar
modules/nlp/lexers/light-lexer/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-light-lexer/1.0.1/nlp-light-lexer-1.0.1.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-light-lexer/1.0.1/nlp-light-lexer-1.0.1-% : modules/nlp/lexers/light-lexer/.release
	+//

.SECONDARY : modules/nlp/lexers/light-lexer/.release
modules/nlp/lexers/light-lexer/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("nlp/lexers/light-lexer");

modules/nlp/lexers/light-lexer/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar

clean : modules/nlp/lexers/light-lexer/.clean
.PHONY : modules/nlp/lexers/light-lexer/.clean
modules/nlp/lexers/light-lexer/.clean :
	rm("modules/nlp/lexers/light-lexer/target");
