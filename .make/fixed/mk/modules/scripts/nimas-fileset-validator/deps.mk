modules/scripts/nimas-fileset-validator/VERSION := 2.2.0

$(TARGET_DIR)/state/modules/scripts/nimas-fileset-validator/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/nimas-fileset-validator/.test
modules/scripts/nimas-fileset-validator/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/nimas-fileset-validator/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nimas-fileset-validator/2.2.0/nimas-fileset-validator-2.2.0.pom : modules/scripts/nimas-fileset-validator/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nimas-fileset-validator/2.2.0/nimas-fileset-validator-2.2.0% : modules/scripts/nimas-fileset-validator/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/nimas-fileset-validator/.install.pom
modules/scripts/nimas-fileset-validator/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/nimas-fileset-validator");

modules/scripts/nimas-fileset-validator/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/nimas-fileset-validator/.install.jar
modules/scripts/nimas-fileset-validator/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/nimas-fileset-validator/.install
modules/scripts/nimas-fileset-validator/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/nimas-fileset-validator/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/nimas-fileset-validator/.install-doc.jar
modules/scripts/nimas-fileset-validator/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/nimas-fileset-validator/.install-xprocdoc.jar
modules/scripts/nimas-fileset-validator/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/nimas-fileset-validator/.install-doc
modules/scripts/nimas-fileset-validator/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/nimas-fileset-validator/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/nimas-fileset-validator/.compile-dependencies modules/scripts/nimas-fileset-validator/.test-dependencies
modules/scripts/nimas-fileset-validator/.compile-dependencies :
modules/scripts/nimas-fileset-validator/.test-dependencies :

.SECONDARY : modules/scripts/nimas-fileset-validator/.release

clean : modules/scripts/nimas-fileset-validator/.clean
.PHONY : modules/scripts/nimas-fileset-validator/.clean
modules/scripts/nimas-fileset-validator/.clean :
	rm("modules/scripts/nimas-fileset-validator/target");
