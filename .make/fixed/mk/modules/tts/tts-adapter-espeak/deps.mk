modules/tts/tts-adapter-espeak/VERSION := 3.0.17

$(TARGET_DIR)/state/modules/tts/tts-adapter-espeak/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-espeak/.test
modules/tts/tts-adapter-espeak/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-espeak/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-espeak/3.0.17/tts-adapter-espeak-3.0.17.pom : modules/tts/tts-adapter-espeak/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-espeak/3.0.17/tts-adapter-espeak-3.0.17% : modules/tts/tts-adapter-espeak/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-espeak/.install.pom
modules/tts/tts-adapter-espeak/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-espeak");

modules/tts/tts-adapter-espeak/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-espeak/.install.jar
modules/tts/tts-adapter-espeak/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-espeak/.install
modules/tts/tts-adapter-espeak/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-espeak/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-espeak/.install-doc.jar
modules/tts/tts-adapter-espeak/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-espeak/.install-xprocdoc.jar
modules/tts/tts-adapter-espeak/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-espeak/.install-doc
modules/tts/tts-adapter-espeak/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-espeak/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-espeak/.compile-dependencies modules/tts/tts-adapter-espeak/.test-dependencies
modules/tts/tts-adapter-espeak/.compile-dependencies :
modules/tts/tts-adapter-espeak/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-espeak/.release

clean : modules/tts/tts-adapter-espeak/.clean
.PHONY : modules/tts/tts-adapter-espeak/.clean
modules/tts/tts-adapter-espeak/.clean :
	rm("modules/tts/tts-adapter-espeak/target");
