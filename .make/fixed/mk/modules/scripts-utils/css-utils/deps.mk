modules/scripts-utils/css-utils/VERSION := 8.0.0

$(TARGET_DIR)/state/modules/scripts-utils/css-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/css-utils/.test
modules/scripts-utils/css-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/css-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/8.0.0/css-utils-8.0.0.pom : modules/scripts-utils/css-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/css-utils/8.0.0/css-utils-8.0.0% : modules/scripts-utils/css-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/css-utils/.install.pom
modules/scripts-utils/css-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/css-utils");

modules/scripts-utils/css-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/css-utils/.install.jar
modules/scripts-utils/css-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/css-utils/.install
modules/scripts-utils/css-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/css-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/css-utils/.install-doc.jar
modules/scripts-utils/css-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/css-utils/.install-xprocdoc.jar
modules/scripts-utils/css-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/css-utils/.install-javadoc.jar
modules/scripts-utils/css-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/css-utils/.install-doc
modules/scripts-utils/css-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/css-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/css-utils/.compile-dependencies modules/scripts-utils/css-utils/.test-dependencies
modules/scripts-utils/css-utils/.compile-dependencies :
modules/scripts-utils/css-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/css-utils/.release

clean : modules/scripts-utils/css-utils/.clean
.PHONY : modules/scripts-utils/css-utils/.clean
modules/scripts-utils/css-utils/.clean :
	rm("modules/scripts-utils/css-utils/target");
