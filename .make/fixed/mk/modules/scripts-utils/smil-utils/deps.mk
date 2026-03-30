modules/scripts-utils/smil-utils/VERSION := 4.0.4

$(TARGET_DIR)/state/modules/scripts-utils/smil-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/scripts-utils/smil-utils/.test
modules/scripts-utils/smil-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/smil-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4/smil-utils-4.0.4.pom : modules/scripts-utils/smil-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/smil-utils/4.0.4/smil-utils-4.0.4% : modules/scripts-utils/smil-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/smil-utils/.install.pom
modules/scripts-utils/smil-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/smil-utils");

modules/scripts-utils/smil-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/smil-utils/.install.jar
modules/scripts-utils/smil-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/smil-utils/.install
modules/scripts-utils/smil-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/smil-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/smil-utils/.install-doc.jar
modules/scripts-utils/smil-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/smil-utils/.install-xprocdoc.jar
modules/scripts-utils/smil-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/smil-utils/.install-doc
modules/scripts-utils/smil-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/smil-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/smil-utils/.compile-dependencies modules/scripts-utils/smil-utils/.test-dependencies
modules/scripts-utils/smil-utils/.compile-dependencies :
modules/scripts-utils/smil-utils/.test-dependencies :

.SECONDARY : modules/scripts-utils/smil-utils/.release

clean : modules/scripts-utils/smil-utils/.clean
.PHONY : modules/scripts-utils/smil-utils/.clean
modules/scripts-utils/smil-utils/.clean :
	rm("modules/scripts-utils/smil-utils/target");
