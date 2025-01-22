
# 1、一些概念
| 缩写 | 英文            | 中文     |
| ---- | --------------- | -------- |
| PE   | Physical Extend | 物理扩展 |
| PV   | Phisical Volume | 物理卷   |
| VG   | Volume Group    | 卷组     |
| LV   | Logical Volume  | 逻辑卷   |



# 2、扩容分区
```bash

# 查看当前磁盘和分区信息，如果有lvm字样需要使用lvm来管理磁盘，没有的话直接删除原有分区，创建更大的新分区。
➜  ~ lsblk

# 查看分区使用情况
➜  ~ df -h

# 使用fdisk查看分区信息
➜  ~ fdisk -l

# 创建分区
➜  ~ fdisk /dev/sdb
Command (m for help): n
Select (default p):<Enter>
Partition number (1-4, default 1):<Enter>
First sector (2048-4194303, default 2048):<Enter>
Last sector, +sectors or +size{K,M,G} (2048-4194303, default 4194303):+2G
Command (m for help): w

# 格式化分区
➜  ~ mkfs -t ext4 /dev/sdb1

# 可以直接删除当前分区创建一个更大分区，分区的开始位置需要和之前的保持一致
# 使用如下命令可以直接扩容硬盘，重新挂载后可以直接使用
➜  ~ e2fsck -f /dev/sdc1
➜  ~ resize2fs /dev/sdc1

# 创建物理卷
➜  ~ pvcreate /dev/sdb1
# 查看物理卷
➜  ~ pvscan
# 将物理卷分配到指定分组
➜  ~ vgextend centos /dev/sdb1
# 查看物理卷
➜  ~ pvscan

# 查看卷组
➜  ~ vgdisplay
# 查看逻辑卷
➜  ~ lvdisplay

# 指定大小增加LV
➜  ~ lvextend -L +1.9G /dev/centos/root

# 百分比增加LV
➜  ~ lvextend -l +100%FREE /dev/centos/root

# ext2/ext3/ext4使用如下命令扩容
➜  ~  resize2fs /dev/centos/root
# xfs文件系统使用如下命令扩容
➜  ~ xfs_growfs /dev/sdc2

# 检查文件系统
➜  ~ mount | grep root
/dev/mapper/centos-root on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)

# xfs扩容命令  
➜  ~ xfs_growfs /dev/centos/root

# 减小逻辑卷
➜  ~ lvreduce -L -2G /dev/centos/root

# 从卷组上移除物理卷
➜  ~ vgreduce centos /dev/sdb1

# 移除物理卷
➜  ~ pvremove /dev/sdb1
  Labels on physical volume "/dev/sdb1" successfully wiped.
# 删除分区
➜  ~ fdisk /dev/sdb

# 查看分区
➜  ~ lsblk
```
