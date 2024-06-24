# pdb文件包含源代码

打开项目配置

![](https://raw.githubusercontent.com/aierx/images/master/Snipaste_2024-06-25_07-02-36.png)

选择 Program Database for Edit And Continue

![](https://raw.githubusercontent.com/aierx/images/master/20240625070448.png)


# 使用symstore生成符号服务器所需要的文件

```
# 指定路径下不要包含其他文件
$ symstore add /o /r /f C:\Users\aleiwe\Desktop\ccc\build\Debug\http.pdb /s C:\symstore /t aaaa /v 1.0 /c init
```

/r 递归搜索/f所指定的目录中的所有文件

/f 需要查找pdb文件的目录，按照标准文件名通配方式

/s 符号服务器目录

/t 产品名称，此名称会出现在history.txt中

/v 产品版本，可以通过该版本来建立同源码库的联系（调试的时候你总得看源代码吧，用这个版本号去检索你的源码库，找到合适的源码），此名称会出现在history.txt中

/c 注释，爱写啥写啥，此名称也是会出现在history.txt中