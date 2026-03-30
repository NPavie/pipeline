modules/scripts/dtbook-to-ebraille/VERSION := 1.2.0

$(TARGET_DIR)/state/modules/scripts/dtbook-to-ebraille/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts/dtbook-to-ebraille/.test
modules/scripts/dtbook-to-ebraille/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.2.0/dtbook-to-ebraille-1.2.0.pom : modules/scripts/dtbook-to-ebraille/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-to-ebraille/1.2.0/dtbook-to-ebraille-1.2.0% : modules/scripts/dtbook-to-ebraille/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install.pom
modules/scripts/dtbook-to-ebraille/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts/dtbook-to-ebraille");

modules/scripts/dtbook-to-ebraille/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install.jar
modules/scripts/dtbook-to-ebraille/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install
modules/scripts/dtbook-to-ebraille/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-doc.jar
modules/scripts/dtbook-to-ebraille/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-xprocdoc.jar
modules/scripts/dtbook-to-ebraille/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts/dtbook-to-ebraille/.install-doc
modules/scripts/dtbook-to-ebraille/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts/dtbook-to-ebraille/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts/dtbook-to-ebraille/.compile-dependencies modules/scripts/dtbook-to-ebraille/.test-dependencies
modules/scripts/dtbook-to-ebraille/.compile-dependencies :
modules/scripts/dtbook-to-ebraille/.test-dependencies :

.SECONDARY : modules/scripts/dtbook-to-ebraille/.release

clean : modules/scripts/dtbook-to-ebraille/.clean
.PHONY : modules/scripts/dtbook-to-ebraille/.clean
modules/scripts/dtbook-to-ebraille/.clean :
	rm("modules/scripts/dtbook-to-ebraille/target");
