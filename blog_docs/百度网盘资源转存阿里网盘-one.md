## 利用服务器空闲时间将百度网盘资源转存阿里网盘

### 1、centos下载安装

- #### 下载

```shell
http://mirrors.btte.net/centos/7/isos/x86_64/ 
http://mirrors.cn99.com/centos/7/isos/x86_64/ 
http://mirrors.sohu.com/centos/7/isos/x86_64/ 
http://mirrors.aliyun.com/centos/7/isos/x86_64/ 
http://centos.ustc.edu.cn/centos/7/isos/x86_64/ 
http://mirrors.neusoft.edu.cn/centos/7/isos/x86_64/ 
http://mirror.lzu.edu.cn/centos/7/isos/x86_64/ 
http://mirrors.163.com/centos/7/isos/x86_64/ 
http://ftp.sjtu.edu.cn/centos/7/isos/x86_64/
```

- #### 安装 (一直下一步即可)

- #### 配置网络

- 动态IP地址
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
```shell
# 修改ONBOOT=yes
# 修改BOOTPROTO=dhcp
$ vi /etc/sysconfig/network-scripts/ifcfg-ens33
$ ip addr
$ systemctl restart network
```
- 静态IP地址设置

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
UUID=ed85429a-2804-4074-8cb4-ad312f7414a4
DEVICE=ens33
ONBOOT=yes
# IP地址
IPADDR=192.168.1.160
# 子网掩码
NETMASK=255.255.255.0
# 网关
GATEWAY=192.168.1.1
DNS1=119.29.29.29
DNS2=8.8.8.8
```
重启网络即可获取IP地址

- ##### 开启SSHD，使用ssh访问

```shell
# 安装sshd工具
$ yum install sshd -y
# 启动sshd服务
$ systemctl start sshd
# 查看sshd服务状态
$ systemctl status sshd
# 客户端也要安装对应的软件或者工具，使用如下命令：
$ ssh root@192.168.249.128
```

- #### 配置国内镜像源加快软件安装速度

[centos镜像-centos下载地址-centos安装教程-阿里巴巴开源镜像站 (aliyun.com)](https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.7f891b11W3DlR9)

```shell
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
$ yum install wget vim unzip epel-release -y
```

- #### 防火墙相关配置

 一、防火墙的开启、关闭、禁用命令

（1）设置开机启用防火墙：systemctl enable firewalld.service

（2）设置开机禁用防火墙：systemctl disable firewalld.service

（3）启动防火墙：systemctl start firewalld

（4）关闭防火墙：systemctl stop firewalld

（5）检查防火墙状态：systemctl status firewalld 

二、使用firewall-cmd配置端口

（1）查看防火墙状态：firewall-cmd --state

（2）重新加载配置：firewall-cmd --reload

（3）查看开放的端口：firewall-cmd --list-ports

（4）开启防火墙端口：firewall-cmd --zone=public --add-port=9200/tcp --permanent

　　命令含义：

　　–zone #作用域

　　–add-port=9200/tcp #添加端口，格式为：端口/通讯协议

　　–permanent #永久生效，没有此参数重启后失效

　　**注意：添加端口后，必须用命令firewall-cmd --reload重新加载一遍才会生效**

（5）关闭防火墙端口：firewall-cmd --zone=public --remove-port=9200/tcp --permanent

### 2、测试自己服务器的网络速度(speedTest)

- ##### [Speedtest CLI](https://www.speedtest.net/zh-Hans/apps/cli)官网下载

```shell
## If migrating from prior bintray install instructions please first...
# sudo rm /etc/yum.repos.d/bintray-ookla-rhel.repo
# sudo yum remove speedtest
## Other non-official binaries will conflict with Speedtest CLI
# Example how to remove using yum
# rpm -qa | grep speedtest | xargs -I {} sudo yum -y remove {}
# --share 生成网页图片 
# --server 指定测试节点 
# --list 查看节点
$ curl -s https://install.speedtest.net/app/cli/install.rpm.sh | sudo bash
# 测试网络速度
$ speedtest
$ sudo yum install speedtest -y
$ speedtest --list
$ speedtest --server=1234 --share
```

- ##### 通过直接下载speedTest脚本，给权限运行脚本即可

```shell
$ wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
$ chmod +x speedtest-cli
$ ./speedtest-cli --share
```

- ##### 通过pip安装

```shell
# 安装pip
$ wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
$ python get-pip.py
# 安装speedtest-cli
$ pip install speedtest-cli
# 查看文件所在目录
$ which speedtest-cli
$ /usr/local/bin/speedtest-cli --share
```

### 3、安装docker（centos7）

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
   "registry-mirrors": ["https://wob3bc3h.mirror.aliyuncs.com"]
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

![image-20220103143331832](https://s2.loli.net/2022/01/03/iuDLMrh1Psn6JzA.png)

### 4、安装[webdav-aliyundriver](https://github.com/zxbu/webdav-aliyundriver)(使用docker安装)

`简介:`本项目实现了阿里云盘的webdav协议，只需要简单的配置一下，就可以让阿里云盘变身为webdav协议的文件服务器。 基于此，你可以把阿里云盘挂载为Windows、Linux、Mac系统的磁盘，可以通过NAS系统做文件管理或文件同步，更多玩法等你挖掘

```shell
# 安装docker
$ docker search webdav-aliyundriver
$ docker pull zx5253/webdav-aliyundriver
$ docker run -d --name=aliyun --restart=always -p 8080:8080 -v /etc/localtime:/etc/localtime -v /root/aliyun-driver/:/etc/aliyun-driver/ -e TZ="Asia/Shanghai" -e ALIYUNDRIVE_REFRESH_TOKEN="e9ee6275a5294f269c4dd311e89b1b0b" -e ALIYUNDRIVE_AUTH_PASSWORD="02580258@lL" -e JAVA_OPTS="-Xmx1g" zx5253/webdav-aliyundriver
```

安装完成后登入[http://1.116.216.21:8080](http://1.116.216.21:8080/)可访问的自己阿里网盘，windows系统可以安装RaiDriver通过WebDav协议挂载自己的网盘到具体的盘符上面

![webdav](https://s2.loli.net/2022/01/03/TbCJI3j5fW4vSrh.png)

### 5、安装[BaiduPCS-Web](https://gitee.com/masx200/baidupcs-web)百度网盘下载工具

###  BaiduPCS-Web

这个项目基于BaiduPCS-Go, 可以让你高效的使用百度云

#### 在公众号上用心写了一篇介绍，让大家更好地了解和使用BaiduPCS-Go Web版

[https://w.url.cn/s/AdjX09Y](https://gitee.com/link?target=https%3A%2F%2Fw.url.cn%2Fs%2FAdjX09Y)

```shell
$ wget https://gitee.com/masx200/baidupcs-web/attach_files/704780/download/BaiduPCS-Go-v3.7.3-linux-amd64.zip
$ yum install unzip -y
# 解压文件
$ unzip BaiduPCS-Go-v3.7.3-linux-amd64.zip
# 后台运行程序
$ nohup BaiduPCS-Go-v3.7.3-linux-amd64/BaiduPCS-Go &
# jobs查看后台进程
$ jobs
# ps查看所有进程
$ ps
$ kill %jobnum
$ kill pid
# 开启端口
$ firewall-cmd --list-ports
$ firewall-cmd --zone=public --add-port=5299/tcp --permanent
$ firewall-cmd --reload
```

```properties
[Unit]
Description="百度网盘下载服务"
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
ExecStart=/bin/sh /root/BaiduPCS-Go-v3.7.3-linux-amd64 start
ExecReload=/bin/sh /root/BaiduPCS-Go-v3.7.3-linux-amd64 restart
ExecStop=/bin/sh /root/BaiduPCS-Go-v3.7.3-linux-amd64 stop
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

![image-20220102221745526](https://s2.loli.net/2022/01/03/HaDdMx6sSWAJc8r.png)

### 5、centos7安装davfs2挂载webdav服务

使用百度网盘web工具将资源下载到服务器上挂载的webdav服务，webdav服务将资源自动上传至阿里云盘。

```shell
# 启用epel-release仓库
$ yum -y install epel-release
$ yum install davfs2 -y
$ mkdir aliyun-disk
# 阿里网盘webdav的账号密码
$ mount -t davfs http://localhost:8080 ./aliyun-disk/
$ cd aliyun-disk
$ pwd
```

输入账号密码即可挂在成功

![image-20220103143442657](https://s2.loli.net/2022/01/03/OVkvF5ALBxcKMGf.png)

配置下载路径，可以在手机端和PC端访问

![image-20220103143456392](https://s2.loli.net/2022/01/03/Z8SHJ3r7bmljPxM.png)