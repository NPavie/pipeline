modules/common/file-utils/VERSION := 5.0.0

$(TARGET_DIR)/state/modules/common/file-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/common/file-utils/.test
modules/common/file-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/file-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/5.0.0/file-utils-5.0.0.pom : modules/common/file-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/5.0.0/file-utils-5.0.0% : modules/common/file-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/file-utils/.install.pom
modules/common/file-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/file-utils");

modules/common/file-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/file-utils/.install.jar
modules/common/file-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/file-utils/.install
modules/common/file-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/file-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/file-utils/.install-doc.jar
modules/common/file-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/file-utils/.install-xprocdoc.jar
modules/common/file-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/file-utils/.install-doc
modules/common/file-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/file-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/file-utils/.compile-dependencies modules/common/file-utils/.test-dependencies
modules/common/file-utils/.compile-dependencies :
modules/common/file-utils/.test-dependencies :

.SECONDARY : modules/common/file-utils/.release

clean : modules/common/file-utils/.clean
.PHONY : modules/common/file-utils/.clean
modules/common/file-utils/.clean :
	rm("modules/common/file-utils/target");
