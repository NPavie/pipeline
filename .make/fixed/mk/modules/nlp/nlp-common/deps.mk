modules/nlp/nlp-common/VERSION := 3.0.5-SNAPSHOT

$(TARGET_DIR)/state/modules/nlp/nlp-common/last-tested : $(TARGET_DIR)/state/%/last-tested : %/.test | .group-eval
	+$(EVAL) mkdirs("$(dir $@)"); touch("$@");

# this rule overrides the implicit rule in main.mk
# note that because the modified-since-release_ files created by main.mk, are deleted,
# this rule gets executed at least once
$(TARGET_DIR)/state/modules/nlp/nlp-common/modified-since-release_ : modules/nlp/nlp-common/pom.xml \
	$(TARGET_DIR)/state/modules/parent/modified-since-release \
	$(TARGET_DIR)/state/framework/saxon-adapter/modified-since-release \
	$(TARGET_DIR)/state/framework/calabash-adapter/modified-since-release \
	$(TARGET_DIR)/state/modules/common/common-utils/modified-since-release \
	$(TARGET_DIR)/state/modules/common/file-utils/modified-since-release \
	$(TARGET_DIR)/state/framework/modules-registry/modified-since-release \
	$(TARGET_DIR)/state/framework/webservice/modified-since-release
	mkdirs("$(dir $@)"); \
	try (OutputStream s = new FileOutputStream("$@")) { \
		ModificationType modified = isModifiedSinceLastRelease(new File("$<").getParentFile()); \
		if (modified == null) \
			for (String d : "$(filter %/modified-since-release,$^)".trim().split("\\s+")) \
				if ("major".equals(slurp(new File(d)).trim())) { \
					modified = ModificationType.PATCH; \
					break; } \
		new PrintStream(s).print("" + modified); }

.SECONDARY : modules/nlp/nlp-common/.test
modules/nlp/nlp-common/.test : | .maven-init .group-eval
	+$(EVAL) mvn.test("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.test : %/.test : %/pom.xml %/.compile-dependencies %/.test-dependencies

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT.pom : modules/nlp/nlp-common/.install.pom | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5-SNAPSHOT/nlp-common-3.0.5-SNAPSHOT% : modules/nlp/nlp-common/.install% | .group-eval
	+$(EVAL) if (new File("$@").exists()) touch("$@"); else exit(1);

.SECONDARY : modules/nlp/nlp-common/.install.pom
modules/nlp/nlp-common/.install.pom : | .maven-init .group-eval
	+$(EVAL) mvn.installPom("modules/nlp/nlp-common");

modules/nlp/nlp-common/.install.pom : %/.install.pom : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.install.jar
modules/nlp/nlp-common/.install.jar : %/.install.jar : %/.install

.SECONDARY : modules/nlp/nlp-common/.install
modules/nlp/nlp-common/.install : | .maven-init .group-eval
	+$(EVAL) mvn.install("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.install : %/.install : %/pom.xml %/.compile-dependencies | %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.install-doc.jar
modules/nlp/nlp-common/.install-doc.jar : %/.install-doc.jar : %/.install-doc

.SECONDARY : modules/nlp/nlp-common/.install-xprocdoc.jar
modules/nlp/nlp-common/.install-xprocdoc.jar : %/.install-xprocdoc.jar : %/.install-doc

.SECONDARY : modules/nlp/nlp-common/.install-doc
modules/nlp/nlp-common/.install-doc : | .maven-init .group-eval
	+$(EVAL) mvn.installDoc("$(patsubst %/,%,$(dir $@))");

modules/nlp/nlp-common/.install-doc : %/.install-doc : %/pom.xml | %/.compile-dependencies %/.test-dependencies

.SECONDARY : modules/nlp/nlp-common/.compile-dependencies modules/nlp/nlp-common/.test-dependencies
modules/nlp/nlp-common/.compile-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4-SNAPSHOT/modules-parent-1.15.4-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2-SNAPSHOT/common-utils-3.3.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4-SNAPSHOT/file-utils-4.3.4-SNAPSHOT.jar
modules/nlp/nlp-common/.test-dependencies : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5.% \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/nlp-common/3.0.5/nlp-common-3.0.5-% : modules/nlp/nlp-common/.release
	+//

.SECONDARY : modules/nlp/nlp-common/.release
modules/nlp/nlp-common/.release : modules/.release
	+$(EVAL) mvn.releaseModulesInDir("modules").apply("nlp/nlp-common");

modules/nlp/nlp-common/.release : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/modules-parent/1.15.4/modules-parent-1.15.4.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1/saxon-adapter-5.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1/common-utils-6.4.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1/modules-registry-5.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1/calabash-adapter-7.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/common-utils/3.3.2/common-utils-3.3.2.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules/file-utils/4.3.4/file-utils-4.3.4.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1/webservice-3.8.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1/framework-core-11.0.1.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13/framework-persistence-2.1.13.jar

clean : modules/nlp/nlp-common/.clean
.PHONY : modules/nlp/nlp-common/.clean
modules/nlp/nlp-common/.clean :
	rm("modules/nlp/nlp-common/target");
