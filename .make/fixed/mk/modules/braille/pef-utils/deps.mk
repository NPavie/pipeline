modules/braille/pef-utils/VERSION := 8.0.1

$(TARGET_DIR)/state/modules/braille/pef-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/pef-utils/.test
modules/braille/pef-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/pef-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1/pef-utils-8.0.1.pom : modules/braille/pef-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/pef-utils/8.0.1/pef-utils-8.0.1% : modules/braille/pef-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/pef-utils/.install.pom
modules/braille/pef-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/pef-utils");

modules/braille/pef-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/pef-utils/.install.jar
modules/braille/pef-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/pef-utils/.install
modules/braille/pef-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/pef-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/pef-utils/.install-doc.jar
modules/braille/pef-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/pef-utils/.install-xprocdoc.jar
modules/braille/pef-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/pef-utils/.install-javadoc.jar
modules/braille/pef-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/pef-utils/.install-doc
modules/braille/pef-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/pef-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/pef-utils/.compile-dependencies modules/braille/pef-utils/.test-dependencies
modules/braille/pef-utils/.compile-dependencies :
modules/braille/pef-utils/.test-dependencies :

.SECONDARY : modules/braille/pef-utils/.release

clean : modules/braille/pef-utils/.clean
.PHONY : modules/braille/pef-utils/.clean
modules/braille/pef-utils/.clean :
	rm("modules/braille/pef-utils/target");
