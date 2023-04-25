[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=aierx)](https://github.com/anuraghazra/github-readme-stats)


windows设置代理
> ip地址: 124.221.118.223  
> @echo off \
> set http_proxy=http://127.0.0.1:10811 \
> set http_proxy=https://127.0.0.1:10811  \
> netsh winhttp set proxy localhost:10811 \
> set NO_AUTH_BOTO_CONFIG=C:\app\boto.cfg  \
> echo proxy
### windows sdk download
`https://developer.microsoft.com/en-us/windows/downloads/`



REG ADD HKEY_CLASSES_ROOT\*\shell\Vscode /d "open with code"
REG ADD HKEY_CLASSES_ROOT\*\shell\Vscode /v Icon /t REG_SZ /d "C:\Users\aleiw\AppData\Local\Programs\Microsoft VS Code\Code.exe"
REG ADD HKEY_CLASSES_ROOT\*\shell\Vscode\Command /d "C:\Users\aleiw\AppData\Local\Programs\Microsoft VS Code\Code.exe  \"%V\""

REG ADD HKEY_CLASSES_ROOT\Directory\shell\Vscode /d "open in code"
REG ADD HKEY_CLASSES_ROOT\Directory\shell\Vscode /v Icon /t REG_SZ /d "C:\Users\aleiw\AppData\Local\Programs\Microsoft VS Code\Code.exe"
REG ADD HKEY_CLASSES_ROOT\Directory\shell\Vscode\Command /d "C:\Users\aleiw\AppData\Local\Programs\Microsoft VS Code\Code.exe  \"%V\""


gn gen --ide=vs2019 --args="is_debug=true" out\x64_vs
ninja -C .\out\x64_vs
v8 ide编译
gn gen --ide=vs2022 --winsdk="10.0.20348.1" out/x64.vs2022 --args="is_debug = true is_component_build = true  target_cpu = \"x64\" proprietary_codecs = true"

ITerm2 快捷键 \
command + D 水平分屏 \
command + shift + D 垂直分屏 \
command + shift + i 同时输入 \
command + w 关闭 \
command + shift + w 全部关闭 \
command + option + 方向键 调整焦点 \
command + control + 方向键 调整大小


lsof -i:3306  查看端口占用 \
lsof -i:3306 | awk 'NR==1 {next} {print $2}'
kill -9 $(lsof -t -i :3306) 杀死端口

### 7、耗时分析
curl -X GET -w "\nl: %{time_namelookup}\nc: %{time_connect}\ns: %{time_starttransfer}\nt: %{time_total}\n" -o a.txt  "baidu.com"




#### mysql 段错误
https://blog.csdn.net/ly_qiu/article/details/108061454




#### 设置没有显示器
-Djava.awt.headless=true


#### mybatis热加载 实现
https://blog.csdn.net/lonelymanontheway/article/details/120203097



#### tdlr 快速显示工具用法
https://zhuanlan.zhihu.com/p/82649746



#### macos设置代理
`-setsecurewebproxy` `-setwebproxy` `-setsocksfirewallproxy`
alias s='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0    .1:7890 & networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 7890'
alias u='unset https_proxy http_proxy all_proxy & networksetup -setsocksfirewallproxystate "Wi-Fi" off'


#### linux设置代理
alias s="export http_proxy=http://192.168.31.177:10809; export https_proxy=$http_proxy; echo 'HTTP Proxy on';"
alias u="unset http_proxy; unset https_proxy; echo 'HTTP Proxy off';"
alias c=clear
