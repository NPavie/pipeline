modules/scripts/dtbook-to-html/VERSION := 4.1.0

$(TARGET_DIR)/state/modules/scripts/dtbook-to-html/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-html/.test
modules/scripts/dtbook-to-html/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-html/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-html/4.1.0/dtbook-to-html-4.1.0.pom : modules/scripts/dtbook-to-html/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-html/4.1.0/dtbook-to-html-4.1.0% : modules/scripts/dtbook-to-html/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-html/.install.pom
modules/scripts/dtbook-to-html/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-html");

modules/scripts/dtbook-to-html/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-html/.install.jar
modules/scripts/dtbook-to-html/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-html/.install
modules/scripts/dtbook-to-html/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-html/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-html/.install-doc.jar
modules/scripts/dtbook-to-html/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-html/.install-xprocdoc.jar
modules/scripts/dtbook-to-html/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-html/.install-doc
modules/scripts/dtbook-to-html/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-html/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-html/.compile-dependencies modules/scripts/dtbook-to-html/.test-dependencies
modules/scripts/dtbook-to-html/.compile-dependencies :
modules/scripts/dtbook-to-html/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-html/.release

clean : modules/scripts/dtbook-to-html/.clean
.PHONY : modules/scripts/dtbook-to-html/.clean
modules/scripts/dtbook-to-html/.clean :
	rm("modules/scripts/dtbook-to-html/target");
