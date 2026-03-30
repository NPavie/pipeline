modules/tts/tts-adapter-aws/VERSION := 1.0.2

$(TARGET_DIR)/state/modules/tts/tts-adapter-aws/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-aws/.test
modules/tts/tts-adapter-aws/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-aws/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-aws/1.0.2/tts-adapter-aws-1.0.2.pom : modules/tts/tts-adapter-aws/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-aws/1.0.2/tts-adapter-aws-1.0.2% : modules/tts/tts-adapter-aws/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-aws/.install.pom
modules/tts/tts-adapter-aws/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-aws");

modules/tts/tts-adapter-aws/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-aws/.install.jar
modules/tts/tts-adapter-aws/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-aws/.install
modules/tts/tts-adapter-aws/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-aws/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-aws/.install-doc.jar
modules/tts/tts-adapter-aws/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-aws/.install-xprocdoc.jar
modules/tts/tts-adapter-aws/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-aws/.install-doc
modules/tts/tts-adapter-aws/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-aws/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-aws/.compile-dependencies modules/tts/tts-adapter-aws/.test-dependencies
modules/tts/tts-adapter-aws/.compile-dependencies :
modules/tts/tts-adapter-aws/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-aws/.release

clean : modules/tts/tts-adapter-aws/.clean
.PHONY : modules/tts/tts-adapter-aws/.clean
modules/tts/tts-adapter-aws/.clean :
	rm("modules/tts/tts-adapter-aws/target");
