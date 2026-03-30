modules/scripts-utils/dtbook-utils/VERSION := 6.1.0

$(TARGET_DIR)/state/modules/scripts-utils/dtbook-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/dtbook-utils/.test
modules/scripts-utils/dtbook-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/dtbook-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.1.0/dtbook-utils-6.1.0.pom : modules/scripts-utils/dtbook-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/dtbook-utils/6.1.0/dtbook-utils-6.1.0% : modules/scripts-utils/dtbook-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/dtbook-utils/.install.pom
modules/scripts-utils/dtbook-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/dtbook-utils");

modules/scripts-utils/dtbook-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/dtbook-utils/.install.jar
modules/scripts-utils/dtbook-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/dtbook-utils/.install
modules/scripts-utils/dtbook-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/dtbook-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/dtbook-utils/.install-doc.jar
modules/scripts-utils/dtbook-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/dtbook-utils/.install-xprocdoc.jar
modules/scripts-utils/dtbook-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/dtbook-utils/.install-doc
modules/scripts-utils/dtbook-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/dtbook-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/dtbook-utils/.compile-dependencies modules/scripts-utils/dtbook-utils/.test-dependencies
modules/scripts-utils/dtbook-utils/.compile-dependencies :
modules/scripts-utils/dtbook-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/dtbook-utils/.release

clean : modules/scripts-utils/dtbook-utils/.clean
.PHONY : modules/scripts-utils/dtbook-utils/.clean
modules/scripts-utils/dtbook-utils/.clean :
	rm("modules/scripts-utils/dtbook-utils/target");
