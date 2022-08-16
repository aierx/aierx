# JDK源码编译

> 参考文档：[写Java这么久，JDK源码编译过没？编译JDK源码踩坑纪实](https://blog.csdn.net/wangshuaiwsws95/article/details/107375724/)

### 1、克隆openJDK

GitHub:https://www.github.com/openjdk

### 2、安装jdk环境

下载地址：[orcale](https://www.oracle.com/java/technologies/downloads/)

### 3、安装编译环境需要的工具

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

### 检查编译环境，出现下面界面表示成功

![image-20220305013306372](https://s2.loli.net/2022/03/05/Km1wpYTudMz4X5k.png)

至此，jdk源码编译完成，就是可以好好的学习jvm相关的知识了。