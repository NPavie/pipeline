modules/scripts/dtbook-to-odt/VERSION := 2.1.16

$(TARGET_DIR)/state/modules/scripts/dtbook-to-odt/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-odt/.test
modules/scripts/dtbook-to-odt/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-odt/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-odt/2.1.16/dtbook-to-odt-2.1.16.pom : modules/scripts/dtbook-to-odt/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-odt/2.1.16/dtbook-to-odt-2.1.16% : modules/scripts/dtbook-to-odt/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-odt/.install.pom
modules/scripts/dtbook-to-odt/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-odt");

modules/scripts/dtbook-to-odt/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-odt/.install.jar
modules/scripts/dtbook-to-odt/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-odt/.install
modules/scripts/dtbook-to-odt/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-odt/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-odt/.install-doc.jar
modules/scripts/dtbook-to-odt/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-odt/.install-xprocdoc.jar
modules/scripts/dtbook-to-odt/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-odt/.install-doc
modules/scripts/dtbook-to-odt/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-odt/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-odt/.compile-dependencies modules/scripts/dtbook-to-odt/.test-dependencies
modules/scripts/dtbook-to-odt/.compile-dependencies :
modules/scripts/dtbook-to-odt/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-odt/.release

clean : modules/scripts/dtbook-to-odt/.clean
.PHONY : modules/scripts/dtbook-to-odt/.clean
modules/scripts/dtbook-to-odt/.clean :
	rm("modules/scripts/dtbook-to-odt/target");
