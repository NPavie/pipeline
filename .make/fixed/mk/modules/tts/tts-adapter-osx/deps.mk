modules/tts/tts-adapter-osx/VERSION := 3.2.1

$(TARGET_DIR)/state/modules/tts/tts-adapter-osx/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-osx/.test
modules/tts/tts-adapter-osx/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-osx/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-osx/3.2.1/tts-adapter-osx-3.2.1.pom : modules/tts/tts-adapter-osx/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-osx/3.2.1/tts-adapter-osx-3.2.1% : modules/tts/tts-adapter-osx/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-osx/.install.pom
modules/tts/tts-adapter-osx/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-osx");

modules/tts/tts-adapter-osx/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-osx/.install.jar
modules/tts/tts-adapter-osx/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-osx/.install
modules/tts/tts-adapter-osx/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-osx/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-osx/.install-doc.jar
modules/tts/tts-adapter-osx/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-osx/.install-xprocdoc.jar
modules/tts/tts-adapter-osx/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-osx/.install-doc
modules/tts/tts-adapter-osx/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-osx/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-osx/.compile-dependencies modules/tts/tts-adapter-osx/.test-dependencies
modules/tts/tts-adapter-osx/.compile-dependencies :
modules/tts/tts-adapter-osx/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-osx/.release

clean : modules/tts/tts-adapter-osx/.clean
.PHONY : modules/tts/tts-adapter-osx/.clean
modules/tts/tts-adapter-osx/.clean :
	rm("modules/tts/tts-adapter-osx/target");
