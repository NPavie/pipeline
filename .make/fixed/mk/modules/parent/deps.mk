modules/parent/VERSION := 1.15.4-SNAPSHOT

$(TARGET_DIR)/state/modules/parent/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/parent/modified-since-release_ : modules/parent/pom.xml \
	$(TARGET_DIR)/state/framework/webservice/modified-since-release \
	$(TARGET_DIR)/state/framework/calabash-adapter/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/parent/.test
modules/parent/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/parent/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom : modules/parent/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT% : modules/parent/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/parent/.install.pom
modules/parent/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/parent");

modules/parent/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/parent/.install-doc
modules/parent/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/parent/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/parent/.compile-dependencies modules/parent/.test-dependencies
modules/parent/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-bom/1.15.4-SNAPSHOT/modules-bom-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-bom/1.15.5-SNAPSHOT/framework-bom-1.15.5-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar
modules/parent/.test-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-bom/1.15.4-SNAPSHOT/modules-bom-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-bom/1.15.5-SNAPSHOT/framework-bom-1.15.5-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4-% : modules/parent/.release
	+//

.SECONDARY : modules/parent/.release
modules/parent/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("parent");

modules/parent/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-bom/1.15.4/modules-bom-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-bom/1.15.5/framework-bom-1.15.5.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar

clean : modules/parent/.clean
.PHONY : modules/parent/.clean
modules/parent/.clean :
	rm("modules/parent/target");
