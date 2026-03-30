modules/audio/audio-common/VERSION := 5.1.8

$(TARGET_DIR)/state/modules/audio/audio-common/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/audio/audio-common/.test
modules/audio/audio-common/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/audio/audio-common/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8/audio-common-5.1.8.pom : modules/audio/audio-common/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/audio-common/5.1.8/audio-common-5.1.8% : modules/audio/audio-common/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/audio/audio-common/.install.pom
modules/audio/audio-common/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/audio/audio-common");

modules/audio/audio-common/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/audio/audio-common/.install.jar
modules/audio/audio-common/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/audio/audio-common/.install
modules/audio/audio-common/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/audio/audio-common/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/audio/audio-common/.install-doc.jar
modules/audio/audio-common/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/audio/audio-common/.install-xprocdoc.jar
modules/audio/audio-common/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/audio/audio-common/.install-javadoc.jar
modules/audio/audio-common/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/audio/audio-common/.install-doc
modules/audio/audio-common/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/audio/audio-common/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/audio/audio-common/.compile-dependencies modules/audio/audio-common/.test-dependencies
modules/audio/audio-common/.compile-dependencies :
modules/audio/audio-common/.test-dependencies :

.SECONDARY : modules/audio/audio-common/.release

clean : modules/audio/audio-common/.clean
.PHONY : modules/audio/audio-common/.clean
modules/audio/audio-common/.clean :
	rm("modules/audio/audio-common/target");
