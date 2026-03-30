modules/braille/libhyphen-utils/VERSION := 3.5.0

$(TARGET_DIR)/state/modules/braille/libhyphen-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

.SECONDARY : modules/braille/libhyphen-utils/.test
modules/braille/libhyphen-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/braille/libhyphen-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.5.0/libhyphen-utils-3.5.0.pom : modules/braille/libhyphen-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/braille/libhyphen-utils/3.5.0/libhyphen-utils-3.5.0% : modules/braille/libhyphen-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/braille/libhyphen-utils/.install.pom
modules/braille/libhyphen-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/braille/libhyphen-utils");

modules/braille/libhyphen-utils/.install.pom : %/.install.pom : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/libhyphen-utils/.install.jar
modules/braille/libhyphen-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/braille/libhyphen-utils/.install
modules/braille/libhyphen-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/braille/libhyphen-utils/.install : %/.install : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/libhyphen-utils/.install-doc.jar
modules/braille/libhyphen-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/braille/libhyphen-utils/.install-xprocdoc.jar
modules/braille/libhyphen-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/braille/libhyphen-utils/.install-javadoc.jar
modules/braille/libhyphen-utils/.install-javadoc.jar : %/.install-javadoc.jar : %/.install-doc

.SECONDARY : modules/braille/libhyphen-utils/.install-doc
modules/braille/libhyphen-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/braille/libhyphen-utils/.install-doc : %/.install-doc : | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/braille/libhyphen-utils/.compile-dependencies modules/braille/libhyphen-utils/.test-dependencies
modules/braille/libhyphen-utils/.compile-dependencies :
modules/braille/libhyphen-utils/.test-dependencies :

.SECONDARY : modules/braille/libhyphen-utils/.release

clean : modules/braille/libhyphen-utils/.clean
.PHONY : modules/braille/libhyphen-utils/.clean
modules/braille/libhyphen-utils/.clean :
	rm("modules/braille/libhyphen-utils/target");
