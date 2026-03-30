modules/tts/tts-adapter-sapinative/VERSION := 3.2.2

$(TARGET_DIR)/state/modules/tts/tts-adapter-sapinative/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/tts/tts-adapter-sapinative/.test
modules/tts/tts-adapter-sapinative/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-sapinative/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-sapinative/3.2.2/tts-adapter-sapinative-3.2.2.pom : modules/tts/tts-adapter-sapinative/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/tts-adapter-sapinative/3.2.2/tts-adapter-sapinative-3.2.2% : modules/tts/tts-adapter-sapinative/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/tts/tts-adapter-sapinative/.install.pom
modules/tts/tts-adapter-sapinative/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/tts/tts-adapter-sapinative");

modules/tts/tts-adapter-sapinative/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-sapinative/.install.jar
modules/tts/tts-adapter-sapinative/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/tts/tts-adapter-sapinative/.install
modules/tts/tts-adapter-sapinative/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-sapinative/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-sapinative/.install-doc.jar
modules/tts/tts-adapter-sapinative/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-sapinative/.install-xprocdoc.jar
modules/tts/tts-adapter-sapinative/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/tts/tts-adapter-sapinative/.install-doc
modules/tts/tts-adapter-sapinative/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/tts/tts-adapter-sapinative/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/tts/tts-adapter-sapinative/.compile-dependencies modules/tts/tts-adapter-sapinative/.test-dependencies
modules/tts/tts-adapter-sapinative/.compile-dependencies :
modules/tts/tts-adapter-sapinative/.test-dependencies :

.SECONDARY : modules/tts/tts-adapter-sapinative/.release

clean : modules/tts/tts-adapter-sapinative/.clean
.PHONY : modules/tts/tts-adapter-sapinative/.clean
modules/tts/tts-adapter-sapinative/.clean :
	rm("modules/tts/tts-adapter-sapinative/target");
