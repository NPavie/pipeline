modules/scripts/dtbook-validator/VERSION := 3.1.0

$(TARGET_DIR)/state/modules/scripts/dtbook-validator/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-validator/.test
modules/scripts/dtbook-validator/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-validator/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-validator/3.1.0/dtbook-validator-3.1.0.pom : modules/scripts/dtbook-validator/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-validator/3.1.0/dtbook-validator-3.1.0% : modules/scripts/dtbook-validator/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-validator/.install.pom
modules/scripts/dtbook-validator/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-validator");

modules/scripts/dtbook-validator/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-validator/.install.jar
modules/scripts/dtbook-validator/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-validator/.install
modules/scripts/dtbook-validator/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-validator/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-validator/.install-doc.jar
modules/scripts/dtbook-validator/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-validator/.install-xprocdoc.jar
modules/scripts/dtbook-validator/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-validator/.install-doc
modules/scripts/dtbook-validator/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-validator/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-validator/.compile-dependencies modules/scripts/dtbook-validator/.test-dependencies
modules/scripts/dtbook-validator/.compile-dependencies :
modules/scripts/dtbook-validator/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-validator/.release

clean : modules/scripts/dtbook-validator/.clean
.PHONY : modules/scripts/dtbook-validator/.clean
modules/scripts/dtbook-validator/.clean :
	rm("modules/scripts/dtbook-validator/target");
