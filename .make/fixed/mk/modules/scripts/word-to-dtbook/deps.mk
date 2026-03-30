modules/scripts/word-to-dtbook/VERSION := 1.1.2

$(TARGET_DIR)/state/modules/scripts/word-to-dtbook/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/word-to-dtbook/.test
modules/scripts/word-to-dtbook/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/word-to-dtbook/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/word-to-dtbook/1.1.2/word-to-dtbook-1.1.2.pom : modules/scripts/word-to-dtbook/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/word-to-dtbook/1.1.2/word-to-dtbook-1.1.2% : modules/scripts/word-to-dtbook/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/word-to-dtbook/.install.pom
modules/scripts/word-to-dtbook/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/word-to-dtbook");

modules/scripts/word-to-dtbook/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/word-to-dtbook/.install.jar
modules/scripts/word-to-dtbook/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/word-to-dtbook/.install
modules/scripts/word-to-dtbook/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/word-to-dtbook/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/word-to-dtbook/.install-doc.jar
modules/scripts/word-to-dtbook/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/word-to-dtbook/.install-xprocdoc.jar
modules/scripts/word-to-dtbook/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/word-to-dtbook/.install-doc
modules/scripts/word-to-dtbook/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/word-to-dtbook/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/word-to-dtbook/.compile-dependencies modules/scripts/word-to-dtbook/.test-dependencies
modules/scripts/word-to-dtbook/.compile-dependencies :
modules/scripts/word-to-dtbook/.test-dependencies :

.SECONDARY : modules/scripts/word-to-dtbook/.release

clean : modules/scripts/word-to-dtbook/.clean
.PHONY : modules/scripts/word-to-dtbook/.clean
modules/scripts/word-to-dtbook/.clean :
	rm("modules/scripts/word-to-dtbook/target");
