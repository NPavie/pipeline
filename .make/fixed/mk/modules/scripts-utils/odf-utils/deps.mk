modules/scripts-utils/odf-utils/VERSION := 1.0.7

$(TARGET_DIR)/state/modules/scripts-utils/odf-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/odf-utils/.test
modules/scripts-utils/odf-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/odf-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7/odf-utils-1.0.7.pom : modules/scripts-utils/odf-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/odf-utils/1.0.7/odf-utils-1.0.7% : modules/scripts-utils/odf-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/odf-utils/.install.pom
modules/scripts-utils/odf-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/odf-utils");

modules/scripts-utils/odf-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/odf-utils/.install.jar
modules/scripts-utils/odf-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/odf-utils/.install
modules/scripts-utils/odf-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/odf-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/odf-utils/.install-doc.jar
modules/scripts-utils/odf-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/odf-utils/.install-xprocdoc.jar
modules/scripts-utils/odf-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/odf-utils/.install-doc
modules/scripts-utils/odf-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/odf-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/odf-utils/.compile-dependencies modules/scripts-utils/odf-utils/.test-dependencies
modules/scripts-utils/odf-utils/.compile-dependencies :
modules/scripts-utils/odf-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/odf-utils/.release

clean : modules/scripts-utils/odf-utils/.clean
.PHONY : modules/scripts-utils/odf-utils/.clean
modules/scripts-utils/odf-utils/.clean :
	rm("modules/scripts-utils/odf-utils/target");
