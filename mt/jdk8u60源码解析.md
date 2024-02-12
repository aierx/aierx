# jdk8u60源码解析

> [写Java这么久，JDK源码编译过没？编译JDK源码踩坑纪实](https://blog.csdn.net/wangshuaiwsws95/article/details/107375724/) \
> [一起来编译JDK吧！:)](https://blog.csdn.net/qq_39749527/article/details/107709708) \
> 推荐书籍：Java虚拟机规范、深入理解JVM字节码、HotSpot实战、深入理解Java虚拟机、深入理解linux内核、深入理解操作系统、算法导论

## 一、环境配置

### 1、代码下载

```shell
# 开发工具 
clion 
compiledb 
# centos编译工具链 
gun 4.x & gun 7.x
# macos编译工具链 
# 下载地址 https://developer.apple.com/download/all 
xcode 4.6.1 
# windows编译工具链 
cygwin & visual studio 2010 & freetype 2.7D

# jdk8u60
apt install mercurial 
hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/ 
# 17u gcc7 
git clone https://github.com/openjdk/jdk17u
#  ccache
https://blog.csdn.net/weixin_45875127/article/details/113307449
```

### 2、Ubuntu 18.04

```shell
sudo apt install mercurial 
sudo apt install unzip zip
sudo apt install build-essential
sudo apt install openjdk-8-jdk
sudo apt install libx11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev
sudo apt install libcups2-dev
sudo apt install libfreetype6-dev
sudo apt install libasound2-dev
sudo apt install autoconf
# 默认gcc是7.5 jdk8u60需要的jdk版本是gcc4.5
# 安装指定版本gcc和g++ 
sudo apt install gcc-4.8 g++-4.8 -y 
# 删除软链
sudo rm -fr /usr/bin/gcc
sudo rm -fr /usr/bin/g++
# 链接4.8
sudo ln /usr/bin/gcc-4.8 /usr/bin/gcc
sudo ln /usr/bin/g++-4.8 /usr/bin/g++
# 链接7
sudo ln /usr/bin/gcc-7 /usr/bin/gcc
sudo ln /usr/bin/g++-7 /usr/bin/g++
```

### 3、macos

```shell
brew install autoconf make freetype 
# libstdc++报错
# https://blog.csdn.net/quantum7/article/details/108466760
```

## 二、编译

```shell
# 8u
./configure --with-debug-level=slowdebug

# 8u windows
./configure --with-debug-level=slowdebug --with-freetype=/cygdrive/c/freetype --disable-zip-debug-info


# 17u wsl ubuntu
./configure --with-debug-level=slowdebug --build=x86_64-unknown-linux-gnu --host=x86_64-unknown-linux-gnu 

# 编译 
make JOBS=16
make JOBS=16 compile-commands
```

- --with-debug-level=slowdebug 可选值为release、fastdebug、slowde-bug

#### 踩坑1、系统版本不支持

- 修改该文件 vim hotspot/make/linux/Makefile # 查找如下的字段，添加5%（表示支持gnu5版本） SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4% 5%

#### 踩坑2、jdk环境设置7

- 修改该文件 vim hotspot/make/linux/makefiles/rules.make # 设置编译jdk的版本，也就是自己安装的jdk版本（一般是当前被编译的jdk前一个版本） BOOT_SOURCE_LANGUAGE_VERSION = 7

#### 踩坑3、忽略告警

- 修改该文件 vim hotspot/make/linux/makefiles/gcc.make # 忽略c语言一些文件的告警 WARNINGS_ARE_ERRORS = -Werror

#### 踩坑4、时间问题

- Error: time is more than 10 years from present: 1388527200000
修改openjdk/jdk/src/share/classes/java/util/CurrencyData.properties中的时间
可以使用正则/;20搜索时间

## 三、JVM常用参数

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

## 四、Openjdk8u 源码位置导航

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
