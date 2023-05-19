> [写Java这么久，JDK源码编译过没？编译JDK源码踩坑纪实](https://blog.csdn.net/wangshuaiwsws95/article/details/107375724/)

> [一起来编译JDK吧！:)](https://blog.csdn.net/qq_39749527/article/details/107709708)

# 起步

```bash
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
➜  apt-get install mercurial
➜  hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/
➜  cd mercurial
➜  chmod +x ./get_source.sh
➜  ./get_source.sh
```
> 推荐书籍：`Java虚拟机规范`、`深入理解JVM字节码`、`HotSpot实战`、`深入理解Java虚拟机`、`深入理解linux内核`、`深入理解操作系统`、`算法导论`

# JVM常用参数
|参数|含义|
|----|----|
|-XX:+PrintGC|打印GC|
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
|-XX:+Verbose||
|-XX:+PrintGC||
|-XX:+ShowSafepointMsgs||
|-XX:+PrintCFGToFile||
|-XX:+PrintAssembly||
|-XX:+UseSerialGC||
|_JAVA_LAUNCHER_DEBUG=1|环境变量，开启debug模式|

# Openjdk8u 源码位置导航
|名称|位置|
|----|----|
|【锁】轻量级锁|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/synchronizer.cpp#l226" target="_blank">/hotspot/src/share/vm/runtime/synchronizer.cpp#l226</a>|
|【GC】垃圾回收|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/memory/genCollectedHeap.cpp#l357" target="_blank">/hotspot/src/share/vm/memory/genCollectedHeap.cpp#l357</a>|
|【win线程】调用系统方法创建线程|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l596" target="_blank">/hotspot/src/os/windows/vm/os_windows.cpp#l596</a>|
|【win线程】创建线程|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l528" target="_blank">/hotspot/src/os/windows/vm/os_windows.cpp#l528</a>|
|【win线程】符号导出|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/native/java/lang/Thread.c#l43" target="_blank">/jdk/src/share/native/java/lang/Thread.c#l43</a>|
|【win网络】write0|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketOutputStream.c#l60" target="_blank">/jdk/src/windows/native/java/net/SocketOutputStream.c#l60</a>|
|【win网络】read0|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketInputStream.c#l61" target="_blank">/jdk/src/windows/native/java/net/SocketInputStream.c#l61</a>|
|【JDK】调用main函数|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l477" target="_blank">/jdk/src/share/bin/java.c#l477</a>|
|【Hostpsot】一些服务初始化|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/services/management.cpp#l83" target="_blank">/hotspot/src/share/vm/services/management.cpp#l83</a>|
|【hostspot】创建vm虚拟机|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/prims/jni.cpp#l5196" target="_blank">/hotspot/src/share/vm/prims/jni.cpp#l5196</a>|
|【hostspot】初始化vm虚拟机|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l376" target="_blank">/jdk/src/share/bin/java.c#l376</a>|
|【JDK】JavaMain|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l354" target="_blank">/jdk/src/share/bin/java.c#l354</a>|
|【GC】GC原因|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/gc_interface/gcCause.hpp#l38" target="_blank">/hotspot/src/share/vm/gc_interface/gcCause.hpp#l38</a>|
|【字节码】Class文件解析|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/classfile/classFileParser.cpp#l3701" target="_blank">/hotspot/src/share/vm/classfile/classFileParser.cpp#l3701</a>|
|【JNI】符号大全|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/make/mapfiles/libnet/mapfile-vers#l29" target="_blank">/jdk/make/mapfiles/libnet/mapfile-vers#l29</a>|
|【JNI】符号表table赋值|<a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/thread.hpp#l988" target="_blank">/hotspot/src/share/vm/runtime/thread.hpp#l988</a>|

# Ubuntu

## 安装make3.81

下载源码地址：https://ftp.gnu.org/gnu/make/

```bash
tar -zxvf make-3.81.tar.gz
vim make-3.81/glob/glob.c
```

添加： #define __alloca alloca

``` c++
#define __alloca alloca //添加的代码
#if defined _AIX && !defined __GNUC__
 	#pragma alloca
#endif
```

执行

```bash
$ ./configure --prefix=/usr
$ sudo make
$ sudo make install
```

## 安装gcc和g++

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

## 下载jdk

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

## 编译环境 jdk下载

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

## 需要的依赖

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

## 编译配置文件生成和开始编译

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

## 踩坑1、系统版本不支持

```shell
# 修改该文件
vim hotspot/make/linux/Makefile
# 查找如下的字段，添加5%（表示支持gnu5版本）
SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4% 5%
```

## 踩坑2、jdk环境设置7

```shell
# 修改该文件
vim hotspot/make/linux/makefiles/rules.make
# 设置编译jdk的版本，也就是自己安装的jdk版本（一般是当前被编译的jdk前一个版本）
BOOT_SOURCE_LANGUAGE_VERSION = 7
```

## 踩坑3、忽略告警

```shell
# 修改该文件
vim hotspot/make/linux/makefiles/gcc.make
# 忽略c语言一些文件的告警
WARNINGS_ARE_ERRORS = -Werror
```

# MAC

## 克隆openJDK

GitHub:https://www.github.com/openjdk

## 安装jdk环境

下载地址：[orcale](https://www.oracle.com/java/technologies/downloads/)

## 安装编译环境需要的工具

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
$ vim ~/.zshrc
# 设定语言选项，必须设置
export LANG=C
# Mac平台，C编译器不再是GCC，是clang
export CC=clang
# 跳过clang的一些严格的语法检查，不然会将N多的警告作为Error
export COMPILER_WARNINGS_FATAL=false
# 链接时使用的参数
export LFLAGS='-Xlinker -lstdc++'
# 是否使用clang
export USE_CLANG=true
# 使用64位数据模型
export LP64=1
# 告诉编译平台是64位，不然会按32位来编译
export ARCH_DATA_MODEL=64
# 允许自动下载依赖
export ALLOW_DOWNLOADS=true
# 并行编译的线程数，编译时间长，为了不影响其他工作，我选择为2
export HOTSPOT_BUILD_JOBS=2
# 是否跳过与先前版本的比较
export SKIP_COMPARE_IMAGES=true
# 是否使用预编译头文件，加快编译速度
export USE_PRECOMPILED_HEADER=true
# 是否使用增量编译
export INCREMENTAL_BUILD=true
# 编译内容
export BUILD_LANGTOOLS=true
export BUILD_JAXP=true
export BUILD_JAXWS=true
export BUILD_CORBA=true
export BUILD_HOTSPOT=true
export BUILD_JDK=true
# 编译版本
export SKIP_DEBUG_BUILD=true
export SKIP_FASTDEBUG_BUILD=false
export DEBUG_NAME=debug
# 避开javaws和浏览器Java插件之类的部分的build
export BUILD_DEPLOY=false
export BUILD_INSTALL=false
# 最后干掉这两个变量,不然会有诡异的事发生
unset JAVA_HOME
unset CLASSPATH
```

```shell
$ source ~/.zshrc
$ cd ~/openjdk
# 检查编译
$ sh configure
# 开始编译，可以冲杯咖啡等待一会
$ make all
```

## 检查编译环境，出现下面界面表示成功

![image-20220305013306372](https://s2.loli.net/2022/03/05/Km1wpYTudMz4X5k.png)

# windows
[windows教程](https://cloud.tencent.com/developer/article/1047890)
## cygwin
![image.png](https://s2.loli.net/2023/05/17/BmM8YXafeo2rPnz.png)
![image.png](https://s2.loli.net/2023/05/17/vRf6udY72IycXVJ.png)
## 1、使用vs2010英文版（一定要是英文版）
https://freetype.org/ 

freetype 2.71
选择64位编译，lib和dll都需要编译，将编译结果输出到项目根目录中lib文件夹中
## 2、修改下面两个文件
- common\autoconf\generated-configure.sh
```shell
    if test "x$OPENJDK_TARGET_CPU" = "xx86"; then
      if test "x$COMPILER_CPU_TEST" != "x80x86"; then
        as_fn_error $? "Target CPU mismatch. We are building for $OPENJDK_TARGET_CPU but CL is for \"$COMPILER_CPU_TEST\"; expected \"80x86\"." "$LINENO" 5
      fi
    elif test "x$OPENJDK_TARGET_CPU" = "xx86_64"; then
      if test "x$COMPILER_CPU_TEST" != "xx64"; then
        as_fn_error $? "Target CPU mismatch. We are building for $OPENJDK_TARGET_CPU but CL is for \"$COMPILER_CPU_TEST\"; expected \"x64\"." "$LINENO" 5
      fi
    fi
    
    # 位置为21936-21944
    if test "x$OPENJDK_TARGET_CPU" = "xx86"; then
      if test "x$COMPILER_CPU_TEST" != "x80x86"; then
        as_fn_error $? "Target CPU mismatch. We are building for $OPENJDK_TARGET_CPU but CL is for \"$COMPILER_CPU_TEST\"; expected \"80x86\"." "$LINENO" 5
      fi
    elif test "x$OPENJDK_TARGET_CPU" = "xx86_64"; then
      if test "x$COMPILER_CPU_TEST" != "xx64"; then
        as_fn_error $? "Target CPU mismatch. We are building for $OPENJDK_TARGET_CPU but CL is for \"$COMPILER_CPU_TEST\"; expected \"x64\"." "$LINENO" 5
      fi
    fi
```
- jdk\make\CreateJars.gmk
```shell
# 268行 和 282 使用vim 在class后面和$$前面的位置输入ctrl+V - ctrl+M
268 $(GREP) -e '\.class^M$$' $(IMAGES_OUTPUTDIR)/lib$(PROFILE)/_the.jars.contents > $@.tmp
269         ifneq ($(PROFILE), )
270           ifneq ($(strip $(RT_JAR_INCLUDE_TYPES)), )
271            # Add back classes from excluded packages (fixing the $ substitution in the process)
272             for type in $(subst \$$,\, $(RT_JAR_INCLUDE_TYPES)) ; do \
273               $(ECHO) $$type >> $@.tmp ; \
274             done
275           endif
276         endif
277         $(MV) $@.tmp $@
278
279 $(IMAGES_OUTPUTDIR)/lib$(PROFILE)/_the.resources.jar.contents: $(IMAGES_OUTPUTDIR)/lib$(PROFILE)/_the.jars.contents
280         $(MKDIR) -p $(@D)
281         $(RM) $@ $@.tmp
282         $(GREP) -v -e '\.class^M$$' \
283             -e '/_the\.*' -e '^_the\.*' -e '\\_the\.*' -e 'javac_state' \

```

## 3、配置JDK7和JDK8对应的JAVA_HOME环境变量，编译过程会用到，以及对应PATH路径（%JAVA_HOME%\bin和%JAVA_HOME%\lib)
例如：JAVA_HOME=C:\Program Files\Java\jdk1.8.0_321

PATH=%JAVA_HOME%\lib;%JAVA_HOME%\bin;%PATH%


## 4、编译命令
```bash
已编译通过命令
./configure --with-freetype=/cygdrive/c/freetype/ --with-target-bits=64 --enable-debug
已验证[jdk8u60不能使用--disable-zip-debug-info参数，使用不带--disable-zip-debug-info的命令，生成的调试符号信息需要自己解压。][原因](https://bugs.openjdk.org/browse/JDK-8251886)
$ bash ./configure --with-debug-level=slowdebug --enable-debug-symbols --disable-zip-debug-info --with-freetype=/cygdrive/c/freetype OBJCOPY=gobjcopy
$ make images CONF=linux-x86_64-normal-server-fastdebug compile-commands
```
