>参考文档：https://blog.csdn.net/qq_39749527/article/details/107709708

#### 1、下载系统安装包

http://mirrors.aliyun.com/ubuntu-releases/18.04/

http://ftp.sjtu.edu.cn/ubuntu-cd/18.04/

我这里下载：http://ftp.sjtu.edu.cn/ubuntu-cd/18.04/ubuntu-18.04.6-desktop-amd64.iso

#### 2、安装ubuntu18.04

切忌首先断开网络，不然安装会特别慢。

#### 3、sshd配置配置

```shell
sudo apt install openssh-server
sudo service ssh restart
#ps -aux |grep ssh
```

#### 4、设置分辨率

```shell
cvt 2560 1440
xrandr --newmode "2560x1440_60.00"  312.25  2560 2752 3024 3488  1440 1443 1448 1493 -hsync +vsync
xrandr --addmode Virtual1 "2560x1440_60.00"
xrandr --output Virtual1 --mode "2560x1440_60.00"
```

#### 5、安装搜狗输入法

https://pinyin.sogou.com/linux/guide

#### 6、浏览器

```shell
vim /usr/bin/google-chrome exec -a "$0" "$HERE/chrome" "$@" --user-data-dir --no-sandbox
```

#### 7、安装oh_my_zsh

```shell
sudo apt-get install zsh
chsh -s /bin/zsh
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
```

#### 8、curl设置代理

```shell
vim ~/.curlrc
socks5 = "192.168.31.178:10808"
```

#### 9、git设置代理

```shell
git config --global http.proxy 'socks5://192.168.31.178:10808'
git config --global https.proxy 'socks5://192.168.31.178:10808'
```


#### 10、全局代理

- 修改shell配置文件 ~/.bashrc 或者 ~/.zshrc

 ```shell
  export http_proxy=socks5://127.0.0.1:1024
  export https_proxy=$http_proxy
 ```

#### 11、设置setproxy和unsetproxy 可以快捷的开关

- 需要时先输入命令 setproxy

- 不需要时输入命令 unsetproxy

 ```shell
  alias setproxy="export http_proxy=http://192.168.31.178:10809; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
  alias unsetproxy="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
 ```

#### 12、安装make3.81

下载源码地址：https://ftp.gnu.org/gnu/make/

```shell
tar -zxvf make-3.81.tar.gz
vim make-3.81/glob/glob.c
```

添加： #define __alloca alloca

``` makefile
#define __alloca alloca //添加的代码
#if defined _AIX && !defined __GNUC__
 	#pragma alloca
#endif
```

执行

```shell
./configure --prefix=/usr
sudo make
sudo make install
```

#### 13、安装gcc和g++

```shell
# 安装指定版本gcc和g++
sudo apt-get install gcc-4.8 g++-4.8 -y
ls /usr/bin/gcc*
# 添加版本
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100
# 切换版本
sudo update-alternatives --config gcc
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 100
sudo update-alternatives --config g++
```

#### 14、下载jdk

```shell
# 官方下载地址
apt-get install mercurial
hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/
# github下载地址
git clone https://github.com/openjdk/jdk.git
# gitee检出特定版本地址
git clone https://gitee.com/huan4j/jdk8.git
# gitee极速下载地址
git clone https://gitee.com/mirrors/openjdk.git
```

#### 15、编译环境 jdk下载

```shell
# 目前aliyun的ubuntu仓库中只有openjdk-8-jdk，其他低版本的需要自行下载安装
sudo apt-get install openjdk-8-jdk
# 华为云仓库保存的jdk-7u80
https://repo.huaweicloud.com/java/jdk/7u80-b15/
https://repo.huaweicloud.com/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
# 配置环境变量.bashrc或.zshrc中
export JAVA_HOME=/usr/local/jdk1.7.0_80
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
```

#### 16、需要的依赖

```shell
sudo apt-get install libX11-dev libxext-dev libxrender-dev libxtst-dev
sudo apt-get install build-essential
sudo apt-get install libfreetype6-dev 
sudo apt-get install libcups2-dev
sudo apt-get install libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev
sudo apt-get install libasound2-dev
sudo apt-get install libffi-dev
sudo apt-get install autoconf
sudo apt-get install ccache
```

#### 17、编译配置文件生成和开始编译

```shell
# 配置编译文件
bash configure --enable-debug --with-jvm-variants=server
bash configure --disable-warnings-as-errors --with-debug-level=slowdebug --with-jvm-variants=server
# 开始编译
make images
```

- `disable-warnings-as-errors`选项是禁止把`warning` 当成`error`
- `--with-debug-level=slowdebug`用来设置编译的级别，可选值为`release`、`fastdebug`、`slowde-bug`，越往后进行的优化措施就越少，带的调试信息就越多。默认值为release。`slowdebug` 含有最丰富的调试信息，没有这些信息，很多执行可能被优化掉，我们单步执行时，可能看不到一些变量的值。所以最好指定`slowdebug` 为编译级别。
- `with-jvm-variants` 编译特定模式的HotSpot虚拟机，可选值：`server`、`client`、`minimal`、`core`、`zero`、`custom`

#### 踩坑1、系统版本不支持

```shell
# 修改该文件
vim hotspot/make/linux/Makefile
# 查找如下的字段，添加5%（表示支持gnu5版本）
SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4% 5%
```

#### 踩坑2、jdk环境设置7

```shell
# 修改该文件
vim hotspot/make/linux/makefiles/rules.make
# 设置编译jdk的版本，也就是自己安装的jdk版本（一般是当前被编译的jdk前一个版本）
BOOT_SOURCE_LANGUAGE_VERSION = 7
```

#### 踩坑3、忽略告警

```shell
# 修改该文件
vim hotspot/make/linux/makefiles/gcc.make
# 忽略c语言一些文件的告警
WARNINGS_ARE_ERRORS = -Werror
```