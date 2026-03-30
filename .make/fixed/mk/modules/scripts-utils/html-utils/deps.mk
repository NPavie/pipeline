modules/scripts-utils/html-utils/VERSION := 6.6.0

$(TARGET_DIR)/state/modules/scripts-utils/html-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/html-utils/.test
modules/scripts-utils/html-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/html-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.6.0/html-utils-6.6.0.pom : modules/scripts-utils/html-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-utils/6.6.0/html-utils-6.6.0% : modules/scripts-utils/html-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/html-utils/.install.pom
modules/scripts-utils/html-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/html-utils");

modules/scripts-utils/html-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/html-utils/.install.jar
modules/scripts-utils/html-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/html-utils/.install
modules/scripts-utils/html-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/html-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/html-utils/.install-doc.jar
modules/scripts-utils/html-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/html-utils/.install-xprocdoc.jar
modules/scripts-utils/html-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/html-utils/.install-doc
modules/scripts-utils/html-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/html-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/html-utils/.compile-dependencies modules/scripts-utils/html-utils/.test-dependencies
modules/scripts-utils/html-utils/.compile-dependencies :
modules/scripts-utils/html-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/html-utils/.release

clean : modules/scripts-utils/html-utils/.clean
.PHONY : modules/scripts-utils/html-utils/.clean
modules/scripts-utils/html-utils/.clean :
	rm("modules/scripts-utils/html-utils/target");
