> [写Java这么久，JDK源码编译过没？编译JDK源码踩坑纪实](https://blog.csdn.net/wangshuaiwsws95/article/details/107375724/) \
> [一起来编译JDK吧！:)](https://blog.csdn.net/qq_39749527/article/details/107709708) \
> 推荐书籍：`Java虚拟机规范`、`深入理解JVM字节码`、`HotSpot实战`、`深入理解Java虚拟机`、`深入理解linux内核`、`深入理解操作系统`、`算法导论`

# 起步

- cross platform tools
  - clion
  - compiledb
  - mercurial
  - autoconfig
  - make
- dependence
  - freetype 2.7D
- windows
  - cygwin
  - visual studio 2010
- macos
  - xcode 4.6.1 [下载地址](https://developer.apple.com/download/all)
- ubuntu 18.04
  - make 3.81
  - gcc 4.x
- centos7
  - gcc 4.x
  - gdb 8.x

# ubuntu 18.04

## make 3.81

```bash
wget https://mirrors.huaweicloud.com/gnu/make/make-3.81.tar.gz
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
cd make-3.81
./configure --prefix=/usr
sudo make & sudo make install
```

## gcc

```shell
# 安装指定版本gcc和g++
sudo apt-get install gcc-4.8 g++-4.8 -y
ls /usr/bin/gcc*
# 添加版本 优先级，数字越大优先级越高。
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 90
sudo update-alternatives --config gcc

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 90
sudo update-alternatives --config g++
```

## dependence

```shell
sudo apt install unzip zip
sudo apt install build-essential
sudo apt install openjdk-8-jdk
sudo apt-get install libx11-dev libxext-dev libxrender-dev libxtst-dev libxt-dev
sudo apt-get install libcups2-dev
sudo apt-get install libfreetype6-dev
sudo apt-get install libasound2-dev
sudo apt-get install autoconf
```

## jdk

```shell
sudo apt-get install mercurial
hg clone https://hg.openjdk.java.net/jdk8u/jdk8u60/
cd jdk8u60/
chmod +x get_source.sh
./get_source.sh
```

## modify the following code

版本问题

```shell
# 修改该文件
vim hotspot/make/linux/Makefile
# 查找如下的字段，添加5%（表示支持gnu5版本）
SUPPORTED_OS_VERSION = 2.4% 2.5% 2.6% 3% 4% 5%
```

告警

```shell
# 修改该文件
vim hotspot/make/linux/makefiles/gcc.make
# 注释以下代码
WARNINGS_ARE_ERRORS = -Werror
```

时间限制报错

```shell
vim jdk/make/src/classes/build/tools/generatecurrencydata/GenerateCurrencyData.java
# 原先是10年，改成100年就好了
if (Math.abs(time - System.currentTimeMillis()) > ((long) 100) * 365 * 24 * 60 * 60 * 1000) 
```

## compiledb

```shell
sudo apt install python-pip -y
pip install compiledb

```

## 编译

```shell
# 配置编译文件
bash configure --with-debug-level=slowdebug --with-jvm-variants=server
# 开始编译; 如果compiledb找不到，重新打开一下zsh
compiledb make
```

- `--with-debug-level=slowdebug`用来设置编译的级别，可选值：`release`、`fastdebug`、`slowde-bug`
- `with-jvm-variants` 编译特定模式的HotSpot虚拟机，可选值：`server`、`client`、`minimal`、`core`、`zero`、`custom`

# macos

## openJDK

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

# windows 10
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


# jdk模式
- 混合模式  -Xmixed           mixed mode execution (default)
- 解释模式  -Xint             interpreted mode execution only
- 编译模式  -Xcomp            compiled mode execution only

# jvm参数
| 参数                                  | 含义                                                                          |
| ------------------------------------- | ----------------------------------------------------------------------------- |
| -XX:+PrintGC                          | 打印GC                                                                        |
| -XX:+PrintGCDetails                   | 打印详细GC                                                                    |
| -XX:+PrintHeapAtGC                    | 每次GC打印堆信息                                                              |
| -XX:+PrintGCTimeStamps                | 每次打印GC日志的时候，还要输出时间信息(系统启动后的时间)。                    |
| -XX:+PrintGCApplicationConcurrentTime | 打印应用程序的执行时间(到达安全点safepoint的时间)，一般是跟下面的参数一起使用 |
| -XX:+PrintGCApplicationStoppedTime    | 打印应用程序因为GC停顿的时间(stw机制）                                        |
| -XX:+PrintReferenceGC                 | 打印引用相关的GC。这个可以跟踪系统内的软引用、弱引用、虚引用和Finallize队列。 |
| -Xloggc:log/gc.log                    |                                                                               |
| -Xms10m                               | 最小堆                                                                        |
| -Xmx20m                               | 最大堆                                                                        |
| -Xmn3m                                | 新生代                                                                        |
| -XX:SurvivorRatio=2                   | eden/from=2                                                                   |
| -XX:NewRatio=3                        | 老年代/新生代=3                                                               |
| -XX:+PrintCommandLineFlags            | 打印垃圾回收器                                                                |
| -XX:+PrintFlagsWithComments           | 打印所有参数                                                                  |
| -XX:+NativeMemoryTracking             | 内存跟踪                                                                      |
| -XX:+TraceClassLoading                | 类加载                                                                        |
| -XX:+TraceClassUnloading              | 类卸载                                                                        |
| -XX:+TraceClassLoadingPreorder        |                                                                               |
| -XX:+Verbose                          |                                                                               |
| -XX:+PrintGC                          |                                                                               |
| -XX:+ShowSafepointMsgs                |                                                                               |
| -XX:+PrintCFGToFile                   |                                                                               |
| -XX:+PrintAssembly                    |                                                                               |
| -XX:+UseSerialGC                      |                                                                               |
| _JAVA_LAUNCHER_DEBUG=1                | 环境变量，开启debug模式                                                       |

# Openjdk8u 源码位置导航
| 名称                            | 位置                                                                                                                                                                                                         |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 【锁】轻量级锁                  | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/synchronizer.cpp#l226" target="_blank">/hotspot/src/share/vm/runtime/synchronizer.cpp#l226</a>             |
| 【GC】垃圾回收                  | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/memory/genCollectedHeap.cpp#l357" target="_blank">/hotspot/src/share/vm/memory/genCollectedHeap.cpp#l357</a>       |
| 【win线程】调用系统方法创建线程 | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l596" target="_blank">/hotspot/src/os/windows/vm/os_windows.cpp#l596</a>                       |
| 【win线程】创建线程             | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/os/windows/vm/os_windows.cpp#l528" target="_blank">/hotspot/src/os/windows/vm/os_windows.cpp#l528</a>                       |
| 【win线程】符号导出             | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/native/java/lang/Thread.c#l43" target="_blank">/jdk/src/share/native/java/lang/Thread.c#l43</a>                           |
| 【win网络】write0               | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketOutputStream.c#l60" target="_blank">/jdk/src/windows/native/java/net/SocketOutputStream.c#l60</a> |
| 【win网络】read0                | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/windows/native/java/net/SocketInputStream.c#l61" target="_blank">/jdk/src/windows/native/java/net/SocketInputStream.c#l61</a>   |
| 【JDK】调用main函数             | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l477" target="_blank">/jdk/src/share/bin/java.c#l477</a>                                                       |
| 【Hostpsot】一些服务初始化      | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/services/management.cpp#l83" target="_blank">/hotspot/src/share/vm/services/management.cpp#l83</a>                 |
| 【hostspot】创建vm虚拟机        | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/prims/jni.cpp#l5196" target="_blank">/hotspot/src/share/vm/prims/jni.cpp#l5196</a>                                 |
| 【hostspot】初始化vm虚拟机      | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l376" target="_blank">/jdk/src/share/bin/java.c#l376</a>                                                       |
| 【JDK】JavaMain                 | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/src/share/bin/java.c#l354" target="_blank">/jdk/src/share/bin/java.c#l354</a>                                                       |
| 【GC】GC原因                    | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/gc_interface/gcCause.hpp#l38" target="_blank">/hotspot/src/share/vm/gc_interface/gcCause.hpp#l38</a>               |
| 【字节码】Class文件解析         | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/classfile/classFileParser.cpp#l3701" target="_blank">/hotspot/src/share/vm/classfile/classFileParser.cpp#l3701</a> |
| 【JNI】符号大全                 | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/jdk/file/935758609767/make/mapfiles/libnet/mapfile-vers#l29" target="_blank">/jdk/make/mapfiles/libnet/mapfile-vers#l29</a>                               |
| 【JNI】符号表table赋值          | <a href="https://hg.openjdk.java.net/jdk8u/jdk8u60/hotspot/file/37240c1019fd/src/share/vm/runtime/thread.hpp#l988" target="_blank">/hotspot/src/share/vm/runtime/thread.hpp#l988</a>                         |

# jdk garbage collection

## yong generation
- ①、serial
- ②、ParNew
- ③、Parallel Scavenge

## tenured genertion
- ④、CMS
- ⑤、Serial Old（MSC）
- ⑥、Parallel Old

##  组合
![组合模式](https://s2.loli.net/2023/05/25/E1kShr7PD2iqY6y.png)

java -XX:+UseSerialGC -XX:+PrintGCDetails -version （①和⑤）

java -XX:+UseParNewGC -XX:+PrintGCDetails -version （②和⑤）

java -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:+PrintGCDetails -version  （③和⑥、jdk8默认是开启的. -XX:+UseParallelGC -XX:+UseParallelOldGC使用一个，另外一个也会生效）

java -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -version （ParNew + CMS + Serial Old收集器组合进行回收，Serial Old收集器将作为CMS收集器出现“Concurrent Mode Failure“失败后的后备收集器使用）

java -XX:+UseG1GC -XX:+PrintGCDetails -version

# jpda

- java -agentlib:jdwp=help version （推荐）
- java -Xrunjdwp:help version
- -agentlib:jdwp=transport=dt_socket,server=y,address=8000 （开启）
- jdb -connect com.sun.jdi.SocketAttach:hostname=localhost,port=8000 (连接）
- 
## 可选参数
```
               Java Debugger JDWP Agent Library
               --------------------------------

  (see http://java.sun.com/products/jpda for more information)

jdwp usage: java -agentlib:jdwp=[help]|[<option>=<value>, ...]

Option Name and Value            Description                       Default
---------------------            -----------                       -------
suspend=y|n                      wait on startup?                  y
transport=<name>                 transport spec                    none
address=<listen/attach address>  transport spec                    ""
server=y|n                       listen for debugger?              n
launch=<command line>            run debugger on event             none
onthrow=<exception name>         debug on throw                    none
onuncaught=y|n                   debug on any uncaught?            n
timeout=<timeout value>          for listen/attach in milliseconds n
mutf8=y|n                        output modified utf-8             n
quiet=y|n
```