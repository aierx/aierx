```bash
# 拉取gitlab-ce
$ docker pull gitla/gitlab-ce:rc
# 运行gitlab-ce
$ docker run -d --name gitlab --hostname gitlab --restart always  -p 4443:443 -p 8888:80 -p 2222:22 -v /data/docker/gitlab/config:/etc/gitlab -v /data/docker/gitlab/data:/var/opt/gitlab -v /data/docker/gitlab/logs:/var/log/gitlab gitlab/gitlab-ce:rc

#修改密码
$ docker exec -it gitlab bash
$ vi

#拉取运行gitlab-runner
$ docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest

$ docker exec -it gitlab-runner bash


```



JDK

```bash
$ bash ./configure --with-debug-level=slowdebug --with-native-debug-symbols=internal --with-target-bits=64
```



代理

```bash
# 设置代理如下操作
$ git config --global http.proxy http://127.0.0.1:7890
$ git config --global https.proxy http://127.0.0.1:7890
$ netsh winhttp set proxy 127.0.0.1:7890
$ set HTTP_PROXY=http://127.0.0.1:7890 
$ set HTTPS_PROXY=http://127.0.0.1:7890 

# 取消代理如下操作
$ git config --global --unset http.proxy
$ git config --global --unset https.proxy
$ netsh winhttp reset proxy
$ set HTTP_PROXY=
$ set HTTPS_PROXY=
```

V8编译 `https://zhuanlan.zhihu.com/p/584305240`

```bash
# 直接编译
tools/dev/gm.py x64.release
# 生成VS项目
gn gen --ide=vs2022 out/vs
```

tldr





[Windows字符集的统一与转换 (bbsmax.com)](https://www.bbsmax.com/A/rV57EaGVzP/)

**定义一个MBCS字符数组：char arr[LEN];或者CHAR arr[LEN];**

**定义一个MBCS字符指针：char \*p;或者LPSTR p;**

**定义一个MBCS常量字符串指针：const char \* cp;或者LPCSTR cp;**

**定义一个MBCS常量字符串：cp=”Hello World!\n”;**

如果使用Unicode字符集一般这么写：

**定义一个Unicode字符数组：wchar_t arr[LEN];或者WCHAR arr[LEN];**

**定义一个Unicode字符指针：wchar_t \*p;或者LPWSTR p;**

**定义一个Unicode常量字符串指针：const wchar_t \* cp;或者LPCWSTR cp;**

**定义一个Unicode常量字符串：cp=L”Hello World!\n”;**

一般字符集和串操作离不开。

如果对MBCS字符串连接、复制、比较、求长运算为：strcat、strcpy、strcmp、strlen。

如果对Unicode字符串连接、复制、比较、求长运算为：wcscat、wcscpy、wcscmp、wcslen。





对于相应的字符集定义和串操作如下：

**定义一个字符数组：TCHAR arr[LEN];**

**定义一个字符指针：LPTSTR p;**

**定义一个常量字符串指针：LPCTSTR cp;**

**定义一个常量字符串：cp=_T(”Hello World!\n”);**

**连接、复制、比较、求长运算为：_tcscat、_tcscpy、_tcscmp、_tcslen。**

这里的TCHAR不是一个新的类型，它是根据UNICODE宏来自动映射为char和wchar_t，相应的LPTSTR、LPCTSTR、_T()宏亦是如此。

将上述的宏定义抽象出来如下：

```c++
#ifdef UNICODE
    typedef wchar_t WACHR,TCHAR;
    typedef wchar_t *LPWSTR,*LPTSTR;
    typedef const wchar_t *LPCWSTR,*LPCTSTR;
    #define _T(x) L ## x
    #define _tcscat wcscat
    #define _tcscpy wcscpy
    #define _tcscmp wcscmp
    #define _tcslen wcslen#
else
    typedef char CHAR,TCHAR;
    typedef char *LPSTR,*LPTSTR;
	typedef const char *LPCSTR,*LPCTSTR;
	#define _T(x) x
	#define _tcscat strcat
	#define _tcscpy strcpy
	#define _tcscmp strcmp
	#define _tcslen strlen
#endif 
```

因此，使用TCHAR代替已有的字符、串定义、操作可以完成字符集处理的统一和通用化。
