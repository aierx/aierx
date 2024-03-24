

log4j2.xml

```xml
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.9.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-slf4j-impl</artifactId>
            <version>2.9.1</version>
        </dependency>

```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration status="OFF">
    <appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <!--<PatternLayout pattern="%d %-5level [%t] %c{1.}.%M(%L): %msg%n"/>-->
            <PatternLayout pattern="%d %highlight{%-5level} [%20.20t] %style{%c{1.}.%M:%L}{cyan} %msg%n"/>
        </Console>
    </appenders>
    <loggers>
        <root level="info">
            <appender-ref ref="Console"/>
        </root>
    </loggers>
</configuration>


```
