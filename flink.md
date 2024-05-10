
### maven配置
```xml
<properties>
    <flink.version>1.17-vvr-8.0.6-SNAPSHOT</flink.version>
</properties>

<dependencies>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-streaming-java</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-clients</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-table-api-java</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-table-planner-loader</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-table-runtime</artifactId>
			<version>${flink.version}</version>
		</dependency>
</dependencies>


```
