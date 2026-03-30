modules/scripts-utils/ace-adapter/VERSION := 1.0.12

$(TARGET_DIR)/state/modules/scripts-utils/ace-adapter/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/ace-adapter/.test
modules/scripts-utils/ace-adapter/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ace-adapter/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12/ace-adapter-1.0.12.pom : modules/scripts-utils/ace-adapter/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ace-adapter/1.0.12/ace-adapter-1.0.12% : modules/scripts-utils/ace-adapter/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/ace-adapter/.install.pom
modules/scripts-utils/ace-adapter/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/ace-adapter");

modules/scripts-utils/ace-adapter/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ace-adapter/.install.jar
modules/scripts-utils/ace-adapter/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/ace-adapter/.install
modules/scripts-utils/ace-adapter/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ace-adapter/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ace-adapter/.install-doc.jar
modules/scripts-utils/ace-adapter/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/ace-adapter/.install-xprocdoc.jar
modules/scripts-utils/ace-adapter/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/ace-adapter/.install-doc
modules/scripts-utils/ace-adapter/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ace-adapter/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ace-adapter/.compile-dependencies modules/scripts-utils/ace-adapter/.test-dependencies
modules/scripts-utils/ace-adapter/.compile-dependencies :
modules/scripts-utils/ace-adapter/.test-dependencies :

.SECONDARY : modules/scripts-utils/ace-adapter/.release

clean : modules/scripts-utils/ace-adapter/.clean
.PHONY : modules/scripts-utils/ace-adapter/.clean
modules/scripts-utils/ace-adapter/.clean :
	rm("modules/scripts-utils/ace-adapter/target");
