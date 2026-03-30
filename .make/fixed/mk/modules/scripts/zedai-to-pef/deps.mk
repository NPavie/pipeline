modules/scripts/zedai-to-pef/VERSION := 7.1.0

$(TARGET_DIR)/state/modules/scripts/zedai-to-pef/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/zedai-to-pef/.test
modules/scripts/zedai-to-pef/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-pef/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/zedai-to-pef/7.1.0/zedai-to-pef-7.1.0.pom : modules/scripts/zedai-to-pef/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/zedai-to-pef/7.1.0/zedai-to-pef-7.1.0% : modules/scripts/zedai-to-pef/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/zedai-to-pef/.install.pom
modules/scripts/zedai-to-pef/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/zedai-to-pef");

modules/scripts/zedai-to-pef/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-pef/.install.jar
modules/scripts/zedai-to-pef/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/zedai-to-pef/.install
modules/scripts/zedai-to-pef/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-pef/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-pef/.install-doc.jar
modules/scripts/zedai-to-pef/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/zedai-to-pef/.install-xprocdoc.jar
modules/scripts/zedai-to-pef/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/zedai-to-pef/.install-doc
modules/scripts/zedai-to-pef/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-pef/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-pef/.compile-dependencies modules/scripts/zedai-to-pef/.test-dependencies
modules/scripts/zedai-to-pef/.compile-dependencies :
modules/scripts/zedai-to-pef/.test-dependencies :

.SECONDARY : modules/scripts/zedai-to-pef/.release

clean : modules/scripts/zedai-to-pef/.clean
.PHONY : modules/scripts/zedai-to-pef/.clean
modules/scripts/zedai-to-pef/.clean :
	rm("modules/scripts/zedai-to-pef/target");
