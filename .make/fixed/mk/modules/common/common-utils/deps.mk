modules/common/common-utils/VERSION := 3.4.0

$(TARGET_DIR)/state/modules/common/common-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/common/common-utils/.test
modules/common/common-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/common-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.4.0/common-utils-3.4.0.pom : modules/common/common-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.4.0/common-utils-3.4.0% : modules/common/common-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/common-utils/.install.pom
modules/common/common-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/common-utils");

modules/common/common-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/common-utils/.install.jar
modules/common/common-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/common-utils/.install
modules/common/common-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/common-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/common-utils/.install-doc.jar
modules/common/common-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/common-utils/.install-xprocdoc.jar
modules/common/common-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/common-utils/.install-doc
modules/common/common-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/common-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/common-utils/.compile-dependencies modules/common/common-utils/.test-dependencies
modules/common/common-utils/.compile-dependencies :
modules/common/common-utils/.test-dependencies :

.SECONDARY : modules/common/common-utils/.release

clean : modules/common/common-utils/.clean
.PHONY : modules/common/common-utils/.clean
modules/common/common-utils/.clean :
	rm("modules/common/common-utils/target");
