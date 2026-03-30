modules/braille/dotify-utils/VERSION := 6.5.1

$(TARGET_DIR)/state/modules/braille/dotify-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/dotify-utils/.test
modules/braille/dotify-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/dotify-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dotify-utils/6.5.1/dotify-utils-6.5.1.pom : modules/braille/dotify-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/dotify-utils/6.5.1/dotify-utils-6.5.1% : modules/braille/dotify-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/dotify-utils/.install.pom
modules/braille/dotify-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/dotify-utils");

modules/braille/dotify-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/dotify-utils/.install.jar
modules/braille/dotify-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/dotify-utils/.install
modules/braille/dotify-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/dotify-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/dotify-utils/.install-doc.jar
modules/braille/dotify-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/dotify-utils/.install-xprocdoc.jar
modules/braille/dotify-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/dotify-utils/.install-javadoc.jar
modules/braille/dotify-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/dotify-utils/.install-doc
modules/braille/dotify-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/dotify-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/dotify-utils/.compile-dependencies modules/braille/dotify-utils/.test-dependencies
modules/braille/dotify-utils/.compile-dependencies :
modules/braille/dotify-utils/.test-dependencies :

.SECONDARY : modules/braille/dotify-utils/.release

clean : modules/braille/dotify-utils/.clean
.PHONY : modules/braille/dotify-utils/.clean
modules/braille/dotify-utils/.clean :
	rm("modules/braille/dotify-utils/target");
