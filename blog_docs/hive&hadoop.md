
[hadoop安装](https://www.jianshu.com/p/4144205d1469)

[hive安装](https://www.jianshu.com/p/4cb51e7250c1)

## 机器配置

### 静态ip配置
```properties
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=0863e67b-2a93-4600-8747-53e0d3b2d908
DEVICE=ens33
ONBOOT=yes
IPADDR=192.168.207.129
GATEWAY=192.168.207.2
NETMASK=255.255.255.0
DNS1=192.168.207.2
```

### 主机配置 & 免密登入
``` shell
# 修改hostname
$ hostnamectl set-hostname alei1
$ hostnamectl set-hostname alei2
$ hostnamectl set-hostname alei3

# 配置hosts文件
192.168.207.128	alei1
192.168.207.129 alei2
192.168.207.120 alei3

# 配置免密码登入
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
ssh-copy-id root@alei1
ssh-copy-id root@alei2
ssh-copy-id root@alei3
```

### 软件安装
```shell
# 换源
$ mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
$ curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo
$ yum clean all
$ yum makecache
# 安装常用工具
$ yum install wget vim unzip epel-release git zsh java-1.8.0-openjdk-devel tmux ranger -y
$ yum grouplist
$ yum groupinstall -y "Development Tools"
# 首先关闭防火墙
$ sytemctl stop firewalld
$ sytemctl disable firewalld

# 导出环境变量
export HIVE_HOME=/root/hive
export HADOOP_HOME=/root/hadoop
export PATH=$PATH:$HIVE_HOME/bin
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.372.b07-1.el7_9.x86_64"

# 配置wget代理别名和代理别名
alias wgetp="wget -e \"https_proxy=http://192.168.3.152:7890\""
alias s="export http_proxy=http://192.168.3.152:7890; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
alias u="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
alias my="mysql -uroot -p123456"
```

### hive和hadoop下载
```shell
# 并解压到指定/root/hive /root/hadoop
$ wget https://repo.huaweicloud.com/apache/hadoop/core/hadoop-3.1.0/hadoop-3.1.0.tar.gz
$ wget https://repo.huaweicloud.com/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
```

## hadoop 安装 (以三台服务器为例)

### 资源分配


#### 单机服务配置
| service | alei1                                         |
| ------- | --------------------------------------------- |
| dfs     | DataNode <br> NameNode <br> SecondaryNameNode |
| yarn    | NodeManager <br> ResourceManager              |


#### 两台机器服务分配

| service | alei1                            | alei2                           |
| ------- | -------------------------------- | ------------------------------- |
| dfs     | DataNode <br> NameNode           | DataNode <br> SecondaryNameNode |
| yarn    | NodeManager <br> ResourceManager | NodeManager                     |

#### 三台机器服务分配


| service | alei1                  | alei2                           | alei3                            |
| ------- | ---------------------- | ------------------------------- | -------------------------------- |
| dfs     | DataNode <br> NameNode | DataNode <br> SecondaryNameNode | DataNode                         |
| yarn    | NodeManager            | NodeManager                     | NodeManager <br> ResourceManager |

### 配置文件修改


#### 修改文件`hadoop/etc/core-site.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://alei1:9000</value>
    </property>
    <!-- 自定义 hadoop 的工作目录 -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/root/hadoop/data</value>
    </property>
    <property>
        <name>hadoop.http.staticuser.user</name>
        <value>root</value>
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

#### 修改文件`hadoop/etc/hdfs-site.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>dfs.replication</name>
		<value>3</value>
	</property>
	<!-- NameNode -->
	<property>
		<name>dfs.namenode.http-address</name>
		<value>alei1:9870</value>
	</property>
	<!-- SecondaryNameNode -->
	<property>
		<name>dfs.namenode.secondary.http-address</name>
		<value>alei2:9868</value>
	</property>
</configuration>
```

#### 修改文件`hadoop/etc/yarn-site.xml`
```xml
<?xml version="1.0"?>
<configuration>
	<!-- ResourceManager -->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>alei3</value>
    </property>
    <!-- yarn web 页面 -->
    <property>
        <name>yarn.resourcemanager.webapp.address</name>
        <value>0.0.0.0:8088</value>
    </property>
    <!-- reducer获取数据的方式 -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <!-- 输入刚才返回的Hadoop classpath路径 -->
    <property>
        <name>yarn.application.classpath</name>
        <value>/root/hadoop/etc/hadoop:/root/hadoop/share/hadoop/common/lib/*:/root/hadoop/share/hadoop/common/*:/root/hadoop/share/hadoop/hdfs:/root/hadoop/share/hadoop/hdfs/lib/*:/root/hadoop/share/hadoop/hdfs/*:/root/hadoop/share/hadoop/mapreduce/*:/root/hadoop/share/hadoop/yarn:/root/hadoop/share/hadoop/yarn/lib/*:/root/hadoop/share/hadoop/yarn/*</value>
    </property>
</configuration>
```

#### 修改文件`hadoop/etc/mapred-site.xml`
```xml
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
	</property>
</configuration>
```


#### work配置`hadoop/etc/works`

```properties
alei1
alei2
alei3
```

#### 环境配置`hadoop/etc/hadoop-env.sh`
```shell
export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}

case ${HADOOP_OS_TYPE} in
  Darwin*)
    export HADOOP_OPTS="${HADOOP_OPTS} -Djava.security.krb5.realm= "
    export HADOOP_OPTS="${HADOOP_OPTS} -Djava.security.krb5.kdc= "
    export HADOOP_OPTS="${HADOOP_OPTS} -Djava.security.krb5.conf= "
  ;;
esac

# 将当前用户 root 赋给下面这些变量
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root

# JDK 安装路径，参考 cat /etc/profile |grep JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.372.b07-1.el7_9.x86_64

# Hadop 安装路径下的 ./etc/hadoop 路径
export HADOOP_CONF_DIR=/root/hadoop/etc/hadoop
```

#### 使用如下命令 将配置下发到其他服务器（所有机器配置保持一致）
```shell
# rsync会在Development Tools安装时安装
$ rsync -av /root/hadoop/etc/hadoop root@alei2:/etc/hadoop/etc
$ rsync -av /root/hadoop/etc/hadoop root@alei2:/etc/hadoop/etc
# 首次启动时格式化目录（启动失败需要删除/root/hadoop/data和/root/hadoop/logs目录）
$ hdfs namenode -format
$ start-dfs.sh
$ start-yarn.sh
```
### 环境测试 

#### web页面
需要使用主机名访问，如果使用的的虚拟机部署，需要在宿主机上配置hosts文件

dfs管理页面：http://alei1:9870

yarn管理页面：http://alei1:8088

hive管理页面（暂未安装）：http://alei1:10002

#### dfs测试

```shell
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

## hive 安装

### mysql安装

hive的元数据使用mysql进行管理

```shell
# 删除已有mariadb（基于mysql分支，采用GPL授权许可）
$ rpm -qa | grep -i mariadb
$ rpm -e --nodeps mariadb-libs-5.5.64-1.el7.x86_64
$ rpm -qa | grep mysql
# Maybe need a little magic when installing mysql-commity-server, Please use your magic.
$ wget https://repo.mysql.com//mysql80-community-release-el7-3.noarch.rpm
$ yum -y install mysql80-community-release-el7-3.noarch.rpm
$ rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
$ yum -y install mysql-community-server
$ systemctl start mysqld.service
$ systemctl enable mysqld.service
$ cat /var/log/mysqld.log | grep password
$ mysql -uroot -p
# 修改密码 先设置符合规则的密码，再修改规则设置123456
msyql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'Abc123...';
mysql> set global validate_password.policy=LOW;
mysql> set global validate_password.length=6;
mysql> alter USER 'root'@'localhost' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;
mysql> flush privileges;
```
### 配置文件修改
#### 修改文件`hive/conf/hive-site.xml`
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

	<!-- 这里一定要是设置为true，不然后面drop table会出现卡住的情况 -->
	<property>
		<name>hive.metastore.schema.verification</name>
		<value>true</value>
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
		<value>192.168.207.128</value>
	</property>
	<!-- 配置Hive Server2 WebUI的端口号 -->
	<property>
		<name>hive.server2.webui.port</name>
		<value>10002</value>
	</property>
	<!-- Hive元数据事件通知的认证方式 -->
	<property>
		<name>hive.metastore.event.db.notification.api.auth</name>
		<value>false</value>
	</property>
	<!-- HDFS 的默认文件系统 URL -->
	<property>
		<name>fs.defaultFS</name>
		<value>hdfs://alei:9000</value>
	</property>
</configuration>
```

#### 修改文件`hive/conf/hive-env.sh`
```shell
HADOOP_HOME=/root/hadoop
```

```shell
$ wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar
$ cp mysql-connector-java-8.0.30.jar hive/lib/
$ vim .zshrc
```

### 启动hive
初始化元数据库 & 启动hive
```shell
# 初始化元数据库
$ schematool -initSchema -dbType mysql

# 启动hive
# 方式一 client jdbc/odbc hive server
$ hive --service metastore
$ hive --service hiveserver2

# 使用beeline登入
$ beeline -u jdbc:hive2://127.0.0.1:10000 -n root
# 测试数据 https://1drv.ms/t/s!AoVmZgMmPB9ziM8TGejrqM4PcVvjcQ?e=NJFyZI
$ wget https://public.bl.files.1drv.com/y4mg6tL5uAvZqDCb0O_IdPUQpX6KrEa56YWi43i_keocyRmw0oHoPNwLk3CEZxaGfYZUSXu91WX6Dq3iLEqzNStfzxKNI1Yb4Ll_1_1Lfvqz595aGTv8tMUEVSnAbP0s3ZZyA5eCDLqYtenHmcDn-lI3DWDi4_EpuVEmiKv4BvF8OTAa02K4SC6yqRs6mbkkd8Uxo-5VOu7SWeZPgrI2wAbCa41HsKF0JYYqgRlTV_Es7M?AVOverride=1
$ hadoop fs -put dmo.txt /
# 方式二 命令行
$ hive
hive> CREATE TABLE test(name string, ip string ,company string,country string) ROW FORMAT DELIMITED FIELDS TERMINATED BY ','LINES TERMINATED BY '\n'STORED AS TEXTFILE;
hive> load data inpath 'dmo.txt' into table test;
hive> select * from test limit 1000;
```

### 使用dbeaver连接hive
使用dbeaver连接hive时需要驱动，可能会出现下载不了。使用hive软件包中jdbc目jar即可。
