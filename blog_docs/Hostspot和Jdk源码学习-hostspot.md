### `那一年我以为有一个女孩会在夏天的尽头等我，后来我知道，夏天的尽头是秋天。`
### 一、起步
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
windows参考文档[暂时还没编写]：http://aierx.icu/archives/error
linux参考文档ubuntu：http://aierx.icu/archives/ubuntu-jdk
macos参考文档：http://aierx.icu/archives/macos-jdk
推荐书籍：《Java虚拟机规范》、《深入理解JVM字节码》、《HotSpot实战》、《深入理解Java虚拟机》、《深入理解linux内核》、《深入理解操作系统》、《算法导论》

### 二、JVM常用参数
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

### 三、Openjdk8u 源码位置导航
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