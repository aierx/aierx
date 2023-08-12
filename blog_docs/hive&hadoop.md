

[hadoop安装](https://www.jianshu.com/p/4144205d1469)

[hive安装](https://www.jianshu.com/p/4cb51e7250c1)

## hadoop 安装

wget https://repo.huaweicloud.com/apache/hadoop/core/hadoop-3.1.0/hadoop-3.1.0.tar.gz

修改文件`hadoop/etc/core-site.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
                <name>fs.defaultFS</name>
                <value>hdfs://127.0.0.1:9000</value>
        </property>
        <property>
                <name>hadoop.tmp.dir</name>
                <!-- 自定义 hadoop 的工作目录 -->
                <value>/root/hadoop/tmp</value>
        </property>
        <property>
                <name>hadoop.native.lib</name>
                <!-- 禁用Hadoop的本地库 -->
                <value>false</value>
        </property>
        <property>
        <name>hadoop.proxyuser.root.hosts</name>
                <value>*</value>
        </property>
        <property>
        <name>hadoop.proxyuser.root.groups</name>
                <value>*</value>
        </property>
</configuration>
```

修改文件`hadoop/etc/hdfs-site.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
   <property>
       <name>dfs.replication</name>
       <value>1</value>
   </property>

</configuration>

```
修改文件`hadoop/etc/mapred-site.xml`
```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>

</configuration>

```

修改文件`hadoop/etc/yarn-site.xml`
```xml
<?xml version="1.0"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>

<!-- Site specific YARN configuration properties -->
       <property>
               <name>yarn.resourcemanager.hostname</name>
               <value>127.0.0.1</value>
       </property>
       <property>
               <name>yarn.resourcemanager.webapp.address</name>
               <!-- yarn web 页面 -->
               <value>0.0.0.0:8088</value>
       </property>
       <property>
               <name>yarn.nodemanager.aux-services</name>
               <!-- reducer获取数据的方式 -->
               <value>mapreduce_shuffle</value>
       </property>

</configuration>
```

配置本机免密登入

```shell
$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
$ cat ~/.ssh/id_rsa.pub &gt;&gt; ~/.ssh/authorized_keys
$ chmod 0600 ~/.ssh/authorized_keys
# 验证
$ ssh root@127.0.0.1
# 格式化 HDFS
$ hdfs namenode -format
# 启动 Hadoop
$ ./hadoop/sbin/start-all.sh

# 测试
# 在 HDFS 上创建目录
$ hadoop fs -mkdir /test_1/
$ hadoop fs -ls /

# 将本地文件上传到 HDFS
$ cat asdadasdafd > a.txt
$ hadoop fs -put a.txt /test_1/
$ hadoop fs -ls /test_1/
$ hadoop fs -cat /test_1/a.txt

# 将 HDFS 上的文件下载到本地
$ rm -fr a.txt
$ hadoop fs -get /test_1/a.txt
```

网页访问Hadoop Web

http://192.168.207.128:9870

网页访问Yarn Web 页面测试

http://192.168.207.128:8088

## hive 安装

wget https://repo.huaweicloud.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

修改文件`hive/conf/hive-site.xml`
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
    <property>
        <!--hive 表数据在 HDFS 的默认位置。创建内部表时，如果不指定 location，表数据则存储与该位置。-->
        <name>hive.metastore.warehouse.dir</name>
        <value>/hive/warehouse/internal</value>
    </property>

    <property>
        <!--hive 外部表数据在 HDFS 的默认位置。创建外部表时，如果不指定 location，表数据则存储与该位置。-->
        <name>hive.metastore.warehouse.external.dir</name>
        <value>/hive/warehouse/external</value>
    </property>

    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
</configuration>
```

修改文件`hive/conf/hive-env.sh`
```xml
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set Hive and Hadoop environment variables here. These variables can be used
# to control the execution of Hive. It should be used by admins to configure
# the Hive installation (so that users do not have to set environment variables
# or set command line parameters to get correct behavior).
#
# The hive service being invoked (CLI etc.) is available via the environment
# variable SERVICE


# Hive Client memory usage can be an issue if a large number of clients
# are running at the same time. The flags below have been useful in 
# reducing memory usage:
#
# if [ "$SERVICE" = "cli" ]; then
#   if [ -z "$DEBUG" ]; then
#     export HADOOP_OPTS="$HADOOP_OPTS -XX:NewRatio=12 -Xms10m -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=15 -XX:+UseParNewGC -XX:-UseGCOverheadLimit"
#   else
#     export HADOOP_OPTS="$HADOOP_OPTS -XX:NewRatio=12 -Xms10m -XX:MaxHeapFreeRatio=40 -XX:MinHeapFreeRatio=15 -XX:-UseGCOverheadLimit"
#   fi
# fi

# The heap size of the jvm stared by hive shell script can be controlled via:
#
# export HADOOP_HEAPSIZE=1024
#
# Larger heap size may be required when running queries over large number of files or partitions. 
# By default hive shell scripts use a heap size of 256 (MB).  Larger heap size would also be 
# appropriate for hive server.


# Set HADOOP_HOME to point to a specific hadoop install directory
HADOOP_HOME=/root/hadoop

# Hive Configuration Directory can be controlled by:
# export HIVE_CONF_DIR=

# Folder containing extra libraries required for hive compilation/execution can be controlled by:
# export HIVE_AUX_JARS_PATH=
```

```shell
$ wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar
$ cp mysql-connector-java-8.0.30.jar hive/lib/
$ vim .zshrc
```

修改文件`.zshrc` 
```shell
alias s="export http_proxy=http://192.168.3.152:7890; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
alias u="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
alias my="mysql -uroot -p123456"

alias wgetp="wget -e \"https_proxy=http://192.168.3.152:7890\""

export HIVE_HOME="/root/hive"
export PATH=$PATH:$HIVE_HOME/bin


export HADOOP_HOME="/root/hadoop"
export PATH=$PATH:$HADOOP_HOME/bin
```
初始化元数据库 & 启动hadoop & 启动hive
```shell
# 初始化元数据库
$ schematool -initSchema -dbType mysql

# 启动hadoop
$ jps -l | grep hadoop
$ start-all.sh
# 启动hive
# 方式一 client jdbc/odbc hive server
$ hive --service metastore
$ hive --service hiveserver2

# 使用beeline登入
$ beeline -u jdbc:hive2://127.0.0.1:10000 -n root

# 方式二 命令行 + hive 副本
$ hive --service cli

# 方式三 wui
$ hive --service hwi
```

