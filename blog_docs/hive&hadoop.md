
## hive 安装
wget https://repo.huaweicloud.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <!-- 数据库相关配置 -->
  <!-- 保存元数据信息到MySQL -->
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true</value>
    </property>
    <!-- Hive连接MySQL的驱动全类名 -->
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <!-- Hive连接MySQL的用户名 -->
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
     <!-- Hive连接MySQL的密码 -->
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>123456</value>
    </property>
    <!-- 控制Hive元数据存储的数据模型的自动创建 -->
    <property>
        <name>datanucleus.schema.autoCreateAll</name>
        <value>true</value>
    </property>
    <!-- 控制在Hive CLI中查询结果是否打印字段名称的标头行 -->
    <property>
        <name>hive.cli.print.header</name>
        <value>true</value>
    </property>
    <!-- 控制在Hive CLI中是否打印当前数据库的信息 -->
    <property>
        <name>hive.cli.print.current.db</name>
        <value>true</value>
    </property>
    <!-- 配置Hive Server2 WebUI的主机地址,提供了一个Web界面，用于监视和管理Hive服务 -->
    <property>
        <name>hive.server2.webui.host</name>
        <value>node001</value>
    </property>
    <!-- 配置Hive Server2 WebUI的端口号 -->
    <property>
        <name>hive.server2.webui.port</name>
        <value>10002</value>
    </property>
    <!-- metastore数据存储位置 -->
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/hive/warehouse</value>
    </property>
    <!-- Hive元数据存储的模式验证 -->
    <property>
        <name>hive.metastore.schema.verification</name>
        <value>false</value>
    </property>
     <!-- Hive元数据事件通知的认证方式 -->
    <property>
        <name>hive.metastore.event.db.notification.api.auth</name>
        <value>false</value>
    </property>
</configuration>
```


## hadoop 安装

wget https://repo.huaweicloud.com/apache/hadoop/core/hadoop-3.1.0/hadoop-3.1.0.tar.gz

