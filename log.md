> [一文弄懂Java日志框架](https://blog.csdn.net/zyb18507175502/article/details/131617841) \
> [Unicode字符列表 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/Unicode%E5%AD%97%E7%AC%A6%E5%88%97%E8%A1%A8)\
> [ANSI转义序列 - 维基百科，自由的百科全书](https://zh.wikipedia.org/wiki/ANSI%E8%BD%AC%E4%B9%89%E5%BA%8F%E5%88%97#24%E4%BD%8D)\
> [基于ANSI转义序列来构建命令行工具 – 小居](https://liunian.info/commandline-with-ansi-escape-codes.html)

## 一、logback

`设置layout位置 ch.qos.logback.core.pattern.PatternLayoutBase#setPattern`

### 1、vm参数

-Dlogback.configurationFile=http://localhost:8000/logback.xml 从指定位置获取配置

### 2、默认配置文件名称及顺序

logback-test.xml -> logback.groovy -> logback.xml

### 3、依赖
```xml
<dependencys>
    <!--slf4j core 使用slf4j必須添加-->
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>1.7.27</version>
    </dependency>
            <!--    logback    -->
    <dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.3</version>
    </dependency>
</dependencys>

```

### 4、示例代码

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(Main.class);
    logger.trace("trace");
    logger.debug("debug");
    logger.info("info");
    logger.warn("warn");
    logger.error("error");
  }
}
```

### 5、配置文件
支持ansi输出，配置文件名称：`logback.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <conversionRule conversionWord="nanos" converterClass="org.example.MySampleConverter" />
    <appender name="console" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>
                %d{yyyy-MM-dd HH:mm:ss.SSS} %highlight(%5p) [%15.15t] %cyan(%40.40c{10}:%-4L): %msg%n
            </pattern>
        </encoder>
    </appender>

    <root level="info">
        <appender-ref ref="console"/>
    </root>
</configuration>
```

## 二、log4j

### 1、vm参数

-Dlog4j.defaultInitOverride 设置log4j不进行初始化，由后续手动初始化

-Dlog4j.configuration=http://localhost:8000/log4j.xml 从指定位置获取配置

### 2、默认配置文件及顺序

log4j.xml -> log4j.properties

### 3、依赖

```xml
<dependencys>
    <!--slf4j core 使用slf4j必須添加-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.7.27</version>
    </dependency>
    <!-- log4j-->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-log4j12</artifactId>
        <version>1.7.27</version>
    </dependency>
    <!--适配log4j-->
    <dependency>
        <groupId>log4j</groupId>
        <artifactId>log4j</artifactId>
        <version>1.2.17</version>
    </dependency>
</dependencys>
```

### 4、示例代码

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(Main.class);
    logger.trace("trace");
    logger.debug("debug");
    logger.info("info");
    logger.warn("warn");
    logger.error("error");
  }
}
```

### 5、配置文件
不支持ansi颜色输出，配置文件名称：`log4j.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE log4j:configuration SYSTEM
        "http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/xml/doc-files/log4j.dtd">
<log4j:configuration debug="false" >
    <appender name="console" class="org.apache.log4j.ConsoleAppender">
        <layout class="org.apache.log4j.PatternLayout">
            <param name="ConversionPattern"
                   value="%d{yyyy-MM-dd HH:mm:ss.SSS} %5.5p [%15.15t] %40.40c{10}:%-4.4L: %m%n"/>
        </layout>
    </appender>
    <root>
        <priority value ="info"/>
        <appender-ref ref="console"/>
    </root>
</log4j:configuration>
```

## 三、 log4j2

`StrSubstitutor 作用 待学习`

`配置初始化位置-默认 org.apache.logging.log4j.core.LoggerContext.configuration`

`重新config        org.apache.logging.log4j.core.LoggerContext.reconfigure()`

### 1、vm参数

-Dlog4j.configurationFile=http://localhost:8000/log4j2.xml 从指定位置获取配置

### 2、默认配置文件及顺序

配置文件组成由： 文件名称 + 文件后缀

- 文件名称顺序 ( test + name -> test + no name -> no test + name -> no test + no name)

  test + name         示例：`log4j2-test18b4aac2`

  test + no name      示例：`log4j2-test`

  no test + name      示例：`log4j218b4aac2`

  no test + no name   示例：`log4j2`

- 文件后缀顺序 ( [".properties"] -> [".yml", ".yaml"] -> [".json", ".jsn"] -> [".xml", "*"] )


### 3、使用自己的门面

#### （1）、依赖
```xml
<dependencys>
    <!-- Log4j2 门面API-->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-api</artifactId>
        <version>2.11.1</version>
    </dependency>
    <!-- Log4j2 日志实现 -->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.11.1</version>
    </dependency>
</dependencys>

```

#### （2）、示例代码

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class Log4j2 {
  public static void main(String[] args) {
    Logger logger = LogManager.getLogger();
    logger.trace("trace");
    logger.debug("debug");
    logger.info("info");
    logger.warn("warn");
    logger.error("error");
  }
}

```


### 4、使用slf4j的门面

#### （1）、依赖

```xml
<dependencys>
    <!-- Log4j2 门面API-->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-api</artifactId>
        <version>2.11.1</version>
    </dependency>
    <!-- Log4j2 日志实现 -->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.11.1</version>
    </dependency>
    <!--为slf4j绑定日志实现 log4j2的适配器 -->
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-slf4j-impl</artifactId>
        <version>2.10.0</version>
    </dependency>
</dependencys>

```

#### （2）、示例代码

```java
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class Log4j2 {
  public static void main(String[] args) {
    Logger logger = LogManager.getLogger();
    logger.trace("trace");
    logger.debug("debug");
    logger.info("info");
    logger.warn("warn");
    logger.error("error");
  }
}
```

### 5、配置文件
支持ansi输出，需要指定`-Dlog4j.skipJansi=false`,默认配置文件名称：`log4j2.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration>
  <Appenders>
    <Console name="Console" target="org.apache.log4j.ConsoleAppender">
      <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} %highlight{%5.5p} [%15.15t] %style{%40.40c{1.}:%-4L}{cyan}: %msg%n" />
    </Console>
  </Appenders>

  <Loggers>
    <Root level="info">
      <AppenderRef ref="Console" />
    </Root>
  </Loggers>
