modules/scripts/epub3-to-daisy202/VERSION := 2.2.11

$(TARGET_DIR)/state/modules/scripts/epub3-to-daisy202/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/epub3-to-daisy202/.test
modules/scripts/epub3-to-daisy202/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy202/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy202/2.2.11/epub3-to-daisy202-2.2.11.pom : modules/scripts/epub3-to-daisy202/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epub3-to-daisy202/2.2.11/epub3-to-daisy202-2.2.11% : modules/scripts/epub3-to-daisy202/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/epub3-to-daisy202/.install.pom
modules/scripts/epub3-to-daisy202/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/epub3-to-daisy202");

modules/scripts/epub3-to-daisy202/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy202/.install.jar
modules/scripts/epub3-to-daisy202/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/epub3-to-daisy202/.install
modules/scripts/epub3-to-daisy202/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy202/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy202/.install-doc.jar
modules/scripts/epub3-to-daisy202/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy202/.install-xprocdoc.jar
modules/scripts/epub3-to-daisy202/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/epub3-to-daisy202/.install-doc
modules/scripts/epub3-to-daisy202/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/epub3-to-daisy202/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/epub3-to-daisy202/.compile-dependencies modules/scripts/epub3-to-daisy202/.test-dependencies
modules/scripts/epub3-to-daisy202/.compile-dependencies :
modules/scripts/epub3-to-daisy202/.test-dependencies :

.SECONDARY : modules/scripts/epub3-to-daisy202/.release

clean : modules/scripts/epub3-to-daisy202/.clean
.PHONY : modules/scripts/epub3-to-daisy202/.clean
modules/scripts/epub3-to-daisy202/.clean :
	rm("modules/scripts/epub3-to-daisy202/target");
