modules/scripts/zedai-to-html/VERSION := 2.6.2

$(TARGET_DIR)/state/modules/scripts/zedai-to-html/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/zedai-to-html/.test
modules/scripts/zedai-to-html/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-html/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-html/2.6.2/zedai-to-html-2.6.2.pom : modules/scripts/zedai-to-html/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/zedai-to-html/2.6.2/zedai-to-html-2.6.2% : modules/scripts/zedai-to-html/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/zedai-to-html/.install.pom
modules/scripts/zedai-to-html/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/zedai-to-html");

modules/scripts/zedai-to-html/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-html/.install.jar
modules/scripts/zedai-to-html/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/zedai-to-html/.install
modules/scripts/zedai-to-html/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-html/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-html/.install-doc.jar
modules/scripts/zedai-to-html/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/zedai-to-html/.install-xprocdoc.jar
modules/scripts/zedai-to-html/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/zedai-to-html/.install-doc
modules/scripts/zedai-to-html/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/zedai-to-html/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/zedai-to-html/.compile-dependencies modules/scripts/zedai-to-html/.test-dependencies
modules/scripts/zedai-to-html/.compile-dependencies :
modules/scripts/zedai-to-html/.test-dependencies :

.SECONDARY : modules/scripts/zedai-to-html/.release

clean : modules/scripts/zedai-to-html/.clean
.PHONY : modules/scripts/zedai-to-html/.clean
modules/scripts/zedai-to-html/.clean :
	rm("modules/scripts/zedai-to-html/target");
