modules/scripts-utils/epubcheck-adapter/VERSION := 1.1.15-SNAPSHOT

$(TARGET_DIR)/state/modules/scripts-utils/epubcheck-adapter/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/scripts-utils/epubcheck-adapter/modified-since-release_ : modules/scripts-utils/epubcheck-adapter/pom.xml $(TARGET_DIR)/state/modules/parent/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.test
modules/scripts-utils/epubcheck-adapter/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epubcheck-adapter/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15-SNAPSHOT/epubcheck-adapter-1.1.15-SNAPSHOT.pom : modules/scripts-utils/epubcheck-adapter/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15-SNAPSHOT/epubcheck-adapter-1.1.15-SNAPSHOT% : modules/scripts-utils/epubcheck-adapter/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install.pom
modules/scripts-utils/epubcheck-adapter/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/scripts-utils/epubcheck-adapter");

modules/scripts-utils/epubcheck-adapter/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install.jar
modules/scripts-utils/epubcheck-adapter/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install
modules/scripts-utils/epubcheck-adapter/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epubcheck-adapter/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install-doc.jar
modules/scripts-utils/epubcheck-adapter/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install-xprocdoc.jar
modules/scripts-utils/epubcheck-adapter/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.install-doc
modules/scripts-utils/epubcheck-adapter/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/scripts-utils/epubcheck-adapter/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.compile-dependencies modules/scripts-utils/epubcheck-adapter/.test-dependencies
modules/scripts-utils/epubcheck-adapter/.compile-dependencies : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom
modules/scripts-utils/epubcheck-adapter/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15/epubcheck-adapter-1.1.15.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/epubcheck-adapter/1.1.15/epubcheck-adapter-1.1.15-% : modules/scripts-utils/epubcheck-adapter/.release
	+//

.SECONDARY : modules/scripts-utils/epubcheck-adapter/.release
modules/scripts-utils/epubcheck-adapter/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("scripts-utils/epubcheck-adapter");

modules/scripts-utils/epubcheck-adapter/.release : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom

clean : modules/scripts-utils/epubcheck-adapter/.clean
.PHONY : modules/scripts-utils/epubcheck-adapter/.clean
modules/scripts-utils/epubcheck-adapter/.clean :
	rm("modules/scripts-utils/epubcheck-adapter/target");
