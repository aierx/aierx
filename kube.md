


文档1【代理配置】： https://blog.csdn.net/vic_qxz/article/details/130061661 \
安装笔记：https://blog.hungtcs.top/2019/11/27/23-K8S%E5%AE%89%E8%A3%85%E8%BF%87%E7%A8%8B%E7%AC%94%E8%AE%B0/ \
视频：https://www.bilibili.com/video/BV1oJ411d7Tv/?spm_id_from=333.999.0.0&vd_source=21e5cf543ff14f76876c79bf5a6a1984 \
网络插件：https://github.com/flannel-io/flannel \

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

对应docker版本  docker 18.09


```shell
vim /etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=http://192.168.3.133:10811/"
Environment="HTTPS_PROXY=http://192.168.3.133:10811/" 
```
sudo systemctl daemon-reload \
sudo service docker restart \
查看docker信息
docker info \
