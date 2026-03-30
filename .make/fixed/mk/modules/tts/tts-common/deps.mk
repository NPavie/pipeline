modules/tts/tts-common/VERSION := 9.0.0

$(TARGET_DIR)/state/modules/tts/tts-common/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-common/.test
modules/tts/tts-common/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-common/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/9.0.0/tts-common-9.0.0.pom : modules/tts/tts-common/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-common/9.0.0/tts-common-9.0.0% : modules/tts/tts-common/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-common/.install.pom
modules/tts/tts-common/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-common");

modules/tts/tts-common/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-common/.install.jar
modules/tts/tts-common/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-common/.install
modules/tts/tts-common/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-common/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-common/.install-doc.jar
modules/tts/tts-common/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-common/.install-xprocdoc.jar
modules/tts/tts-common/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-common/.install-javadoc.jar
modules/tts/tts-common/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-common/.install-doc
modules/tts/tts-common/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-common/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-common/.compile-dependencies modules/tts/tts-common/.test-dependencies
modules/tts/tts-common/.compile-dependencies :
modules/tts/tts-common/.test-dependencies :

.SECONDARY : modules/tts/tts-common/.release

clean : modules/tts/tts-common/.clean
.PHONY : modules/tts/tts-common/.clean
modules/tts/tts-common/.clean :
	rm("modules/tts/tts-common/target");
