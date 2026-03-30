modules/scripts/dtbook-to-rtf/VERSION := 2.0.14

$(TARGET_DIR)/state/modules/scripts/dtbook-to-rtf/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-rtf/.test
modules/scripts/dtbook-to-rtf/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-rtf/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-rtf/2.0.14/dtbook-to-rtf-2.0.14.pom : modules/scripts/dtbook-to-rtf/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-rtf/2.0.14/dtbook-to-rtf-2.0.14% : modules/scripts/dtbook-to-rtf/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-rtf/.install.pom
modules/scripts/dtbook-to-rtf/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-rtf");

modules/scripts/dtbook-to-rtf/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-rtf/.install.jar
modules/scripts/dtbook-to-rtf/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-rtf/.install
modules/scripts/dtbook-to-rtf/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-rtf/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-rtf/.install-doc.jar
modules/scripts/dtbook-to-rtf/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-rtf/.install-xprocdoc.jar
modules/scripts/dtbook-to-rtf/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-rtf/.install-doc
modules/scripts/dtbook-to-rtf/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-rtf/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-rtf/.compile-dependencies modules/scripts/dtbook-to-rtf/.test-dependencies
modules/scripts/dtbook-to-rtf/.compile-dependencies :
modules/scripts/dtbook-to-rtf/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-rtf/.release

clean : modules/scripts/dtbook-to-rtf/.clean
.PHONY : modules/scripts/dtbook-to-rtf/.clean
modules/scripts/dtbook-to-rtf/.clean :
	rm("modules/scripts/dtbook-to-rtf/target");
