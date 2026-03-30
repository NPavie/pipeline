framework/framework-persistence/VERSION := 2.1.14-SNAPSHOT

$(TARGET_DIR)/state/framework/framework-persistence/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/framework/framework-persistence/modified-since-release_ : framework/framework-persistence/pom.xml $(TARGET_DIR)/state/framework/parent/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : framework/framework-persistence/.test
framework/framework-persistence/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

framework/framework-persistence/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.14-SNAPSHOT/framework-persistence-2.1.14-SNAPSHOT.pom : framework/framework-persistence/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.14-SNAPSHOT/framework-persistence-2.1.14-SNAPSHOT% : framework/framework-persistence/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : framework/framework-persistence/.install.pom
framework/framework-persistence/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("framework/framework-persistence");

framework/framework-persistence/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : framework/framework-persistence/.install.jar
framework/framework-persistence/.install.jar : %/.install.jar : %/.install

.SECONDARY : framework/framework-persistence/.install
framework/framework-persistence/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

framework/framework-persistence/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : framework/framework-persistence/.install-doc
framework/framework-persistence/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

framework/framework-persistence/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : framework/framework-persistence/.compile-dependencies framework/framework-persistence/.test-dependencies
framework/framework-persistence/.compile-dependencies : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-parent/1.15.7-SNAPSHOT/framework-parent-1.15.7-SNAPSHOT.pom
framework/framework-persistence/.test-dependencies :

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.14/framework-persistence-2.1.14.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.14/framework-persistence-2.1.14-% : framework/framework-persistence/.release
	+//

.SECONDARY : framework/framework-persistence/.release
framework/framework-persistence/.release : framework/.release
	+$(EVAL) mvn.releaseModulesInDir("framework").apply("framework-persistence");

framework/framework-persistence/.release : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-parent/1.15.7/framework-parent-1.15.7.pom

clean : framework/framework-persistence/.clean
.PHONY : framework/framework-persistence/.clean
framework/framework-persistence/.clean :
	rm("framework/framework-persistence/target");
