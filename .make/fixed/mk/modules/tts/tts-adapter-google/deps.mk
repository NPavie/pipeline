modules/tts/tts-adapter-google/VERSION := 1.3.2

$(TARGET_DIR)/state/modules/tts/tts-adapter-google/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-google/.test
modules/tts/tts-adapter-google/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-google/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-google/1.3.2/tts-adapter-google-1.3.2.pom : modules/tts/tts-adapter-google/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-google/1.3.2/tts-adapter-google-1.3.2% : modules/tts/tts-adapter-google/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-google/.install.pom
modules/tts/tts-adapter-google/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-google");

modules/tts/tts-adapter-google/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-google/.install.jar
modules/tts/tts-adapter-google/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-google/.install
modules/tts/tts-adapter-google/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-google/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-google/.install-doc.jar
modules/tts/tts-adapter-google/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-google/.install-xprocdoc.jar
modules/tts/tts-adapter-google/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-google/.install-doc
modules/tts/tts-adapter-google/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-google/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-google/.compile-dependencies modules/tts/tts-adapter-google/.test-dependencies
modules/tts/tts-adapter-google/.compile-dependencies :
modules/tts/tts-adapter-google/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-google/.release

clean : modules/tts/tts-adapter-google/.clean
.PHONY : modules/tts/tts-adapter-google/.clean
modules/tts/tts-adapter-google/.clean :
	rm("modules/tts/tts-adapter-google/target");
