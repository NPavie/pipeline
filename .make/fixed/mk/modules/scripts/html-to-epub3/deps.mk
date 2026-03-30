modules/scripts/html-to-epub3/VERSION := 2.5.2

$(TARGET_DIR)/state/modules/scripts/html-to-epub3/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/html-to-epub3/.test
modules/scripts/html-to-epub3/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-epub3/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-epub3/2.5.2/html-to-epub3-2.5.2.pom : modules/scripts/html-to-epub3/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/html-to-epub3/2.5.2/html-to-epub3-2.5.2% : modules/scripts/html-to-epub3/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/html-to-epub3/.install.pom
modules/scripts/html-to-epub3/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/html-to-epub3");

modules/scripts/html-to-epub3/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-epub3/.install.jar
modules/scripts/html-to-epub3/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/html-to-epub3/.install
modules/scripts/html-to-epub3/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-epub3/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-epub3/.install-doc.jar
modules/scripts/html-to-epub3/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-epub3/.install-xprocdoc.jar
modules/scripts/html-to-epub3/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/html-to-epub3/.install-doc
modules/scripts/html-to-epub3/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/html-to-epub3/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/html-to-epub3/.compile-dependencies modules/scripts/html-to-epub3/.test-dependencies
modules/scripts/html-to-epub3/.compile-dependencies :
modules/scripts/html-to-epub3/.test-dependencies :

.SECONDARY : modules/scripts/html-to-epub3/.release

clean : modules/scripts/html-to-epub3/.clean
.PHONY : modules/scripts/html-to-epub3/.clean
modules/scripts/html-to-epub3/.clean :
	rm("modules/scripts/html-to-epub3/target");
