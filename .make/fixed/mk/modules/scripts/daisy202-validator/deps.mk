modules/scripts/daisy202-validator/VERSION := 2.1.3

$(TARGET_DIR)/state/modules/scripts/daisy202-validator/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/daisy202-validator/.test
modules/scripts/daisy202-validator/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/daisy202-validator/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy202-validator/2.1.3/daisy202-validator-2.1.3.pom : modules/scripts/daisy202-validator/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy202-validator/2.1.3/daisy202-validator-2.1.3% : modules/scripts/daisy202-validator/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/daisy202-validator/.install.pom
modules/scripts/daisy202-validator/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/daisy202-validator");

modules/scripts/daisy202-validator/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/daisy202-validator/.install.jar
modules/scripts/daisy202-validator/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/daisy202-validator/.install
modules/scripts/daisy202-validator/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/daisy202-validator/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/daisy202-validator/.install-doc.jar
modules/scripts/daisy202-validator/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/daisy202-validator/.install-xprocdoc.jar
modules/scripts/daisy202-validator/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/daisy202-validator/.install-doc
modules/scripts/daisy202-validator/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/daisy202-validator/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/daisy202-validator/.compile-dependencies modules/scripts/daisy202-validator/.test-dependencies
modules/scripts/daisy202-validator/.compile-dependencies :
modules/scripts/daisy202-validator/.test-dependencies :

.SECONDARY : modules/scripts/daisy202-validator/.release

clean : modules/scripts/daisy202-validator/.clean
.PHONY : modules/scripts/daisy202-validator/.clean
modules/scripts/daisy202-validator/.clean :
	rm("modules/scripts/daisy202-validator/target");
