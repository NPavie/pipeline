modules/common/fileset-utils/VERSION := 8.0.0

$(TARGET_DIR)/state/modules/common/fileset-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/common/fileset-utils/.test
modules/common/fileset-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/fileset-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/8.0.0/fileset-utils-8.0.0.pom : modules/common/fileset-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/fileset-utils/8.0.0/fileset-utils-8.0.0% : modules/common/fileset-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/fileset-utils/.install.pom
modules/common/fileset-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/fileset-utils");

modules/common/fileset-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/fileset-utils/.install.jar
modules/common/fileset-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/fileset-utils/.install
modules/common/fileset-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/fileset-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/fileset-utils/.install-doc.jar
modules/common/fileset-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/fileset-utils/.install-xprocdoc.jar
modules/common/fileset-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/fileset-utils/.install-doc
modules/common/fileset-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/fileset-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/fileset-utils/.compile-dependencies modules/common/fileset-utils/.test-dependencies
modules/common/fileset-utils/.compile-dependencies :
modules/common/fileset-utils/.test-dependencies :

.SECONDARY : modules/common/fileset-utils/.release

clean : modules/common/fileset-utils/.clean
.PHONY : modules/common/fileset-utils/.clean
modules/common/fileset-utils/.clean :
	rm("modules/common/fileset-utils/target");
