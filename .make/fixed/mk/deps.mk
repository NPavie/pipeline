VERSION := 0-SNAPSHOT

.SECONDARY : .install
.install : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/daisy/6-SNAPSHOT/daisy-6-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/build/modules-test-helper/2.2.7-SNAPSHOT/modules-test-helper-2.2.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/ds-to-spi-annotations/1.0.1-SNAPSHOT/ds-to-spi-annotations-1.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/build/ds-to-spi-annotations-processor/1.1.5-SNAPSHOT/ds-to-spi-annotations-processor-1.1.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/ds-to-spi-runtime/1.2.2-SNAPSHOT/ds-to-spi-runtime-1.2.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/build/ds-to-spi-maven-plugin/1.1.6-SNAPSHOT/ds-to-spi-maven-plugin-1.1.6-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/pax-exam-helper/2.5.2-SNAPSHOT/pax-exam-helper-2.5.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/archetypes/basic-module/1.0.0-SNAPSHOT/basic-module-1.0.0-SNAPSHOT.maven-archetype \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xspec-runner/1.0.6-SNAPSHOT/xspec-runner-1.0.6-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xspec-maven-plugin/1.0.2-SNAPSHOT/xspec-maven-plugin-1.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/xprocspec/xprocspec/1.4.4-SNAPSHOT/xprocspec-1.4.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-api/1.3.1-SNAPSHOT/xproc-engine-api-1.3.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-calabash/1.2.1-SNAPSHOT/xproc-engine-calabash-1.2.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xprocspec-runner/1.2.9-SNAPSHOT/xprocspec-runner-1.2.9-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-maven-plugin/1.0.4-SNAPSHOT/xproc-maven-plugin-1.0.4-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/bindings/jhyphen/1.0.5-SNAPSHOT/jhyphen-1.0.5-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jing/20151127.0.2-SNAPSHOT/jing-20151127.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/jnaerator/0.11-p2-SNAPSHOT/jnaerator-0.11-p2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/parboiled/1.0.1-SNAPSHOT/parboiled-1.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/pegdown/1.0.1-SNAPSHOT/pegdown-1.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/libs/saxon-he/10.5-p1-SNAPSHOT/saxon-he-10.5-p1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-bom/1.15.7-SNAPSHOT/framework-bom-1.15.7-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-parent/1.15.7-SNAPSHOT/framework-parent-1.15.7-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/clientlib-java-jaxb/3.1.1-SNAPSHOT/clientlib-java-jaxb-3.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-daisy-pipeline/1.14.8-SNAPSHOT/xproc-engine-daisy-pipeline-1.14.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-daisy-pipeline-logging/1.0.1-SNAPSHOT/xproc-engine-daisy-pipeline-logging-1.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.2-SNAPSHOT/saxon-adapter-5.8.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.1.1-SNAPSHOT/calabash-adapter-7.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.6.1-SNAPSHOT/common-utils-6.6.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/12.0.1-SNAPSHOT/framework-core-12.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.14-SNAPSHOT/framework-persistence-2.1.14-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.8-SNAPSHOT/logging-appender-2.1.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.2-SNAPSHOT/modules-registry-5.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/persistence-derby/2.0.12-SNAPSHOT/persistence-derby-2.0.12-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/persistence-mysql/2.0.2-SNAPSHOT/persistence-mysql-2.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/4.0.1-SNAPSHOT/webservice-4.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/woodstox-osgi-adapter/2.1.1-SNAPSHOT/woodstox-osgi-adapter-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/xproc-api/8.1.1-SNAPSHOT/xproc-api-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/pipeline1-adapter/1.1.3-SNAPSHOT/pipeline1-adapter-1.1.3-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/cli/2.3.1-SNAPSHOT/cli-2.3.1-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/x/x/x-SNAPSHOT/x-x-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/clientlib-java-httpclient/2.1.3-SNAPSHOT/clientlib-java-httpclient-2.1.3-SNAPSHOT.jar

check : $(TARGET_DIR)/state/last-tested
.PHONY : $(TARGET_DIR)/state/last-tested
$(TARGET_DIR)/state/last-tested : \
	$(TARGET_DIR)/state/utils/daisy-parent/daisy-parent/last-tested \
	$(TARGET_DIR)/state/utils/build-utils/last-tested \
	$(TARGET_DIR)/state/utils/xspec-maven-plugin/last-tested \
	$(TARGET_DIR)/state/utils/xprocspec/last-tested \
	$(TARGET_DIR)/state/utils/xproc-maven-plugin/last-tested \
	$(TARGET_DIR)/state/libs/jstyleparser/last-tested \
	$(TARGET_DIR)/state/libs/braille-css/last-tested \
	$(TARGET_DIR)/state/libs/liblouis-java/last-tested \
	$(TARGET_DIR)/state/libs/jhyphen/last-tested \
	$(TARGET_DIR)/state/libs/osgi-libs/last-tested \
	$(TARGET_DIR)/state/framework/last-tested \
	$(TARGET_DIR)/state/modules/last-tested \
	$(TARGET_DIR)/state/cli/last-tested \
	$(TARGET_DIR)/state/assembly/last-tested \
	$(TARGET_DIR)/state/website/target/maven/last-tested \
	$(TARGET_DIR)/state/clientlib/java/last-tested
