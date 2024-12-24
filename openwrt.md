
>[X86小主机，安装无线网卡，OpenWrt官方固件，开启wifi功能](https://www.cnblogs.com/Magiclala/p/18426766)

1、配置无线，确保每次重启时，无线没有被禁用

root@OpenWrt:~# vim /etc/config/wireless

在已经配置好的无线配置里，添加这一行option disabled '0'

```
config wifi-device 'radio0'
	option type 'mac80211'
	option path 'pci0000:00/0000:00:1c.2/0000:03:00.0'
	option band '5g'
	option htmode 'HE80'
	option country 'CN'
	option cell_density '3'
	option channel '157'
	option txpower '6'
	option disabled '0'  # 添加这一行
```
2、延迟无线网卡的启动

chartGPT告诉我，在/etc/rc.local这个配置文件中增加10s的sleep，就能推迟启动了，我配置后，再重启果然正常了。

root@OpenWrt:~# vim /etc/rc.local
```
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

(sleep 10; wifi) &

exit 0
```

root@OpenWrt:~#