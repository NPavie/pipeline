modules/common/validation-utils/VERSION := 2.0.3

$(TARGET_DIR)/state/modules/common/validation-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/common/validation-utils/.test
modules/common/validation-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/validation-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3/validation-utils-2.0.3.pom : modules/common/validation-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/validation-utils/2.0.3/validation-utils-2.0.3% : modules/common/validation-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/validation-utils/.install.pom
modules/common/validation-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/validation-utils");

modules/common/validation-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/validation-utils/.install.jar
modules/common/validation-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/validation-utils/.install
modules/common/validation-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/validation-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/validation-utils/.install-doc.jar
modules/common/validation-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/validation-utils/.install-xprocdoc.jar
modules/common/validation-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/validation-utils/.install-doc
modules/common/validation-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/validation-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/validation-utils/.compile-dependencies modules/common/validation-utils/.test-dependencies
modules/common/validation-utils/.compile-dependencies :
modules/common/validation-utils/.test-dependencies :

.SECONDARY : modules/common/validation-utils/.release

clean : modules/common/validation-utils/.clean
.PHONY : modules/common/validation-utils/.clean
modules/common/validation-utils/.clean :
	rm("modules/common/validation-utils/target");
