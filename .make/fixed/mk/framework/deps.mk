framework/VERSION := 1.15.5-SNAPSHOT

.SECONDARY : framework/.install
framework/.install : \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-bom/1.15.5-SNAPSHOT/framework-bom-1.15.5-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-parent/1.15.5-SNAPSHOT/framework-parent-1.15.5-SNAPSHOT.pom \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/clientlib-java-jaxb/3.1.1-SNAPSHOT/clientlib-java-jaxb-3.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-daisy-pipeline/1.14.8-SNAPSHOT/xproc-engine-daisy-pipeline-1.14.8-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/maven/xproc-engine-daisy-pipeline-logging/1.0.1-SNAPSHOT/xproc-engine-daisy-pipeline-logging-1.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/saxon-adapter/5.8.1-SNAPSHOT/saxon-adapter-5.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/calabash-adapter/7.0.1-SNAPSHOT/calabash-adapter-7.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/common-utils/6.4.1-SNAPSHOT/common-utils-6.4.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-core/11.0.1-SNAPSHOT/framework-core-11.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/framework-persistence/2.1.13-SNAPSHOT/framework-persistence-2.1.13-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/logging-appender/2.1.7-SNAPSHOT/logging-appender-2.1.7-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/modules-registry/5.0.1-SNAPSHOT/modules-registry-5.0.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/persistence-derby/2.0.12-SNAPSHOT/persistence-derby-2.0.12-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/persistence-mysql/2.0.2-SNAPSHOT/persistence-mysql-2.0.2-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/webservice/3.8.1-SNAPSHOT/webservice-3.8.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/woodstox-osgi-adapter/2.1.1-SNAPSHOT/woodstox-osgi-adapter-2.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/xproc-api/8.1.1-SNAPSHOT/xproc-api-8.1.1-SNAPSHOT.jar \
	$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/pipeline1-adapter/1.1.2-SNAPSHOT/pipeline1-adapter-1.1.2-SNAPSHOT.jar

check : $(TARGET_DIR)/state/framework/last-tested
.PHONY : $(TARGET_DIR)/state/framework/last-tested
$(TARGET_DIR)/state/framework/last-tested : \
	$(TARGET_DIR)/state/framework/bom/last-tested \
	$(TARGET_DIR)/state/framework/parent/last-tested \
	$(TARGET_DIR)/state/framework/utils/clientlib-java-jaxb/last-tested \
	$(TARGET_DIR)/state/framework/utils/xproc-engine-daisy-pipeline/last-tested \
	$(TARGET_DIR)/state/framework/utils/xproc-engine-daisy-pipeline-logging/last-tested \
	$(TARGET_DIR)/state/framework/saxon-adapter/last-tested \
	$(TARGET_DIR)/state/framework/calabash-adapter/last-tested \
	$(TARGET_DIR)/state/framework/common-utils/last-tested \
	$(TARGET_DIR)/state/framework/framework-core/last-tested \
	$(TARGET_DIR)/state/framework/framework-persistence/last-tested \
	$(TARGET_DIR)/state/framework/logging-appender/last-tested \
	$(TARGET_DIR)/state/framework/modules-registry/last-tested \
	$(TARGET_DIR)/state/framework/persistence-derby/last-tested \
	$(TARGET_DIR)/state/framework/persistence-mysql/last-tested \
	$(TARGET_DIR)/state/framework/webservice/last-tested \
	$(TARGET_DIR)/state/framework/woodstox-osgi-adapter/last-tested \
	$(TARGET_DIR)/state/framework/xproc-api/last-tested \
	$(TARGET_DIR)/state/framework/pipeline1-adapter/last-tested

.SECONDARY : framework/.release
framework/.release : | .maven-init .group-eval

framework/.release :
