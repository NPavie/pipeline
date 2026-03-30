modules/scripts-utils/ocr-utils/VERSION := 1.0.0

$(TARGET_DIR)/state/modules/scripts-utils/ocr-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/ocr-utils/.test
modules/scripts-utils/ocr-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ocr-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ocr-utils/1.0.0/ocr-utils-1.0.0.pom : modules/scripts-utils/ocr-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/ocr-utils/1.0.0/ocr-utils-1.0.0% : modules/scripts-utils/ocr-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/ocr-utils/.install.pom
modules/scripts-utils/ocr-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/ocr-utils");

modules/scripts-utils/ocr-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ocr-utils/.install.jar
modules/scripts-utils/ocr-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/ocr-utils/.install
modules/scripts-utils/ocr-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ocr-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ocr-utils/.install-doc.jar
modules/scripts-utils/ocr-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/ocr-utils/.install-xprocdoc.jar
modules/scripts-utils/ocr-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/ocr-utils/.install-javadoc.jar
modules/scripts-utils/ocr-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/ocr-utils/.install-doc
modules/scripts-utils/ocr-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/ocr-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/ocr-utils/.compile-dependencies modules/scripts-utils/ocr-utils/.test-dependencies
modules/scripts-utils/ocr-utils/.compile-dependencies :
modules/scripts-utils/ocr-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/ocr-utils/.release

clean : modules/scripts-utils/ocr-utils/.clean
.PHONY : modules/scripts-utils/ocr-utils/.clean
modules/scripts-utils/ocr-utils/.clean :
	rm("modules/scripts-utils/ocr-utils/target");
