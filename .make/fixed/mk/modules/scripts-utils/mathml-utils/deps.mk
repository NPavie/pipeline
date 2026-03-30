modules/scripts-utils/mathml-utils/VERSION := 1.1.1

$(TARGET_DIR)/state/modules/scripts-utils/mathml-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/mathml-utils/.test
modules/scripts-utils/mathml-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathml-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1/mathml-utils-1.1.1.pom : modules/scripts-utils/mathml-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mathml-utils/1.1.1/mathml-utils-1.1.1% : modules/scripts-utils/mathml-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/mathml-utils/.install.pom
modules/scripts-utils/mathml-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/mathml-utils");

modules/scripts-utils/mathml-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathml-utils/.install.jar
modules/scripts-utils/mathml-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/mathml-utils/.install
modules/scripts-utils/mathml-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathml-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathml-utils/.install-doc.jar
modules/scripts-utils/mathml-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/mathml-utils/.install-xprocdoc.jar
modules/scripts-utils/mathml-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/mathml-utils/.install-doc
modules/scripts-utils/mathml-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/mathml-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/mathml-utils/.compile-dependencies modules/scripts-utils/mathml-utils/.test-dependencies
modules/scripts-utils/mathml-utils/.compile-dependencies :
modules/scripts-utils/mathml-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/mathml-utils/.release

clean : modules/scripts-utils/mathml-utils/.clean
.PHONY : modules/scripts-utils/mathml-utils/.clean
modules/scripts-utils/mathml-utils/.clean :
	rm("modules/scripts-utils/mathml-utils/target");
