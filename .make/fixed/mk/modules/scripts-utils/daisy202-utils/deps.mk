modules/scripts-utils/daisy202-utils/VERSION := 1.6.6

$(TARGET_DIR)/state/modules/scripts-utils/daisy202-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/daisy202-utils/.test
modules/scripts-utils/daisy202-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy202-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy202-utils/1.6.6/daisy202-utils-1.6.6.pom : modules/scripts-utils/daisy202-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy202-utils/1.6.6/daisy202-utils-1.6.6% : modules/scripts-utils/daisy202-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/daisy202-utils/.install.pom
modules/scripts-utils/daisy202-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/daisy202-utils");

modules/scripts-utils/daisy202-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy202-utils/.install.jar
modules/scripts-utils/daisy202-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/daisy202-utils/.install
modules/scripts-utils/daisy202-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy202-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy202-utils/.install-doc.jar
modules/scripts-utils/daisy202-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/daisy202-utils/.install-xprocdoc.jar
modules/scripts-utils/daisy202-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/daisy202-utils/.install-doc
modules/scripts-utils/daisy202-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy202-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy202-utils/.compile-dependencies modules/scripts-utils/daisy202-utils/.test-dependencies
modules/scripts-utils/daisy202-utils/.compile-dependencies :
modules/scripts-utils/daisy202-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/daisy202-utils/.release

clean : modules/scripts-utils/daisy202-utils/.clean
.PHONY : modules/scripts-utils/daisy202-utils/.clean
modules/scripts-utils/daisy202-utils/.clean :
	rm("modules/scripts-utils/daisy202-utils/target");
