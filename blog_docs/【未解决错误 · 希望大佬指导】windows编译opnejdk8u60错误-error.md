![error](http://aierx.icu/upload/2022/06/error-b03f2096710f4af59d97cf17887339ea.png)
开启--disable-zip-debug-info选项会有如上图错误

- 编译版本：openjdk8u60
- 系统版本：windows 21H2 19044.1645
- cygwin: 2.918
- make: 4.3-1
- zip：3.0-12
- uzip：6.0-17
- 编译工具链：VisualStudio 2010
- bootjdk：jdk1.8.0_321
- 编译选项：bash ./configure --with-debug-level=slowdebug --with-freetype=/cygdrive/c/freetype --disable-zip-debug-info
```bash
C:\Users\aleiwe\scoop\apps\cygwin\2.918\root\bin\make.exe jdk CONF=windows-x86_64-normal-server-slowdebug
Building 'windows-x86_64-normal-server-slowdebug' (matching CONF=windows-x86_64-normal-server-slowdebug)
Building OpenJDK for target 'jdk' in configuration 'windows-x86_64-normal-server-slowdebug'

## Starting langtools
## Finished langtools (build time 00:00:01)

## Starting hotspot
## Finished hotspot (build time 00:00:00)

## Starting corba
## Finished corba (build time 00:00:02)

## Starting jaxp
## Finished jaxp (build time 00:00:00)

## Starting jaxws
## Finished jaxws (build time 00:00:02)

## Starting jdk
make[2]: Circular /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.map <- /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.map dependency dropped.
make[2]: Circular /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.pdb <- /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.map dependency dropped.
make[2]: Circular /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.pdb <- /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.pdb dependency dropped.
CRC32.obj : warning LNK4197: 多次指定导出“ZIP_CRC32”；使用第一个规范
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libzip/zip.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libzip/zip.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libunpack/unpack.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libunpack/unpack.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libnet/net.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libnet/net.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjaas/jaas_nt.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjaas/jaas_nt.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libattach/attach.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libattach/attach.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libawt/awt.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libawt/awt.exp
socketTransport.obj : warning LNK4197: 多次指定导出“jdwpTransport_OnLoad”；使用第一个规范
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libdt_socket/dt_socket.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libdt_socket/dt_socket.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjdwp/jdwp.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjdwp/jdwp.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsdt/jsdt.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsdt/jsdt.exp
InvocationAdapter.obj : warning LNK4197: 多次指定导出“Agent_OnAttach”；使用第一个规范
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libinstrument/instrument.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libinstrument/instrument.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libmanagement/management.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libmanagement/management.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libmlib_image/mlib_image.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libmlib_image/mlib_image.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjpeg/jpeg.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjpeg/jpeg.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsound/jsound.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsound/jsound.exp
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsoundds/jsoundds.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libjsoundds/jsoundds.exp
Copying unpack.pdb
/usr/bin/cp: cannot stat '/cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.pdb': No such file or directory
make[2]: *** [lib/CoreLibraries.gmk:323: /cygdrive/c/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/bin/unpack.pdb] Error 1
make[2]: *** Waiting for unfinished jobs....
   正在创建库 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libnio/nio.lib 和对象 c:/jdk8u60/build/windows-x86_64-normal-server-slowdebug/jdk/objs/libnio/nio.exp
make[1]: *** [BuildJdk.gmk:70: libs-only] Error 2
make: *** [/cygdrive/c/jdk8u60//make/Main.gmk:116: jdk-only] Error 2

Process finished with exit code 2
```
[JVM相关帖子](https://www.iteye.com/blog/rednaxelafx-362738)