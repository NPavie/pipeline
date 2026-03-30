modules/tts/tts-adapter-azure/VERSION := 1.1.4

$(TARGET_DIR)/state/modules/tts/tts-adapter-azure/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-azure/.test
modules/tts/tts-adapter-azure/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-azure/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-azure/1.1.4/tts-adapter-azure-1.1.4.pom : modules/tts/tts-adapter-azure/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-azure/1.1.4/tts-adapter-azure-1.1.4% : modules/tts/tts-adapter-azure/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-azure/.install.pom
modules/tts/tts-adapter-azure/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-azure");

modules/tts/tts-adapter-azure/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-azure/.install.jar
modules/tts/tts-adapter-azure/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-azure/.install
modules/tts/tts-adapter-azure/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-azure/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-azure/.install-doc.jar
modules/tts/tts-adapter-azure/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-azure/.install-xprocdoc.jar
modules/tts/tts-adapter-azure/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-azure/.install-doc
modules/tts/tts-adapter-azure/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-azure/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-azure/.compile-dependencies modules/tts/tts-adapter-azure/.test-dependencies
modules/tts/tts-adapter-azure/.compile-dependencies :
modules/tts/tts-adapter-azure/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-azure/.release

clean : modules/tts/tts-adapter-azure/.clean
.PHONY : modules/tts/tts-adapter-azure/.clean
modules/tts/tts-adapter-azure/.clean :
	rm("modules/tts/tts-adapter-azure/target");
