### 下载到本地
``` shell
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.6.tar.xz
```
### 传到虚拟机
``` shell
scp C:\Users\aleiwe\Downloads\linux-5.9.6.tar.xz ubuntu://root/
```
### 解压
``` shell
tar -xvf /root/linux-5.9.6.tar.xz
```
### 生成配置文件
``` shell
make mrproper
make menuconfig
```
### 将.config中的CONFIG_SYSTEM_TRUSTED_KEYS设置为空
``` shell
CONFIG_SYSTEM_TRUSTED_KEYS=""
```
### 编译使用8个线程
``` shell
make -j8
```
### 硬盘空间不足 VM扩容
``` shell
make clean
sudo apt-get install gparted
```