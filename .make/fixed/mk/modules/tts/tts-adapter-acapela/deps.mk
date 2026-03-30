modules/tts/tts-adapter-acapela/VERSION := 3.1.8

$(TARGET_DIR)/state/modules/tts/tts-adapter-acapela/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-acapela/.test
modules/tts/tts-adapter-acapela/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-acapela/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-acapela/3.1.8/tts-adapter-acapela-3.1.8.pom : modules/tts/tts-adapter-acapela/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-acapela/3.1.8/tts-adapter-acapela-3.1.8% : modules/tts/tts-adapter-acapela/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-acapela/.install.pom
modules/tts/tts-adapter-acapela/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-acapela");

modules/tts/tts-adapter-acapela/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-acapela/.install.jar
modules/tts/tts-adapter-acapela/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-acapela/.install
modules/tts/tts-adapter-acapela/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-acapela/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-acapela/.install-doc.jar
modules/tts/tts-adapter-acapela/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-acapela/.install-xprocdoc.jar
modules/tts/tts-adapter-acapela/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-acapela/.install-doc
modules/tts/tts-adapter-acapela/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-acapela/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-acapela/.compile-dependencies modules/tts/tts-adapter-acapela/.test-dependencies
modules/tts/tts-adapter-acapela/.compile-dependencies :
modules/tts/tts-adapter-acapela/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-acapela/.release

clean : modules/tts/tts-adapter-acapela/.clean
.PHONY : modules/tts/tts-adapter-acapela/.clean
modules/tts/tts-adapter-acapela/.clean :
	rm("modules/tts/tts-adapter-acapela/target");
