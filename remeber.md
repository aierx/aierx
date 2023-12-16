# jetbranin account
agislason6@liberty.edu  
L34566567  
https://fauxid.com/identity/89abc39f-1362-4b82-b6da-2c158d85c25f  
**Fake Name:**  
Ariel Gislason  
**Address:**  
68188 Orpha Station  
Port Lions, AK 99550  
**Phone:**  
796-279-2538 x16272  
**Social Security Number:**  
731-71-4633  
**Date of Birth:**  
November 15, 2005. or stepmber 15,2005  
**Gender:**  
Male  
**Ethnicity:**  
Pacific Islander  
# jacoco
java -jar jacococli.jar dump --address 127.0.0.1 --port 6300 --destfile ./jacoco-demo.exec  
java -jar jacococli.jar report ./jacoco-demo.exec --classfiles /Users/leiwenyong/mini/c1/target/classes/com --sourcefiles /Users/leiwenyong/mini/c1/src/main/java --html report --xml report.xml  
# git
假定未变更  
git ls-files -v|grep "^h"  
打开假定未变更  
git update-index --assume-unchanged  
关闭假定未变更  
git update-index --no-assume-unchanged  
文件标识    描述  
H    缓存，正常跟踪文件  
S    skip-worktree文件  
h    assume-unchanged文件  
M    unmerged, 未合并  
R    removed/deleted  
C    modified/changed修改  
K    to be killed  
?    other，忽略文件 
# jdk environment variable
-Docto.invoker.channel.lazyInit.enable=true  
-Dlog4j.configurationFile=/Users/leiwenyong/Desktop/code/log4j.xml  
-XXaltjvm=dcevm  
-javaagent:/root/amon/temp/sonic-hotswap/sonic-agent.jar=autoHotswap=true  
-Dzebra.default.filters=cat,mtrace,wall,tablerewrite,sqlrewrite,set,dblog  
-Dset.thrift.server.bean.lazy=true  
# log4j.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appenders>
        <Console name="Console" target="SYSTEM_OUT" follow="true">
            <!-- <PatternLayout pattern="%d{HH:mm:ss.SSS} %highlight{[%-5level] [%20.20t] %40.40c{1.}}: %msg%n"/> -->
            <!--- <PatternLayout pattern="%d{mm:ss} %8.8r %highlight{[%-5level] [%8.8t] %20.20c{1.}}: %msg%n"/> -->
            <PatternLayout pattern="%d{mm:ss} %highlight{[%-5level] [%8.8t] %20.20c{1.}}:%L %msg%n"/>
        </Console>
        <!--日志远程上报-->
        <Scribe name="ScribeAppender">
            <!--远程日志默认使用appkey作为日志名(app.properties文件中的app.name字段)，也可自定义scribeCategory属性，scribeCategory优先级高于appkey-->
            <LcLayout/>
        </Scribe>
        <Async name="ScribeAsyncAppender" blocking="false">
            <AppenderRef ref="ScribeAppender"/>
        </Async>
        <CatAppender name="catAppender"/>
    </appenders>
    <loggers>
        <logger name="org.springframework" level="ERROR"/>
        <logger name="org.apache.ibatis" level="ERROR"/>
        <logger name="com.dianping.zebra" level="ERROR"/>
        <logger name="com.dianping.lion" level="ERROR"/>
        <logger name="com.meituan.mafka" level="ERROR"/>
        <logger name="com.meituan.kafka" level="ERROR"/>
        <logger name="com.meituan.service" level="ERROR"/>
        <logger name="com.cip.crane" level="ERROR"/>
        <logger name="com.sankuai.inf" level="ERROR"/>
        <logger name="com.dianping.pigeon" level="ERROR"/>
        <logger name="com.sankuai.meituan.config" level="ERROR"/>
        <logger name="com.meituan.hotel" level="ERROR"/>
        <root level="info">
            <appender-ref ref="Console" />
            <appender-ref ref="ScribeAsyncAppender" />
        </root>
    </loggers>
</configuration>
```
