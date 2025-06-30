
Macos软件推荐
| 名称               | 简介                                                | 下载地址                                           |
| ------------------ | --------------------------------------------------- | -------------------------------------------------- |
| Mos                | 单独修改鼠标滚动方向                                | https://mos.caldis.me/                             |
| Maccy              | 剪贴板历史                                          | https://maccy.app/ https://github.com/p0deje/Maccy |
| Magnet             | 分屏功能                                            | https://magnet.crowdcafe.com/                      |
| Lemon              | 清理工具                                            | https://lemon.qq.com/                              |
| AltTab             | 切屏工具                                            | https://alt-tab-macos.netlify.app/                 |
| OwlOCR             | OCR工具                                             | https://owlocr.com/                                |
| Charles            | http抓包工具、处理工具                              | https://www.charlesproxy.com/                      |
| wireshark          | 底层网络抓包工具，多种协议：TCP、UCP、ARP、ICMP等等 | https://www.wireshark.org/                         |
| fiddler-everything | fiddler的mac版本                                    | https://www.telerik.com/fiddler/fiddler-everywhere |
| tldr               | 显示常用剪短命令行                                  | https://tldr.sh/                                   |
| mitmproxy          | python的一种代理拦截工具                            | https://mitmproxy.org/                             |
| Snipaste           | 截图贴图工具                                        | https://www.snipaste.com/                          |
| Beyond Compare     | 强大的文本比较工具                                  | https://www.scootersoftware.com/                   |
| clashx             | 代理工具                                            | https://github.com/yichengchen/clashX              |
| brew               | macos软件安装工具                                   | https://brew.sh/                                   |
| utools             | 强大的插件工具（推荐模块Json和markdown）            | https://www.u.tools/                               |
| dbeaver            | 数据库工具                                          | https://dbeaver.io/                                |
| imhex              | 二进制文件查看工具                                  | https://imhex.werwolv.net/                         |
| Karabiner-Elements | 按键映射                                            | https://karabiner-elements.pqrs.org/               |
| scrcpy             | 安卓手机投屏软件                                    | https://github.com/Genymobile/scrcpy               |
| fig                | 命令行提示工具                                      | https://fig.io/                                    |
| conntrack          | 抓包工具                                            |                                                    |
| Alacritty          | 终端工具（跨平台）                                  | https://alacritty.org/                             |
| iterm2             | 终端工具                                            | https://iterm2.com/                                |
| viu                | 终端图片查看｜                                      | https://github.com/atanunq/viu                     |


# 工具下载
> [Python](https://www.python.org)

> [Rufus](https://rufus.ie)

> [OpenCore](https://dortania.github.io/OpenCore-Install-Guide)

> [opencore核心包下载](https://github.com/acidanthera/OpenCorePkg/releases)

> [各种机型EFI下载](https://github.com/daliansky/Hackintosh)

> [ProperTree](https://github.com/corpnewt/ProperTree)

> [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)

> [OpenCore Configurator](https://mackie100projects.altervista.org/opencore-configurator/)

# 下载苹果恢复系统

> 1. 下载opencore核心工具包  
> 2. cd /Utilities/macrecovery/  
> 3. 执行以下命令下载对应系统

```sh
    # Lion (10.7):
    python macrecovery.py -b Mac-2E6FAB96566FE58C -m 00000000000F25Y00 download
    python macrecovery.py -b Mac-C3EC7CD22292981F -m 00000000000F0HM00 download
    
    # Mountain Lion (10.8):
    python macrecovery.py -b Mac-7DF2A3B5E5D671ED -m 00000000000F65100 download
    
    # Mavericks (10.9):
    python macrecovery.py -b Mac-F60DEB81FF30ACF6 -m 00000000000FNN100 download
    
    # Yosemite (10.10):
    python macrecovery.py -b Mac-E43C1C25D4880AD6 -m 00000000000GDVW00 download
    
    # El Capitan (10.11):
    python macrecovery.py -b Mac-FFE5EF870D7BA81A -m 00000000000GQRX00 download
    
    # Sierra (10.12):
    python macrecovery.py -b Mac-77F17D7DA9285301 -m 00000000000J0DX00 download
    
    # High Sierra (10.13)
    python macrecovery.py -b Mac-7BA5B2D9E42DDD94 -m 00000000000J80300 download
    python macrecovery.py -b Mac-BE088AF8C5EB4FA2 -m 00000000000J80300 download
    
    # Mojave (10.14)
    python macrecovery.py -b Mac-7BA5B2DFE22DDD8C -m 00000000000KXPG00 download
    
    # Catalina (10.15)
    python macrecovery.py -b Mac-00BE6ED71E35EB86 -m 00000000000000000 download
    
    # Big Sur (11)
    python macrecovery.py -b Mac-42FD25EABCABB274 -m 00000000000000000 download
    
    # Latest version
    # ie. Monterey (12)
    python ./macrecovery.py -b Mac-E43C1C25D4880AD6 -m 00000000000000000 download
```
