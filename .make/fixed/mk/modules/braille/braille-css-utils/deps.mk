modules/braille/braille-css-utils/VERSION := 5.0.1

$(TARGET_DIR)/state/modules/braille/braille-css-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/braille-css-utils/.test
modules/braille/braille-css-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-css-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1/braille-css-utils-5.0.1.pom : modules/braille/braille-css-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/braille-css-utils/5.0.1/braille-css-utils-5.0.1% : modules/braille/braille-css-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/braille-css-utils/.install.pom
modules/braille/braille-css-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/braille-css-utils");

modules/braille/braille-css-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-css-utils/.install.jar
modules/braille/braille-css-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/braille-css-utils/.install
modules/braille/braille-css-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-css-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-css-utils/.install-doc.jar
modules/braille/braille-css-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-css-utils/.install-xprocdoc.jar
modules/braille/braille-css-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-css-utils/.install-javadoc.jar
modules/braille/braille-css-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/braille-css-utils/.install-doc
modules/braille/braille-css-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/braille-css-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/braille-css-utils/.compile-dependencies modules/braille/braille-css-utils/.test-dependencies
modules/braille/braille-css-utils/.compile-dependencies :
modules/braille/braille-css-utils/.test-dependencies :

.SECONDARY : modules/braille/braille-css-utils/.release

clean : modules/braille/braille-css-utils/.clean
.PHONY : modules/braille/braille-css-utils/.clean
modules/braille/braille-css-utils/.clean :
	rm("modules/braille/braille-css-utils/target");
