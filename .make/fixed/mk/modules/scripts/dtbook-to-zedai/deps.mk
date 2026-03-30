modules/scripts/dtbook-to-zedai/VERSION := 4.2.0

$(TARGET_DIR)/state/modules/scripts/dtbook-to-zedai/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-zedai/.test
modules/scripts/dtbook-to-zedai/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-zedai/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-zedai/4.2.0/dtbook-to-zedai-4.2.0.pom : modules/scripts/dtbook-to-zedai/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-zedai/4.2.0/dtbook-to-zedai-4.2.0% : modules/scripts/dtbook-to-zedai/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-zedai/.install.pom
modules/scripts/dtbook-to-zedai/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-zedai");

modules/scripts/dtbook-to-zedai/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-zedai/.install.jar
modules/scripts/dtbook-to-zedai/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-zedai/.install
modules/scripts/dtbook-to-zedai/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-zedai/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-zedai/.install-doc.jar
modules/scripts/dtbook-to-zedai/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-zedai/.install-xprocdoc.jar
modules/scripts/dtbook-to-zedai/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-zedai/.install-doc
modules/scripts/dtbook-to-zedai/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-zedai/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-zedai/.compile-dependencies modules/scripts/dtbook-to-zedai/.test-dependencies
modules/scripts/dtbook-to-zedai/.compile-dependencies :
modules/scripts/dtbook-to-zedai/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-zedai/.release

clean : modules/scripts/dtbook-to-zedai/.clean
.PHONY : modules/scripts/dtbook-to-zedai/.clean
modules/scripts/dtbook-to-zedai/.clean :
	rm("modules/scripts/dtbook-to-zedai/target");
