modules/common/mediatype-utils/VERSION := 2.1.1

$(TARGET_DIR)/state/modules/common/mediatype-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/common/mediatype-utils/.test
modules/common/mediatype-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/mediatype-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1.pom : modules/common/mediatype-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/mediatype-utils/2.1.1/mediatype-utils-2.1.1% : modules/common/mediatype-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/mediatype-utils/.install.pom
modules/common/mediatype-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/mediatype-utils");

modules/common/mediatype-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/mediatype-utils/.install.jar
modules/common/mediatype-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/mediatype-utils/.install
modules/common/mediatype-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/mediatype-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/mediatype-utils/.install-doc.jar
modules/common/mediatype-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/mediatype-utils/.install-xprocdoc.jar
modules/common/mediatype-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/mediatype-utils/.install-doc
modules/common/mediatype-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/mediatype-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/mediatype-utils/.compile-dependencies modules/common/mediatype-utils/.test-dependencies
modules/common/mediatype-utils/.compile-dependencies :
modules/common/mediatype-utils/.test-dependencies :

.SECONDARY : modules/common/mediatype-utils/.release

clean : modules/common/mediatype-utils/.clean
.PHONY : modules/common/mediatype-utils/.clean
modules/common/mediatype-utils/.clean :
	rm("modules/common/mediatype-utils/target");
