# jdk8u60源码解析

> [写Java这么久，JDK源码编译过没？编译JDK源码踩坑纪实](https://blog.csdn.net/wangshuaiwsws95/article/details/107375724/) \
> [一起来编译JDK吧！:)](https://blog.csdn.net/qq_39749527/article/details/107709708)

## 一、起步

```shell
# 平台无关工具 
mercurial 
autoconfig 
make 
# 依赖库（以windows系统为准） 
freetype 2.7D 
# 开发工具 
clion 
compiledb 
# centos编译工具链 
gcc 4.x 
gdb 8.x 
# macos编译工具链 
# 下载地址 https://developer.apple.com/download/all 
xcode 4.6.1 
# windows编译工具链 
cygwin 
visual studio 2010 
# 源码下载地址 
➜ apt-get install mercurial 
➜ hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/ 
➜ cd mercurial 
➜ chmod +x ./get_source.sh 
➜ ./get_source.sh
```

推荐书籍：Java虚拟机规范、深入理解JVM字节码、HotSpot实战、深入理解Java虚拟机、深入理解linux内核、深入理解操作系统、算法导论

## 二、JVM常用参数

| 参数| 含义|
|---|---|
|-XX:+PrintGC | 打印GC|
|-XX:+PrintGCDetails|打印详细GC|
|-XX:+PrintHeapAtGC|每次GC打印堆信息|
|-XX:+PrintGCTimeStamps|每次打印GC日志的时候，还要输出时间信息(系统启动后的时间)。|
|-XX:+PrintGCApplicationConcurrentTime|打印应用程序的执行时间(到达安全点safepoint的时间)，一般是跟下面的参数一起使用|
|-XX:+PrintGCApplicationStoppedTime|打印应用程序因为GC停顿的时间(stw机制）|
|-XX:+PrintReferenceGC|打印引用相关的GC。这个可以跟踪系统内的软引用、弱引用、虚引用和Finallize队列。|
|-Xloggc:log/gc.log|
|-Xms10m|最小堆|
|-Xmx20m|最大堆|
|-Xmn3m|新生代|
|-XX:SurvivorRatio=2|eden/from=2|
|-XX:NewRatio=3|老年代/新生代=3|
|-XX:+PrintCommandLineFlags|打印垃圾回收器|
|-XX:+PrintFlagsWithComments|打印所有参数|
|-XX:+NativeMemoryTracking|内存跟踪|
|-XX:+TraceClassLoading|类加载|
|-XX:+TraceClassUnloading|类卸载|
|-XX:+TraceClassLoadingPreorder|
|-XX:+Verbose|
|-XX:+PrintGC|
|-XX:+ShowSafepointMsgs|
|-XX:+PrintCFGToFile|
|-XX:+PrintAssembly|
|-XX:+UseSerialGC|
|_JAVA_LAUNCHER_DEBUG=1 |环境变量，开启debug模式|

## 三、Openjdk8u 源码位置导航

|名称|位置|
|--|--|
|【锁】轻量级锁|[/hotspot/src/share/vm/runtime/synchronizer.cpp#l226](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/synchronizer.cpp#l226)|
|【GC】垃圾回收|[/hotspot/src/share/vm/memory/genCollectedHeap.cpp#l357](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/memory/genCollectedHeap.cpp#l357)|
|【win线程】调用系统方法创建线程|[/hotspot/src/os/windows/vm/os_windows.cpp#l596](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l596)|
|【win线程】创建线程|[/hotspot/src/os/windows/vm/os_windows.cpp#l528](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l528)|
|【win线程】符号导出|[/jdk/src/share/native/java/lang/Thread.c#l43](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/native/java/lang/Thread.c#l43)|
|【win网络】write0|[/jdk/src/windows/native/java/net/SocketOutputStream.c#l60](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketOutputStream.c#l60)|
|【win网络】read0|[/jdk/src/windows/native/java/net/SocketInputStream.c#l61](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketInputStream.c#l61)|
|【JDK】调用main函数|[/jdk/src/share/bin/java.c#l477](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l477)|
|【Hostpsot】一些服务初始化|[/hotspot/src/share/vm/services/management.cpp#l83](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/services/management.cpp#l83)|
|【hostspot】创建vm虚拟机|[/hotspot/src/share/vm/prims/jni.cpp#l5196](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/prims/jni.cpp#l5196)|
|【hostspot】初始化vm虚拟机|[/jdk/src/share/bin/java.c#l376](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l376)|
|【JDK】JavaMain|[/jdk/src/share/bin/java.c#l354](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l354)|
|【GC】GC原因|[/hotspot/src/share/vm/gc_interface/gcCause.hpp#l38](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/gc_interface/gcCause.hpp#l38)|
|【字节码】Class文件解析|[/hotspot/src/share/vm/classfile/classFileParser.cpp#l3701](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/classfile/classFileParser.cpp#l3701)|
|【JNI】符号大全|[/jdk/make/mapfiles/libnet/mapfile-vers#l29](https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/make/mapfiles/libnet/mapfile-vers#l29)|
|【JNI】符号表table赋值|[/hotspot/src/share/vm/runtime/thread.hpp#l988](https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/thread.hpp#l988)|

四、编译

系统 Ubuntu 编译工具链 GCC-7.3.1、GCC-C++-7.3.1、make-3.8.2

调试工具 gdb-7.6.1

构建命令 cmake3 .. -DDOWNLOAD_BOOST=1 -DWITH_BOOST=../boost -DCMAKE_CXX_COMPILER=/usr/local/bin/g++ -DCMAKE_C_COMPILER=/usr/local/bin/gcc

编译命令 cmake3 --build . --config Debug

初始化命令 ./msyqld --defaults-file=/XXX/my.cnf --initializable --console

启动命令 ./mysqld --defaults-file=/XXX/my.cnf &

注册服务 sudo ./mysqld install

系统 macos bigsur 11.6

编译工具链 xcode10

调试工具 lldb、clion

五、Macos

使用hg下载源码，下载完成

![1](https://raw.githubusercontent.com/aierx/images/master/202401151348894.png)

boot jdk环境

下载地址：orcale

libstdc++报错

https://blog.csdn.net/quantum7/article/details/108466760

安装编译环境需要的工具

```shell

$ brew install autoconf make freetype 
# 软件源码包的自动配置工具
$ autoconf --version
# 编译构建工具
$ make --version
# 一个免费的渲染库，JDK图形化部分的代码可能会用它
$ freetype-config --version
$ xcodebuild -version
$ clang --version
# 检查编译
$ sh configure
# 开始编译，可以冲杯咖啡等待一会
$ make all
```

检查编译环境，出现下面界面表示成功

## 六、Ubuntu

### 安装make3.81

```shell
下载源码地址：https://ftp.gnu.org/gnu/make/

tar -zxvf make-3.81.tar.gz 
vim make-3.81/glob/glob.c

添加： #define __alloca alloca

#define __alloca alloca //添加的代码 
#if defined _AIX && !defined __GNUC__ 
    #pragma alloca 
#endif

```

### 执行

```shell
$ ./configure --prefix=/usr 
$ sudo make 
$ sudo make install

```

### 安装gcc和g++

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
sudo update-alternatives --config g+

```

### 下载jdk

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

### 编译环境 jdk下载

```shell
# 编译JDK前需要一个启动JDK，这个JDK用于编译源码中的JAVA文件，也就是rt.jar
# 目前aliyun的ubuntu仓库中只有openjdk-8-jdk，其他低版本的需要自行下载安装 
sudo apt-get install openjdk-8-jdk 
# 华为云仓库保存的jdk-7u80 
https://repo.huaweicloud.com/java/jdk/7u80-b15/
# 配置环境变量.bashrc或.zshrc中 
export JAVA_HOME=/usr/local/jdk1.7.0_80 
export JRE_HOME=$JAVA_HOME/jre 
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib 
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

```

### 需要的依赖

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

### 编译

```shell
# 配置编译文件 
bash configure --enable-debug --with-jvm-variants=server 
bash configure --disable-warnings-as-errors --with-debug-level=slowdebug --with-jvm-variants=server 

# 编译 
make images
```

- disable-warnings-as-errors选项是禁止把warning 当成error

- --with-debug-level=slowdebug用来设置编译的级别，可选值为release、fastdebug、slowde-bug，越往后进行的优化措施就越少，带的调试信息就越多。默认值为release。slowdebug 含有最丰富的调试信息，没有这些信息，很多执行可能被优化掉，我们单步执行时，可能看不到一些变量的值。所以最好指定slowdebug 为编译级别。

- with-jvm-variants 编译特定模式的HotSpot虚拟机，可选值：server、client、minimal、core、zero、custom

#### 坑1、系统版本不支持

- 修改该文件 vim hotspot/make/linux/Makefile # 查找如下的字段，添加5%（表示支持gnu5版本） SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4% 5%

#### 踩坑2、jdk环境设置7

- 修改该文件 vim hotspot/make/linux/makefiles/rules.make # 设置编译jdk的版本，也就是自己安装的jdk版本（一般是当前被编译的jdk前一个版本） BOOT_SOURCE_LANGUAGE_VERSION = 7

#### 踩坑3、忽略告警

- 修改该文件 vim hotspot/make/linux/makefiles/gcc.make # 忽略c语言一些文件的告警 WARNINGS_ARE_ERRORS = -Werror

## 七、windows

```shell
$ cd /cygdrive/c/Users/aleiwe/Desktop/framework/jdk8u60/
$ bash ./configure --with-debug-level=slowdebug --with-freetype=/cygdrive/c/freetype --disable-zip-debug-info
$ make images CONF=linux-x86_64-normal-server-fastdebug compile-commands
$ --with-freetype-include=/usr/include/freetype2 --with-freetype-lib=/usr/lib/x86_64-linux-gnu
```

## 八、centos

8u60
```shell

➜  jdk8u60 uname -a

Linux ide-sh-system-150652-l9dbq 4.18.0-147.mt20200626.413.el8_1.x86_64 #1 SMP Fri Jun 26 10:27:19 CST 2020 x86_64 x86_64 x86_64 GNU/Linux

➜  jdk8u60 gcc -v

Using built-in specs.

COLLECT_GCC=gcc

COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper

Target: x86_64-redhat-linux

Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux

Thread model: posix

gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)

➜  jdk8u60 g++ -v

Using built-in specs.

COLLECT_GCC=g++

COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper

Target: x86_64-redhat-linux

Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-linker-hash-style=gnu --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto --enable-plugin --enable-initfini-array --disable-libgcj --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install --enable-gnu-indirect-function --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux

Thread model: posix

gcc version 4.8.5 20150623 (Red Hat 4.8.5-44) (GCC)

➜  jdk8u60 make -v

GNU Make 3.82

Built for x86_64-redhat-linux-gnu

Copyright (C) 2010  Free Software Foundation, Inc.

License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software: you are free to change and redistribute it.

There is NO WARRANTY, to the extent permitted by law.

yum install mercurial

hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/

sudo yum install libXtst-devel libXt-devel libXrender-devel

sudo yum install cups-devel

sudo yum install freetype-devel

sudo yum install alsa-lib-devel

cd jdk8u60

chmod +x configure

./configure

make

17U https://github.com/openjdk/jdk17u

gcc 7.5

make

export CC=/usr/local/bin/gcc

export CXX=/usr/local/bin/g++

```