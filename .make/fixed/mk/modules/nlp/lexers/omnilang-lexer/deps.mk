modules/nlp/lexers/omnilang-lexer/VERSION := 1.0.5

$(TARGET_DIR)/state/modules/nlp/lexers/omnilang-lexer/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.test
modules/nlp/lexers/omnilang-lexer/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/omnilang-lexer/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-omnilang-lexer/1.0.5/nlp-omnilang-lexer-1.0.5.pom : modules/nlp/lexers/omnilang-lexer/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-omnilang-lexer/1.0.5/nlp-omnilang-lexer-1.0.5% : modules/nlp/lexers/omnilang-lexer/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install.pom
modules/nlp/lexers/omnilang-lexer/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/lexers/omnilang-lexer");

modules/nlp/lexers/omnilang-lexer/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install.jar
modules/nlp/lexers/omnilang-lexer/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install
modules/nlp/lexers/omnilang-lexer/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/omnilang-lexer/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install-doc.jar
modules/nlp/lexers/omnilang-lexer/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install-xprocdoc.jar
modules/nlp/lexers/omnilang-lexer/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.install-doc
modules/nlp/lexers/omnilang-lexer/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/lexers/omnilang-lexer/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.compile-dependencies modules/nlp/lexers/omnilang-lexer/.test-dependencies
modules/nlp/lexers/omnilang-lexer/.compile-dependencies :
modules/nlp/lexers/omnilang-lexer/.test-dependencies :

.SECONDARY : modules/nlp/lexers/omnilang-lexer/.release

clean : modules/nlp/lexers/omnilang-lexer/.clean
.PHONY : modules/nlp/lexers/omnilang-lexer/.clean
modules/nlp/lexers/omnilang-lexer/.clean :
	rm("modules/nlp/lexers/omnilang-lexer/target");
