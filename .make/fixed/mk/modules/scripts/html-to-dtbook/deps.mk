modules/scripts/html-to-dtbook/VERSION := 2.0.10

$(TARGET_DIR)/state/modules/scripts/html-to-dtbook/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/html-to-dtbook/.test
modules/scripts/html-to-dtbook/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-dtbook/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-dtbook/2.0.10/html-to-dtbook-2.0.10.pom : modules/scripts/html-to-dtbook/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-dtbook/2.0.10/html-to-dtbook-2.0.10% : modules/scripts/html-to-dtbook/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/html-to-dtbook/.install.pom
modules/scripts/html-to-dtbook/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/html-to-dtbook");

modules/scripts/html-to-dtbook/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-dtbook/.install.jar
modules/scripts/html-to-dtbook/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/html-to-dtbook/.install
modules/scripts/html-to-dtbook/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-dtbook/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-dtbook/.install-doc.jar
modules/scripts/html-to-dtbook/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-dtbook/.install-xprocdoc.jar
modules/scripts/html-to-dtbook/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-dtbook/.install-doc
modules/scripts/html-to-dtbook/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-dtbook/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-dtbook/.compile-dependencies modules/scripts/html-to-dtbook/.test-dependencies
modules/scripts/html-to-dtbook/.compile-dependencies :
modules/scripts/html-to-dtbook/.test-dependencies :

.SECONDARY : modules/scripts/html-to-dtbook/.release

clean : modules/scripts/html-to-dtbook/.clean
.PHONY : modules/scripts/html-to-dtbook/.clean
modules/scripts/html-to-dtbook/.clean :
	rm("modules/scripts/html-to-dtbook/target");