</Configuration>
```

## 四、其他slf4j日志框架实现

```xml
<dependencys>
    <!--slf4j core 使用slf4j必須添加-->
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>1.7.27</version>
    </dependency>
            <!-- jul -->
    <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-jdk14</artifactId>
    <version>1.7.27</version>
    </dependency>
            <!--jcl -->
    <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-jcl</artifactId>
    <version>1.7.27</version>
    </dependency>
            <!-- nop 日志开关-->
    <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-nop</artifactId>
    <version>1.7.27</version>
    </dependency>
</dependencys>
```

## 五、将现有日志框架使用slf4j

```xml
<!-- log4j-->
<dependencys>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>log4j-over-slf4j</artifactId>
      <version>1.7.27</version>
    </dependency>
    
            <!-- jul -->
    <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jul-to-slf4j</artifactId>
    <version>1.7.27</version>
    </dependency>
    
            <!--jcl -->
    <dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jcl-over-slf4j</artifactId>
    <version>1.7.27</version>
    </dependency>
</dependencys>
```

- jcl-over-slf4j.jar和 slf4j-jcl.jar不能同时部署。前一个jar文件将导致JCL将日志系统的选择委托给SLF4J，后一个jar文件将导致SLF4J将日志系统的选择委托给JCL，从而导致无限循环。
- log4j-over-slf4j.jar和slf4j-log4j12.jar不能同时出现(桥接器和适配器不能同时出现)
- jul-to-slf4j.jar和slf4j-jdk14.jar不能同时出现
- 所有的桥接都只对Logger日志记录器对象有效，如果程序中调用了内部的配置类或者是Appender,Filter等对象，将无法产生效果。

# 六、 JUL日志框架

默认配置文件位置 jre/lib/logging.properties
通过vm参数可以指定配置文件位置(只能是文件位置)：-Djava.util.logging.config.
file=C:\Users\aleiwe\Desktop\tutorials\log\src\main\resources\logging.
properties

# 七、ANSI控制字符
- 前景色
  - \u001b[?m，其中 ? ∈ [30, 37]。
  - \u001b[?;1m，其中 ? ∈ [30, 37]。
  - \u001b[38;5;?m，其中 ? ∈ [0, 255]
- 背景色
  - \u001b[?m，其中 ? ∈ [40, 47]。
  - \u001b[?;1m，其中 ? ∈ [40, 47]。
  - \u001b[48;5;?m，其中 ? ∈ [0, 255]
- 加粗加亮：\u001b[1m
- 降低亮度：\u001b[2m
- 斜体：\u001b[3m
- 下划线：\u001b[4m
- 反色：\u001b[7m
- 光标操作
  - 上：\u001b[{n}A，光标上移 n 行
  - 下：\u001b[{n}B，光标下移 n 行
  - 右：\u001b[{n}C，光标右移 n 个位置
  - 左：\u001b[{n}D，光标左移 n 个位置
  - 下几行行首：\u001b[{n}E
  - 上几行行首：\u001b[{n}F
  - 指定列：\u001b[{n}G
  - 指定位置：\u001b[{n};{m}H，移动光标到 n 行 m 列
  - 清屏：\u001b[{n}J
    - n=0，当前光标到屏末
    - n=1，当前光标到屏首
    - n=2，整屏
  - 清行：\u001b[{n}K
    - n=0，当前光标到行末
    - n=1，当前光标到行首
    - n=2，整行