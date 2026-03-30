modules/braille/braille-common/VERSION := 7.0.0

$(TARGET_DIR)/state/modules/braille/braille-common/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/braille-common/.test
modules/braille/braille-common/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-common/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/7.0.0/braille-common-7.0.0.pom : modules/braille/braille-common/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-common/7.0.0/braille-common-7.0.0% : modules/braille/braille-common/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/braille-common/.install.pom
modules/braille/braille-common/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/braille-common");

modules/braille/braille-common/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-common/.install.jar
modules/braille/braille-common/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/braille-common/.install
modules/braille/braille-common/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-common/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-common/.install-doc.jar
modules/braille/braille-common/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-common/.install-xprocdoc.jar
modules/braille/braille-common/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-common/.install-javadoc.jar
modules/braille/braille-common/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-common/.install-doc
modules/braille/braille-common/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-common/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-common/.compile-dependencies modules/braille/braille-common/.test-dependencies
modules/braille/braille-common/.compile-dependencies :
modules/braille/braille-common/.test-dependencies :

.SECONDARY : modules/braille/braille-common/.release

clean : modules/braille/braille-common/.clean
.PHONY : modules/braille/braille-common/.clean
modules/braille/braille-common/.clean :
	rm("modules/braille/braille-common/target");
