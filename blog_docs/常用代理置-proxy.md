### 1、git配置本地代理

```shell
# 打开cmd
$ win+r
$ git config --global http.proxy 'socks5://127.0.0.1:10808'
$ git config --global https.proxy 'socks5://127.0.0.1:10808'
# 取消代理
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy
# 文件名太长
$ git config --system core.longpaths true
# 查看配置信息
$ git config -l --global
```

### 2、gradle

```shell
# 打开cmd 不要跳转路径，在家路径操作
$ win+r
$ mkdir .gradle
$ cd .gradle
$ vim init.gradle
# 复制以下内容保存即可
```

init.gradle文件内容

```groovy
allprojects {
    repositories {
        mavenLocal()
        maven { name "public" ;  url "https://maven.aliyun.com/repository/public"}
        maven { name "google" ;  url "https://maven.aliyun.com/repository/google"}
        maven { name "gradle-plugin" ;  url "https://maven.aliyun.com/repository/gradle-plugin"}
        maven { name "spring" ; url "https://maven.aliyun.com/repository/spring"}
        maven { name "spring-plugin"; url "https://maven.aliyun.com/repository/spring-plugin"}
        maven { name "grails-core"; url "https://maven.aliyun.com/repository/grails-core"}
        maven { name "apache snapshots"; url "https://maven.aliyun.com/repository/apache-snapshots"}
        maven { name "Bstek"; url "http://nexus.bsdn.org/content/groups/public/" }
        mavenCentral()
    }

    buildscript { 
        repositories { 
            mavenLocal()
            maven { name "public" ;  url "https://maven.aliyun.com/repository/public"}
            maven { name "google" ;  url "https://maven.aliyun.com/repository/google"}
            maven { name "gradle-plugin" ;  url "https://maven.aliyun.com/repository/gradle-plugin"}
            maven { name "spring" ;  url "https://maven.aliyun.com/repository/spring"}
            maven { name "spring-plugin" ;  url "https://maven.aliyun.com/repository/spring-plugin"}
            maven { name "grails-core" ;  url "https://maven.aliyun.com/repository/grails-core"}
            maven { name "apache snapshots" ;  url "https://maven.aliyun.com/repository/apache-snapshots"}
            maven { name "Bstek" ; url 'http://nexus.bsdn.org/content/groups/public/' }
            maven { name "M2" ; url 'https://plugins.gradle.org/m2/' }
        }
    }
}
```

### 3、maven

```shell
# 打开cmd 不要跳转路径，在家路径操作
$ win+r
$ mkdir .m2
$ cd .m2
$ vim settings.xml
# 复制以下内容保存即可

# 操作完成，cd到项目所在路径
# 执行编译命令,跳过单元测试（如果存在），跳过语法检查（如果存在）
$ mvn compile -Dmaven.test.skip=true -Dcheckstyle=true

```
settings.xml文件内容


```xml
<?xml version="1.0" encoding="UTF-8" ?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="
	http://maven.apache.org/SETTINGS/1.0.0 
	http://maven.apache.org/xsd/settings-1.0.0.xsd">
	<profiles>
		<profile>
		<id>jdk-1.8</id>
			<activation>
				<activeByDefault>true</activeByDefault>
				<jdk>1.8</jdk>
			</activation>
			<properties>
				<maven.compiler.source>1.8</maven.compiler.source>
				<maven.compiler.target>1.8</maven.compiler.target>
				<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion> 
			</properties>
		</profile>
	</profiles>
	<mirrors>
		<mirror>
			<id>public</id>
			<mirrorOf>central</mirrorOf>
			<name>public</name>
			<url>https://maven.aliyun.com/repository/public</url>
		</mirror>
		<mirror>
			<id>google</id>
			<mirrorOf>central</mirrorOf>
			<name>google</name>
			<url>https://maven.aliyun.com/repository/google</url>
		</mirror>
		<mirror>
			<id>gradle-plugin</id>
			<mirrorOf>central</mirrorOf>
			<name>gradle-plugin</name>
			<url>https://maven.aliyun.com/repository/gradle-plugin</url>
		</mirror>
		<mirror>
			<id>spring</id>
			<mirrorOf>central</mirrorOf>
			<name>spring</name>
			<url>https://maven.aliyun.com/repository/spring</url>
		</mirror>
		<mirror>
			<id>spring-plugin</id>
			<mirrorOf>central</mirrorOf>
			<name>spring-plugin</name>
			<url>https://maven.aliyun.com/repository/spring-plugin</url>
		</mirror>
		<mirror>
			<id>grails-core</id>
			<mirrorOf>central</mirrorOf>
			<name>grails-core</name>
			<url>https://maven.aliyun.com/repository/grails-core</url>
		</mirror>
		<mirror>
			<id>apache snapshots</id>
			<mirrorOf>central</mirrorOf>
			<name>grails-core</name>
			<url>https://maven.aliyun.com/repository/apache-snapshots</url>
		</mirror>
	</mirrors>
</settings>
```

### 4、pip

```shell
# 打开cmd 不要跳转路径，在家路径操作
$ win+r
$ mkdir pip
$ cd pip
$ vim pip.ini
# 复制以下内容保存即可
```

pip文件内容

```ini
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host = https://pypi.tuna.tsinghua.edu.cn
```

### 5、npm

```shell
# 打开cmd
$ win+r
$ npm config set registry https://registry.npm.taobao.org
$ npm config list
```

### 6、linux全局代理
```shell
alias setproxy="export http_proxy=http://192.168.31.177:10809; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
alias unsetproxy="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
setproxy
```
### 7、apt-get代理设置
```shell
# 编辑文件.apt_proxy
Acquire::http::proxy "http://192.168.31.177:10809/";
Acquire::ftp::proxy "ftp://192.168.31.177:10809/";
Acquire::https::proxy "https://192.168.31.177:10809/";
# .zshrc添加命令
alias aptp='apt-get -c /root/.apt_proxy'
# 加载.zshrc 之后使用aptp是使用代理下载文件
source .zshrc
```

### 8、scoop相关软件安装（自行科学上网）

```shell
# 打开Powershell win+r输入powershell
# you must change the execution policy
$ Set-ExecutionPolicy RemoteSigned -scope CurrentUser
$ Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
# or shorter
$ iwr -useb get.scoop.sh | iex
# 安装git
$ scoop install git
# 添加三方仓库，包含国内GUI程序
$ scoop bucket add apps https://github.com/kkzzhizhou/scoop-apps
# 国内网络
$ scoop bucket add apps https://gitee.com/kkzzhizhou/scoop-apps
# 安装常用软件
$ scoop install aliyundrive ant baidunetdisk googlechrome gradle jetbrains-toolbox maven mysql neteasemusic nodejs python qq qqmusic vscode wechat 
```
