# 下载
>http://mirrors.btte.net/centos/7/isos/x86_64/ 

>http://mirrors.cn99.com/centos/7/isos/x86_64/ 

>http://mirrors.sohu.com/centos/7/isos/x86_64/ 

>http://mirrors.aliyun.com/centos/7/isos/x86_64/ 

>http://centos.ustc.edu.cn/centos/7/isos/x86_64/ 

>http://mirrors.neusoft.edu.cn/centos/7/isos/x86_64/ 

>http://mirror.lzu.edu.cn/centos/7/isos/x86_64/ 

>http://mirrors.163.com/centos/7/isos/x86_64/ 

>http://ftp.sjtu.edu.cn/centos/7/isos/x86_64/

# 配置网络

- 动态IP配置

```properties
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
UUID=ed85429a-2804-4074-8cb4-ad312f7414a4
DEVICE=ens33
ONBOOT=yes
```
```bash
# 修改ONBOOT=yes
# 修改BOOTPROTO=dhcp
$ vi /etc/sysconfig/network-scripts/ifcfg-ens33
$ ip addr
$ systemctl restart network
```

# 开启SSHD，使用ssh访问

```bash
# 安装sshd工具
$ yum install sshd -y
# 启动sshd服务
$ systemctl start sshd
# 查看sshd服务状态
$ systemctl status sshd
# 客户端也要安装对应的软件或者工具，使用如下命令：
$ ssh root@192.168.249.128
```

# 配置国内镜像源加快软件安装速度

[centos镜像-centos下载地址-centos安装教程-阿里巴巴开源镜像站 (aliyun.com)](https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.7f891b11W3DlR9)

```bash
# 备份镜像
$ mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
# 阿里镜像
$ wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
$ curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
# 腾讯镜像
$ wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.cloud.tencent.com/repo/centos7_base.repo
$ yum clean all
$ yum makecache
# 安装常用工具
$ yum install wget vim unzip epel-release git zhs tmux ranger -y

$ yum grouplist
$ yum groupinstall -y "Development Tools"
```

# 防火墙相关配置

> 一、防火墙的开启、关闭、禁用命令
>
>（1）设置开机启用防火墙：systemctl enable firewalld.service
>
>（2）设置开机禁用防火墙：systemctl disable firewalld.service
>
>（3）启动防火墙：systemctl start firewalld
>
>（4）关闭防火墙：systemctl stop firewalld
>
>（5）检查防火墙状态：systemctl status firewalld 

> 二、使用firewall-cmd配置端口
> 
> （1）查看防火墙状态：firewall-cmd --state
> 
> （2）重新加载配置：firewall-cmd --reload
> 
> （3）查看开放的端口：firewall-cmd --list-ports
> 
> （4）开启防火墙端口：firewall-cmd --zone=public --add-port=9200/> tcp --permanent
> 
> 　　命令含义：
> 
> 　　–zone #作用域
> 
> 　　–add-port=9200/tcp #添加端口，格式为：端口/通讯协议
> 
> 　　–permanent #永久生效，没有此参数重启后失效
> 
> 　　**注意：添加端口后，必须用命令firewall-cmd --reload重新加载一遍才会生效**
> 
> （5）关闭防火墙端口：firewall-cmd --zone=public --remove-port=9200/> tcp --permanent

# 安装docker

