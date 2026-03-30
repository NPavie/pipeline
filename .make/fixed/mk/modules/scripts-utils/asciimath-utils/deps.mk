modules/scripts-utils/asciimath-utils/VERSION := 2.0.1

$(TARGET_DIR)/state/modules/scripts-utils/asciimath-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/asciimath-utils/.test
modules/scripts-utils/asciimath-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/asciimath-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/asciimath-utils/2.0.1/asciimath-utils-2.0.1.pom : modules/scripts-utils/asciimath-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/asciimath-utils/2.0.1/asciimath-utils-2.0.1% : modules/scripts-utils/asciimath-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/asciimath-utils/.install.pom
modules/scripts-utils/asciimath-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/asciimath-utils");

modules/scripts-utils/asciimath-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/asciimath-utils/.install.jar
modules/scripts-utils/asciimath-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/asciimath-utils/.install
modules/scripts-utils/asciimath-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/asciimath-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/asciimath-utils/.install-doc.jar
modules/scripts-utils/asciimath-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/asciimath-utils/.install-xprocdoc.jar
modules/scripts-utils/asciimath-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/asciimath-utils/.install-doc
modules/scripts-utils/asciimath-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/asciimath-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/asciimath-utils/.compile-dependencies modules/scripts-utils/asciimath-utils/.test-dependencies
modules/scripts-utils/asciimath-utils/.compile-dependencies :
modules/scripts-utils/asciimath-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/asciimath-utils/.release

clean : modules/scripts-utils/asciimath-utils/.clean
.PHONY : modules/scripts-utils/asciimath-utils/.clean
modules/scripts-utils/asciimath-utils/.clean :
	rm("modules/scripts-utils/asciimath-utils/target");
