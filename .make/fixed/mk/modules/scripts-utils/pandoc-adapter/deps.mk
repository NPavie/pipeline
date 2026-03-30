modules/scripts-utils/pandoc-adapter/VERSION := 1.0.0

$(TARGET_DIR)/state/modules/scripts-utils/pandoc-adapter/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/pandoc-adapter/.test
modules/scripts-utils/pandoc-adapter/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/pandoc-adapter/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/pandoc-adapter/1.0.0/pandoc-adapter-1.0.0.pom : modules/scripts-utils/pandoc-adapter/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/pandoc-adapter/1.0.0/pandoc-adapter-1.0.0% : modules/scripts-utils/pandoc-adapter/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install.pom
modules/scripts-utils/pandoc-adapter/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/pandoc-adapter");

modules/scripts-utils/pandoc-adapter/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install.jar
modules/scripts-utils/pandoc-adapter/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install
modules/scripts-utils/pandoc-adapter/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/pandoc-adapter/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install-doc.jar
modules/scripts-utils/pandoc-adapter/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install-xprocdoc.jar
modules/scripts-utils/pandoc-adapter/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/pandoc-adapter/.install-doc
modules/scripts-utils/pandoc-adapter/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/pandoc-adapter/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/pandoc-adapter/.compile-dependencies modules/scripts-utils/pandoc-adapter/.test-dependencies
modules/scripts-utils/pandoc-adapter/.compile-dependencies :
modules/scripts-utils/pandoc-adapter/.test-dependencies :

.SECONDARY : modules/scripts-utils/pandoc-adapter/.release

clean : modules/scripts-utils/pandoc-adapter/.clean
.PHONY : modules/scripts-utils/pandoc-adapter/.clean
modules/scripts-utils/pandoc-adapter/.clean :
	rm("modules/scripts-utils/pandoc-adapter/target");
