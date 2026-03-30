modules/braille/texhyph-utils/VERSION := 3.0.6

$(TARGET_DIR)/state/modules/braille/texhyph-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/texhyph-utils/.test
modules/braille/texhyph-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/texhyph-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/texhyph-utils/3.0.6/texhyph-utils-3.0.6.pom : modules/braille/texhyph-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/texhyph-utils/3.0.6/texhyph-utils-3.0.6% : modules/braille/texhyph-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/texhyph-utils/.install.pom
modules/braille/texhyph-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/texhyph-utils");

modules/braille/texhyph-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/texhyph-utils/.install.jar
modules/braille/texhyph-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/texhyph-utils/.install
modules/braille/texhyph-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/texhyph-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/texhyph-utils/.install-doc.jar
modules/braille/texhyph-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/texhyph-utils/.install-xprocdoc.jar
modules/braille/texhyph-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/texhyph-utils/.install-javadoc.jar
modules/braille/texhyph-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/texhyph-utils/.install-doc
modules/braille/texhyph-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/texhyph-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/texhyph-utils/.compile-dependencies modules/braille/texhyph-utils/.test-dependencies
modules/braille/texhyph-utils/.compile-dependencies :
modules/braille/texhyph-utils/.test-dependencies :

.SECONDARY : modules/braille/texhyph-utils/.release

clean : modules/braille/texhyph-utils/.clean
.PHONY : modules/braille/texhyph-utils/.clean
modules/braille/texhyph-utils/.clean :
	rm("modules/braille/texhyph-utils/target");
