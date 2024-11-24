数据类型

org.apache.flink.table.data.RowData

生成图

org.apache.flink.streaming.api.graph.StreamGraph


https://zhuanlan.zhihu.com/p/464282840

Jdk动态代理生成代码位置 java.lang.reflect.ProxyGenerator

低版本：-Dsun.misc.ProxyGenerator.saveGeneratedFiles=true

高版本：-Djdk.proxy.ProxyGenerator.saveGeneratedFiles=true

-Dcglib.debugLocation=

### 显示生成的字节码
```
// jdk8及之前
-Dsun.misc.ProxyGenerator.saveGeneratedFiles=true
// jdk8以后
-Djdk.proxy.ProxyGenerator.saveGeneratedFiles=true


flink是手动保存代码到java，然后重新编译成class文件，这样就能调试了
flink执行List<Transformation<?>> transformations = this.translate(flatMapOperations);后，在返回值中会有使用字符串拼接的代码，把它保存一下就好了。
```

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
