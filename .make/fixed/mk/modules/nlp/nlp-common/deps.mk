modules/nlp/nlp-common/VERSION := 3.0.5

$(TARGET_DIR)/state/modules/nlp/nlp-common/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/nlp/nlp-common/.test
modules/nlp/nlp-common/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.pom : modules/nlp/nlp-common/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5% : modules/nlp/nlp-common/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/nlp-common/.install.pom
modules/nlp/nlp-common/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/nlp-common");

modules/nlp/nlp-common/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.install.jar
modules/nlp/nlp-common/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/nlp-common/.install
modules/nlp/nlp-common/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.install-doc.jar
modules/nlp/nlp-common/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/nlp-common/.install-xprocdoc.jar
modules/nlp/nlp-common/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/nlp-common/.install-doc
modules/nlp/nlp-common/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.compile-dependencies modules/nlp/nlp-common/.test-dependencies
modules/nlp/nlp-common/.compile-dependencies :
modules/nlp/nlp-common/.test-dependencies :

.SECONDARY : modules/nlp/nlp-common/.release

clean : modules/nlp/nlp-common/.clean
.PHONY : modules/nlp/nlp-common/.clean
modules/nlp/nlp-common/.clean :
	rm("modules/nlp/nlp-common/target");
