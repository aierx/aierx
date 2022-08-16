### 1、oh-my-zsh 安装

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

### 2、安装gcc9
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