modules/scripts-utils/epub-utils/VERSION := 2.4.1

$(TARGET_DIR)/state/modules/scripts-utils/epub-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/epub-utils/.test
modules/scripts-utils/epub-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epub-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1/epub-utils-2.4.1.pom : modules/scripts-utils/epub-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-utils/2.4.1/epub-utils-2.4.1% : modules/scripts-utils/epub-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/epub-utils/.install.pom
modules/scripts-utils/epub-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/epub-utils");

modules/scripts-utils/epub-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/epub-utils/.install.jar
modules/scripts-utils/epub-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/epub-utils/.install
modules/scripts-utils/epub-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epub-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/epub-utils/.install-doc.jar
modules/scripts-utils/epub-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/epub-utils/.install-xprocdoc.jar
modules/scripts-utils/epub-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/epub-utils/.install-doc
modules/scripts-utils/epub-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epub-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/epub-utils/.compile-dependencies modules/scripts-utils/epub-utils/.test-dependencies
modules/scripts-utils/epub-utils/.compile-dependencies :
modules/scripts-utils/epub-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/epub-utils/.release

clean : modules/scripts-utils/epub-utils/.clean
.PHONY : modules/scripts-utils/epub-utils/.clean
modules/scripts-utils/epub-utils/.clean :
	rm("modules/scripts-utils/epub-utils/target");
