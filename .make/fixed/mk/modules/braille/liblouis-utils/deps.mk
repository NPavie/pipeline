modules/braille/liblouis-utils/VERSION := 6.4.0

$(TARGET_DIR)/state/modules/braille/liblouis-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/liblouis-utils/.test
modules/braille/liblouis-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.4.0/liblouis-utils-6.4.0.pom : modules/braille/liblouis-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/liblouis-utils/6.4.0/liblouis-utils-6.4.0% : modules/braille/liblouis-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/liblouis-utils/.install.pom
modules/braille/liblouis-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/liblouis-utils");

modules/braille/liblouis-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.install.jar
modules/braille/liblouis-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/liblouis-utils/.install
modules/braille/liblouis-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.install-doc.jar
modules/braille/liblouis-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-xprocdoc.jar
modules/braille/liblouis-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-javadoc.jar
modules/braille/liblouis-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/liblouis-utils/.install-doc
modules/braille/liblouis-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/liblouis-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/liblouis-utils/.compile-dependencies modules/braille/liblouis-utils/.test-dependencies
modules/braille/liblouis-utils/.compile-dependencies :
modules/braille/liblouis-utils/.test-dependencies :

.SECONDARY : modules/braille/liblouis-utils/.release

clean : modules/braille/liblouis-utils/.clean
.PHONY : modules/braille/liblouis-utils/.clean
modules/braille/liblouis-utils/.clean :
	rm("modules/braille/liblouis-utils/target");
