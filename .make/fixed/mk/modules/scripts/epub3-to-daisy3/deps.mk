modules/scripts/epub3-to-daisy3/VERSION := 1.0.13

$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy3/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/epub3-to-daisy3/.test
modules/scripts/epub3-to-daisy3/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13/epub3-to-daisy3-1.0.13.pom : modules/scripts/epub3-to-daisy3/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy3/1.0.13/epub3-to-daisy3-1.0.13% : modules/scripts/epub3-to-daisy3/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/epub3-to-daisy3/.install.pom
modules/scripts/epub3-to-daisy3/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/epub3-to-daisy3");

modules/scripts/epub3-to-daisy3/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.install.jar
modules/scripts/epub3-to-daisy3/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/epub3-to-daisy3/.install
modules/scripts/epub3-to-daisy3/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-doc.jar
modules/scripts/epub3-to-daisy3/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-xprocdoc.jar
modules/scripts/epub3-to-daisy3/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy3/.install-doc
modules/scripts/epub3-to-daisy3/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy3/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy3/.compile-dependencies modules/scripts/epub3-to-daisy3/.test-dependencies
modules/scripts/epub3-to-daisy3/.compile-dependencies :
modules/scripts/epub3-to-daisy3/.test-dependencies :

.SECONDARY : modules/scripts/epub3-to-daisy3/.release

clean : modules/scripts/epub3-to-daisy3/.clean
.PHONY : modules/scripts/epub3-to-daisy3/.clean
modules/scripts/epub3-to-daisy3/.clean :
	rm("modules/scripts/epub3-to-daisy3/target");
