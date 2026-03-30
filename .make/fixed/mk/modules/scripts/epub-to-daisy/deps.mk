modules/scripts/epub-to-daisy/VERSION := 1.5.0

$(TARGET_DIR)/state/modules/scripts/epub-to-daisy/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/epub-to-daisy/.test
modules/scripts/epub-to-daisy/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub-to-daisy/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-to-daisy/1.5.0/epub-to-daisy-1.5.0.pom : modules/scripts/epub-to-daisy/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub-to-daisy/1.5.0/epub-to-daisy-1.5.0% : modules/scripts/epub-to-daisy/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/epub-to-daisy/.install.pom
modules/scripts/epub-to-daisy/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/epub-to-daisy");

modules/scripts/epub-to-daisy/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub-to-daisy/.install.jar
modules/scripts/epub-to-daisy/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/epub-to-daisy/.install
modules/scripts/epub-to-daisy/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub-to-daisy/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub-to-daisy/.install-doc.jar
modules/scripts/epub-to-daisy/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub-to-daisy/.install-xprocdoc.jar
modules/scripts/epub-to-daisy/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub-to-daisy/.install-doc
modules/scripts/epub-to-daisy/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub-to-daisy/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub-to-daisy/.compile-dependencies modules/scripts/epub-to-daisy/.test-dependencies
modules/scripts/epub-to-daisy/.compile-dependencies :
modules/scripts/epub-to-daisy/.test-dependencies :

.SECONDARY : modules/scripts/epub-to-daisy/.release

clean : modules/scripts/epub-to-daisy/.clean
.PHONY : modules/scripts/epub-to-daisy/.clean
modules/scripts/epub-to-daisy/.clean :
	rm("modules/scripts/epub-to-daisy/target");
