modules/common/image-utils/VERSION := 1.0.9-SNAPSHOT

$(TARGET_DIR)/state/modules/common/image-utils/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/common/image-utils/modified-since-release_ : modules/common/image-utils/pom.xml $(TARGET_DIR)/state/modules/parent/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/common/image-utils/.test
modules/common/image-utils/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/common/image-utils/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/image-utils/1.0.9-SNAPSHOT/image-utils-1.0.9-SNAPSHOT.pom : modules/common/image-utils/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/image-utils/1.0.9-SNAPSHOT/image-utils-1.0.9-SNAPSHOT% : modules/common/image-utils/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/common/image-utils/.install.pom
modules/common/image-utils/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/common/image-utils");

modules/common/image-utils/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/common/image-utils/.install.jar
modules/common/image-utils/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/common/image-utils/.install
modules/common/image-utils/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/common/image-utils/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/common/image-utils/.install-doc.jar
modules/common/image-utils/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/common/image-utils/.install-xprocdoc.jar
modules/common/image-utils/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/common/image-utils/.install-doc
modules/common/image-utils/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/common/image-utils/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/common/image-utils/.compile-dependencies modules/common/image-utils/.test-dependencies
modules/common/image-utils/.compile-dependencies : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom
modules/common/image-utils/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/image-utils/1.0.9/image-utils-1.0.9.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/image-utils/1.0.9/image-utils-1.0.9-% : modules/common/image-utils/.release
	+//

.SECONDARY : modules/common/image-utils/.release
modules/common/image-utils/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("common/image-utils");

modules/common/image-utils/.release : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom

clean : modules/common/image-utils/.clean
.PHONY : modules/common/image-utils/.clean
modules/common/image-utils/.clean :
	rm("modules/common/image-utils/target");
