modules/scripts/html-to-pef/VERSION := 10.0.0

$(TARGET_DIR)/state/modules/scripts/html-to-pef/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/html-to-pef/.test
modules/scripts/html-to-pef/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-pef/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/html-to-pef/10.0.0/html-to-pef-10.0.0.pom : modules/scripts/html-to-pef/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/html-to-pef/10.0.0/html-to-pef-10.0.0% : modules/scripts/html-to-pef/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/html-to-pef/.install.pom
modules/scripts/html-to-pef/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/html-to-pef");

modules/scripts/html-to-pef/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-pef/.install.jar
modules/scripts/html-to-pef/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/html-to-pef/.install
modules/scripts/html-to-pef/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-pef/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-pef/.install-doc.jar
modules/scripts/html-to-pef/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-pef/.install-xprocdoc.jar
modules/scripts/html-to-pef/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-pef/.install-doc
modules/scripts/html-to-pef/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-pef/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-pef/.compile-dependencies modules/scripts/html-to-pef/.test-dependencies
modules/scripts/html-to-pef/.compile-dependencies :
modules/scripts/html-to-pef/.test-dependencies :

.SECONDARY : modules/scripts/html-to-pef/.release

clean : modules/scripts/html-to-pef/.clean
.PHONY : modules/scripts/html-to-pef/.clean
modules/scripts/html-to-pef/.clean :
	rm("modules/scripts/html-to-pef/target");
