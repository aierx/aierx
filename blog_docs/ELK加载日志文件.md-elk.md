# ELK加载日志文件



### 1、下载所有需要文件

因为暂时没有相关的项目文件产生日志，所有选择tomcat安装jenkins可以产生较多的日志数据。

tomcat下载地址：[Apache Tomcat® - Apache Tomcat 8 Software Downloads](https://tomcat.apache.org/download-80.cgi)

jenkins下载地址：[Releases · jenkinsci/jenkins · GitHub](https://github.com/jenkinsci/jenkins/releases)

ElasticSearch下载：[Index of elasticsearch-local/7.6.0 (huaweicloud.com)](https://repo.huaweicloud.com/elasticsearch/7.6.0/)

kibana下载地址：[Index of kibana-local/7.6.0 (huaweicloud.com)](https://repo.huaweicloud.com/kibana/7.6.0/)

logstash下载地址：[Index of logstash-local/7.6.0 (huaweicloud.com)](https://repo.huaweicloud.com/logstash/7.6.0/)

filebeat下载地址：[Index of filebeat-local/7.6.0 (huaweicloud.com)](https://repo.huaweicloud.com/filebeat/7.6.0/)

### 2、启动tomcat，安装jenkins

下载tomcat后解压，将下载好的jenkins.war放到tomcat目录下webapp文件中。./bin/startup.bat

### 3、启动elasticsearch、kibana、filebeat

解压elasticsearch，./bin/elasticsearch.bat

解压kibana，./bin/kibana.bat

解压filebeat，./filebeat.exe -e -c filebeat.yml

```yaml
# filebeat相关配置文件

filebeat.inputs:
    - type: log
      paths:
        - C:\Users\aleiw\scoop\apps\tomcat8\8.5.75\logs\*
filebeat.config.modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: true
name: filebeat222
output.elasticsearch:
    hosts: ["localhost:9200"]

```

添加索引

![image-20220326185435260](https://s2.loli.net/2022/03/26/PE9vjg3N5nqfrQp.png)

查询数据

![image-20220326190146465](https://s2.loli.net/2022/03/26/ho2f1AjVgxzmYbn.png)