modules/nlp/lexers/ruled-lexer/VERSION := 1.0.5

$(TARGET_DIR)/state/modules/nlp/lexers/ruled-lexer/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/nlp/lexers/ruled-lexer/.test
modules/nlp/lexers/ruled-lexer/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5/nlp-ruled-lexer-1.0.5.pom : modules/nlp/lexers/ruled-lexer/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-ruled-lexer/1.0.5/nlp-ruled-lexer-1.0.5% : modules/nlp/lexers/ruled-lexer/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install.pom
modules/nlp/lexers/ruled-lexer/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/lexers/ruled-lexer");

modules/nlp/lexers/ruled-lexer/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install.jar
modules/nlp/lexers/ruled-lexer/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install
modules/nlp/lexers/ruled-lexer/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-doc.jar
modules/nlp/lexers/ruled-lexer/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-xprocdoc.jar
modules/nlp/lexers/ruled-lexer/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/ruled-lexer/.install-doc
modules/nlp/lexers/ruled-lexer/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/ruled-lexer/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/ruled-lexer/.compile-dependencies modules/nlp/lexers/ruled-lexer/.test-dependencies
modules/nlp/lexers/ruled-lexer/.compile-dependencies :
modules/nlp/lexers/ruled-lexer/.test-dependencies :

.SECONDARY : modules/nlp/lexers/ruled-lexer/.release

clean : modules/nlp/lexers/ruled-lexer/.clean
.PHONY : modules/nlp/lexers/ruled-lexer/.clean
modules/nlp/lexers/ruled-lexer/.clean :
	rm("modules/nlp/lexers/ruled-lexer/target");