- 按照[官网centos](https://docs.docker.com/engine/install/centos/)教程安装docker

  ```shell
  $ sudo yum install -y yum-utils
  $ sudo yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo
  # 开启nightly版本docker
  $ sudo yum-config-manager --enable docker-ce-nightly
  # 开启test版本docker
  $ sudo yum-config-manager --enable docker-ce-test
  # 禁用nightly版本docker
  $ sudo yum-config-manager --disable docker-ce-nightly
  # 安装docker
  $ sudo yum install docker-ce docker-ce-cli containerd.io -y
  # 启动docker
  $ sudo systemctl start docker
  ```

- 配置阿里云镜像加速功能

  ```shell
  $ sudo mkdir -p /etc/docker
  $ sudo tee /etc/docker/daemon.json <<-'EOF'
  {
    "registry-mirrors": ["****"]
  }
  EOF
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart docker
  ```

- 安装portainer

  ```shell
  $ docker search portainer
  $ docker pull 6053537/portainer
  $ docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v /root/portainer:/data 6053537/portainer
  # 查看端口 http://192.168.249.120:9000
  $ ip addr
  ```

# 安装`webdav-aliyundriver`(使用docker安装)

> 简介:本项目实现了阿里云盘的webdav协议，只需要简单的配置一下，就可以让阿里云盘变身为webdav协议的文件服务器。 基于此，你可以把阿里云盘挂载为Windows、Linux、Mac系统的磁盘，可以通过NAS系统做文件管理或文件同步，更多玩法等你挖掘

```shell
# 安装docker
$ docker search webdav-aliyundriver
$ docker pull zx5253/webdav-aliyundriver
$ docker run -d --name=aliyun --restart=always -p 8080:8080 -v /etc/localtime:/etc/localtime -v /root/aliyun-driver/:/etc/aliyun-driver/ -e TZ="Asia/Shanghai" -e ALIYUNDRIVE_REFRESH_TOKEN="e9ee6275a5294f269c4dd311e89b1b0b" -e ALIYUNDRIVE_AUTH_PASSWORD="02580258@lL" -e JAVA_OPTS="-Xmx1g" zx5253/webdav-aliyundriver
```

# oh-my-zsh 安装

```bash
# 查看系统当前使用的shell
[root@MiWiFi-R4CM-srv ~]# echo $SHELL
/bin/bash

# 查看系统是否安装了zsh
[root@MiWiFi-R4CM-srv ~]# cat /etc/shells
/bin/sh
/bin/bash
/usr/bin/sh
/usr/bin/bash

# 用yum安装zsh
[root@MiWiFi-R4CM-srv ~]# yum -y install zsh

# 切换shell为zsh
[root@MiWiFi-R4CM-srv ~]#  chsh -s /bin/zsh
Changing shell for root.
Shell changed.

#重启
[root@MiWiFi-R4CM-srv ~]# reboot

# 使用代理安装oh-my-zsh
[root@MiWiFi-R4CM-srv]~# wget -e "https_proxy=http://192.168.31.177:10809" https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh

# 安装自动补全插件
➜  ~ cd .oh-my-zsh/plugins
➜  plugins git:(master) wget -e "https_proxy=http://192.168.31.177:10809" http://mimosa-pudica.net/src/incr-0.2.zsh --no-check-certificate
--2022-05-27 17:53:38--  http://mimosa-pudica.net/src/incr-0.2.zsh
Resolving mimosa-pudica.net (mimosa-pudica.net)... 185.199.109.153, 185.199.110.153, 185.199.111.153, ...
Connecting to mimosa-pudica.net (mimosa-pudica.net)|185.199.109.153|:80... connected.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://mimosa-pudica.net/src/incr-0.2.zsh [following]
--2022-05-27 17:53:40--  https://mimosa-pudica.net/src/incr-0.2.zsh
Connecting to 192.168.31.177:10809... connected.
WARNING: cannot verify mimosa-pudica.net's certificate, issued by ‘/C=US/O=Let's Encrypt/CN=R3’:
  Issued certificate has expired.
Proxy request sent, awaiting response... 200 OK
Length: 2631 (2.6K) [application/octet-stream]
Saving to: ‘incr-0.2.zsh’

100%[==============================================================================>] 2,631       --.-K/s   in 0.001s

2022-05-27 17:53:40 (2.49 MB/s) - ‘incr-0.2.zsh’ saved [2631/2631]
➜  plugins git:(master) ✗ source incr-0.2.zsh
➜  plugins git:(master) ✗ cd ../../
➜  ~ source ~/.zshrc
```

# scl工具
```bash
# 安装scl源
yum install centos-release-scl scl-utils-build -y

# 列出所有可用的scl源
yum list all --enablerepo='centos-sclo-rh' | grep "devtoolset-"

# 安装gcc9
yum install devtoolset-9-toolchain -y

# 启动环境
scl enable devtoolset-9 bash
gcc --version

# 永久环境
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
```
