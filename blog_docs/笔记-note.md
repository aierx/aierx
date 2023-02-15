### 笔记

1、设置ttl，windows
```shell
netsh interface ipv4 set global defaultcurhoplimit=64
```
2、linux设置代理
```shell
alias s="export http_proxy=http://192.168.31.177:10809; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
alias u="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
alias c=clear

# wget
wget -e "https_proxy=http://127.0.0.1:10809" https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.1.tar.xz

#curl
curl --proxy http://127.0.0.1:10809 https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.1.tar.xz -o fileName
#curl配置文件
vim ~/.curlrc
proxy="http://127.0.0.1:10809"

# apt-get代理设置 编辑文件.apt_proxy
Acquire::http::proxy "http://192.168.31.177:10809/";
Acquire::ftp::proxy "ftp://192.168.31.177:10809/";
Acquire::https::proxy "https://192.168.31.177:10809/";
# .zshrc添加命令
alias aptp='apt-get -c /root/.apt_proxy'
# 加载.zshrc 之后使用aptp是使用代理下载文件
source .zshrc
```
3、windows下openjdk8u60编译命令
```bash
$ cd /cygdrive/c/Users/aleiwe/Desktop/framework/jdk8u60/
$ bash ./configure --with-debug-level=slowdebug --with-freetype=/cygdrive/c/freetype --disable-zip-debug-info
$ make images CONF=linux-x86_64-normal-server-fastdebug compile-commands
$ --with-freetype-include=/usr/include/freetype2 --with-freetype-lib=/usr/lib/x86_64-linux-gnu
```
4、查看符号表
```bash
# c _add 
# c++ ?add@@YAHHH@Z
objdump -t .\lib1\cmake-build-debug\add.lib
```
5、MSVC和visual studio对应关系
```
MSC 1.0      _MSC_VER == 100 
MSC 2.0      _MSC_VER == 200 
MSC 3.0      _MSC_VER == 300 
MSC 4.0      _MSC_VER == 400 
MSC 5.0      _MSC_VER == 500 
MSC 6.0      _MSC_VER == 600 
MSC 7.0      _MSC_VER == 700 
MSVC++ 1.0   _MSC_VER == 800 
MSVC++ 2.0   _MSC_VER == 900 
MSVC++ 4.0   _MSC_VER == 1000 (Developer Studio 4.0) 
MSVC++ 4.2   _MSC_VER == 1020 (Developer Studio 4.2) 
MSVC++ 5.0   _MSC_VER == 1100 (Visual Studio 97 version 5.0) 
MSVC++ 6.0   _MSC_VER == 1200 (Visual Studio 6.0 version 6.0) 
MSVC++ 7.0   _MSC_VER == 1300 (Visual Studio .NET 2002 version 7.0) 
MSVC++ 7.1   _MSC_VER == 1310 (Visual Studio .NET 2003 version 7.1) 
MSVC++ 8.0   _MSC_VER == 1400 (Visual Studio 2005 version 8.0) 
MSVC++ 9.0   _MSC_VER == 1500 (Visual Studio 2008 version 9.0) 
MSVC++ 10.0  _MSC_VER == 1600 (Visual Studio 2010 version 10.0) 
MSVC++ 11.0  _MSC_VER == 1700 (Visual Studio 2012 version 11.0) 
MSVC++ 12.0  _MSC_VER == 1800 (Visual Studio 2013 version 12.0) 
MSVC++ 14.0  _MSC_VER == 1900 (Visual Studio 2015 version 14.0) 
MSVC++ 14.1  _MSC_VER == 1910 (Visual Studio 2017 version 15.0) 
MSVC++ 14.11 _MSC_VER == 1911 (Visual Studio 2017 version 15.3) 
MSVC++ 14.12 _MSC_VER == 1912 (Visual Studio 2017 version 15.5) 
MSVC++ 14.13 _MSC_VER == 1913 (Visual Studio 2017 version 15.6) 
MSVC++ 14.14 _MSC_VER == 1914 (Visual Studio 2017 version 15.7) 
MSVC++ 14.15 _MSC_VER == 1915 (Visual Studio 2017 version 15.8) 
MSVC++ 14.16 _MSC_VER == 1916 (Visual Studio 2017 version 15.9) 
MSVC++ 14.2  _MSC_VER == 1920 (Visual Studio 2019 Version 16.0) 
MSVC++ 14.21 _MSC_VER == 1921 (Visual Studio 2019 Version 16.1) 
MSVC++ 14.22 _MSC_VER == 1922 (Visual Studio 2019 Version 16.2)

```
6、windows开启远程访问
```bash
# 1.设置远程桌面端口（可以不用输，直接第二步，默认开启3389）
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /t REG_DWORD /v portnumber /d 3389 /f

# 2.开启远程桌面
wmic RDTOGGLE WHERE ServerName='%COMPUTERNAME%' call SetAllowTSConnections 1

#检查端口状态
netstat -an|find "3389"

#关闭远程桌面
wmic RDTOGGLE WHERE ServerName='%COMPUTERNAME%' call SetAllowTSConnections 0
```