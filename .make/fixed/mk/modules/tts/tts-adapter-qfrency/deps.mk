modules/tts/tts-adapter-qfrency/VERSION := 1.0.13

$(TARGET_DIR)/state/modules/tts/tts-adapter-qfrency/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-qfrency/.test
modules/tts/tts-adapter-qfrency/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-qfrency/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-qfrency/1.0.13/tts-adapter-qfrency-1.0.13.pom : modules/tts/tts-adapter-qfrency/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-qfrency/1.0.13/tts-adapter-qfrency-1.0.13% : modules/tts/tts-adapter-qfrency/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-qfrency/.install.pom
modules/tts/tts-adapter-qfrency/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-qfrency");

modules/tts/tts-adapter-qfrency/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-qfrency/.install.jar
modules/tts/tts-adapter-qfrency/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-qfrency/.install
modules/tts/tts-adapter-qfrency/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-qfrency/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-qfrency/.install-doc.jar
modules/tts/tts-adapter-qfrency/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-qfrency/.install-xprocdoc.jar
modules/tts/tts-adapter-qfrency/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-qfrency/.install-doc
modules/tts/tts-adapter-qfrency/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-qfrency/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-qfrency/.compile-dependencies modules/tts/tts-adapter-qfrency/.test-dependencies
modules/tts/tts-adapter-qfrency/.compile-dependencies :
modules/tts/tts-adapter-qfrency/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-qfrency/.release

clean : modules/tts/tts-adapter-qfrency/.clean
.PHONY : modules/tts/tts-adapter-qfrency/.clean
modules/tts/tts-adapter-qfrency/.clean :
	rm("modules/tts/tts-adapter-qfrency/target");
