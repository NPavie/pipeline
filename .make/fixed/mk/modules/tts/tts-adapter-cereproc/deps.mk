modules/tts/tts-adapter-cereproc/VERSION := 1.1.9

$(TARGET_DIR)/state/modules/tts/tts-adapter-cereproc/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-cereproc/.test
modules/tts/tts-adapter-cereproc/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-cereproc/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-cereproc/1.1.9/tts-adapter-cereproc-1.1.9.pom : modules/tts/tts-adapter-cereproc/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-cereproc/1.1.9/tts-adapter-cereproc-1.1.9% : modules/tts/tts-adapter-cereproc/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-cereproc/.install.pom
modules/tts/tts-adapter-cereproc/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-cereproc");

modules/tts/tts-adapter-cereproc/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-cereproc/.install.jar
modules/tts/tts-adapter-cereproc/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-cereproc/.install
modules/tts/tts-adapter-cereproc/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-cereproc/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-cereproc/.install-doc.jar
modules/tts/tts-adapter-cereproc/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-cereproc/.install-xprocdoc.jar
modules/tts/tts-adapter-cereproc/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-cereproc/.install-doc
modules/tts/tts-adapter-cereproc/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-cereproc/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-cereproc/.compile-dependencies modules/tts/tts-adapter-cereproc/.test-dependencies
modules/tts/tts-adapter-cereproc/.compile-dependencies :
modules/tts/tts-adapter-cereproc/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-cereproc/.release

clean : modules/tts/tts-adapter-cereproc/.clean
.PHONY : modules/tts/tts-adapter-cereproc/.clean
modules/tts/tts-adapter-cereproc/.clean :
	rm("modules/tts/tts-adapter-cereproc/target");
