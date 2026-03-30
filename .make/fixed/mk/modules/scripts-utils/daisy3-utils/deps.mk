modules/scripts-utils/daisy3-utils/VERSION := 4.2.1

$(TARGET_DIR)/state/modules/scripts-utils/daisy3-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/daisy3-utils/.test
modules/scripts-utils/daisy3-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy3-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1/daisy3-utils-4.2.1.pom : modules/scripts-utils/daisy3-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/daisy3-utils/4.2.1/daisy3-utils-4.2.1% : modules/scripts-utils/daisy3-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/daisy3-utils/.install.pom
modules/scripts-utils/daisy3-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/daisy3-utils");

modules/scripts-utils/daisy3-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy3-utils/.install.jar
modules/scripts-utils/daisy3-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/daisy3-utils/.install
modules/scripts-utils/daisy3-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy3-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy3-utils/.install-doc.jar
modules/scripts-utils/daisy3-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/daisy3-utils/.install-xprocdoc.jar
modules/scripts-utils/daisy3-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/daisy3-utils/.install-doc
modules/scripts-utils/daisy3-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/daisy3-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/daisy3-utils/.compile-dependencies modules/scripts-utils/daisy3-utils/.test-dependencies
modules/scripts-utils/daisy3-utils/.compile-dependencies :
modules/scripts-utils/daisy3-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/daisy3-utils/.release

clean : modules/scripts-utils/daisy3-utils/.clean
.PHONY : modules/scripts-utils/daisy3-utils/.clean
modules/scripts-utils/daisy3-utils/.clean :
	rm("modules/scripts-utils/daisy3-utils/target");
