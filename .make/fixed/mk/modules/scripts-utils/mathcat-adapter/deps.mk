modules/scripts-utils/mathcat-adapter/VERSION := 1.0.1

$(TARGET_DIR)/state/modules/scripts-utils/mathcat-adapter/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/mathcat-adapter/.test
modules/scripts-utils/mathcat-adapter/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathcat-adapter/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathcat-adapter/1.0.1/mathcat-adapter-1.0.1.pom : modules/scripts-utils/mathcat-adapter/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathcat-adapter/1.0.1/mathcat-adapter-1.0.1% : modules/scripts-utils/mathcat-adapter/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install.pom
modules/scripts-utils/mathcat-adapter/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/mathcat-adapter");

modules/scripts-utils/mathcat-adapter/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install.jar
modules/scripts-utils/mathcat-adapter/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install
modules/scripts-utils/mathcat-adapter/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathcat-adapter/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install-doc.jar
modules/scripts-utils/mathcat-adapter/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install-xprocdoc.jar
modules/scripts-utils/mathcat-adapter/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/mathcat-adapter/.install-doc
modules/scripts-utils/mathcat-adapter/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathcat-adapter/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathcat-adapter/.compile-dependencies modules/scripts-utils/mathcat-adapter/.test-dependencies
modules/scripts-utils/mathcat-adapter/.compile-dependencies :
modules/scripts-utils/mathcat-adapter/.test-dependencies :

.SECONDARY : modules/scripts-utils/mathcat-adapter/.release

clean : modules/scripts-utils/mathcat-adapter/.clean
.PHONY : modules/scripts-utils/mathcat-adapter/.clean
modules/scripts-utils/mathcat-adapter/.clean :
	rm("modules/scripts-utils/mathcat-adapter/target");
