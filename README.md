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


[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=aierx)](https://github.com/anuraghazra/github-readme-stats)

gn gen --ide=vs2019 --args="is_debug=true" out\x64_vs
ninja -C .\out\x64_vs

ITerm2 快捷键 \
command + D 水平分屏 \
command + shift + D 垂直分屏 \
command + shift + i 同时输入 \
command + w 关闭 \
command + shift + w 全部关闭 \
command + option + 方向键 调整焦点 \
command + control + 方向键 调整大小


lsof -i:3306  查看端口占用

