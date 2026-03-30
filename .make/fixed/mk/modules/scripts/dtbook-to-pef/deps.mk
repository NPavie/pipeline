modules/scripts/dtbook-to-pef/VERSION := 13.0.0

$(TARGET_DIR)/state/modules/scripts/dtbook-to-pef/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-pef/.test
modules/scripts/dtbook-to-pef/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-pef/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dtbook-to-pef/13.0.0/dtbook-to-pef-13.0.0.pom : modules/scripts/dtbook-to-pef/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dtbook-to-pef/13.0.0/dtbook-to-pef-13.0.0% : modules/scripts/dtbook-to-pef/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-pef/.install.pom
modules/scripts/dtbook-to-pef/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-pef");

modules/scripts/dtbook-to-pef/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-pef/.install.jar
modules/scripts/dtbook-to-pef/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-pef/.install
modules/scripts/dtbook-to-pef/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-pef/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-pef/.install-doc.jar
modules/scripts/dtbook-to-pef/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-pef/.install-xprocdoc.jar
modules/scripts/dtbook-to-pef/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-pef/.install-doc
modules/scripts/dtbook-to-pef/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-pef/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-pef/.compile-dependencies modules/scripts/dtbook-to-pef/.test-dependencies
modules/scripts/dtbook-to-pef/.compile-dependencies :
modules/scripts/dtbook-to-pef/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-pef/.release

clean : modules/scripts/dtbook-to-pef/.clean
.PHONY : modules/scripts/dtbook-to-pef/.clean
modules/scripts/dtbook-to-pef/.clean :
	rm("modules/scripts/dtbook-to-pef/target");
