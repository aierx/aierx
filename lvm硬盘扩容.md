
# 1、一些概念
| 缩写 | 英文            | 中文     |
| ---- | --------------- | -------- |
| PE   | Physical Extend | 物理扩展 |
| PV   | Phisical Volume | 物理卷   |
| VG   | Volume Group    | 卷组     |
| LV   | Logical Volume  | 逻辑卷   |



# 2、扩容分区
```bash
# 查看分区使用情况
➜  ~ df -h
Filesystem               Size  Used Avail Use% Mounted on
devtmpfs                 3.8G     0  3.8G   0% /dev
tmpfs                    3.9G     0  3.9G   0% /dev/shm
tmpfs                    3.9G   12M  3.8G   1% /run
tmpfs                    3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/mapper/centos-root   59G   15G   45G  26% /
/dev/sda1               1014M  194M  821M  20% /boot
tmpfs                    781M     0  781M   0% /run/user/0
# 查看当前磁盘和分区信息
➜  ~ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
├─sda2            8:2    0   19G  0 part
│ ├─centos-root 253:0    0   59G  0 lvm  /
│ └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
└─sda3            8:3    0   40G  0 part
  └─centos-root 253:0    0   59G  0 lvm  /
sdb               8:16   0    2G  0 disk
└─sdb1            8:17   0    2G  0 part
  └─centos-root 253:0    0   59G  0 lvm  /
sr0              11:0    1 1024M  0 rom
# 使用fdisk查看分区信息
➜  ~ fdisk -l

Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0xdddf018e

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4194303     2096128   83  Linux

Disk /dev/sda: 64.4 GB, 64424509440 bytes, 125829120 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0009eee2

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM
/dev/sda3        41943040   125829119    41943040   83  Linux

Disk /dev/mapper/centos-root: 63.3 GB, 63338184704 bytes, 123707392 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

# 创建分区
➜  ~ fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p):
Using default response p
Partition number (1-4, default 1):
First sector (2048-4194303, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-4194303, default 4194303):
Using default value 4194303
Partition 1 of type Linux and of size 2 GiB is set

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.

# 格式化分区
➜  ~ mkfs -t ext4 /dev/sdb1
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
131072 inodes, 524032 blocks
26201 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=536870912
16 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

# 创建物理卷
➜  ~ pvcreate /dev/sdb1
WARNING: ext4 signature detected on /dev/sdb1 at offset 1080. Wipe it? [y/n]: y
  Wiping ext4 signature on /dev/sdb1.
  Physical volume "/dev/sdb1" successfully created.
# 查看物理卷
➜  ~ pvscan
  PV /dev/sda2   VG centos          lvm2 [<19.00 GiB / 0    free]
  PV /dev/sda3   VG centos          lvm2 [<40.00 GiB / 0    free]
  PV /dev/sdb1                      lvm2 [<2.00 GiB]
  Total: 3 [60.99 GiB] / in use: 2 [58.99 GiB] / in no VG: 1 [<2.00 GiB]
# 将物理卷分配到指定分组
➜  ~ vgextend centos /dev/sdb1
  Volume group "centos" successfully extended
# 查看物理卷
➜  ~ pvscan
  PV /dev/sda2   VG centos          lvm2 [<19.00 GiB / 0    free]
  PV /dev/sda3   VG centos          lvm2 [<40.00 GiB / 0    free]
  PV /dev/sdb1   VG centos          lvm2 [<2.00 GiB / <2.00 GiB free]
  Total: 3 [<60.99 GiB] / in use: 3 [<60.99 GiB] / in no VG: 0 [0   ]
# 查看卷组
➜  ~ vgdisplay
  --- Volume group ---
  VG Name               centos
  System ID
  Format                lvm2
  Metadata Areas        3
  Metadata Sequence No  6
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                3
  Act PV                3
  VG Size               <60.99 GiB
  PE Size               4.00 MiB
  Total PE              15613
  Alloc PE / Size       15102 / 58.99 GiB
  Free  PE / Size       511 / <2.00 GiB
  VG UUID               mtLnaV-kUCY-kG0U-Dfp6-voxs-7KoR-cNOdRd
# 查看逻辑卷
➜  ~ lvdisplay
  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                0A8gBb-gkRh-rrfw-6eq4-42fT-sb2s-ZdASyO
  LV Write Access        read/write
  LV Creation host, time localhost, 2022-04-28 03:33:48 -0400
  LV Status              available
  # open                 2
  LV Size                2.00 GiB
  Current LE             512
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                SYHhLq-7gVR-cmLv-KkUm-cQZh-Ky6b-HdkyzO
  LV Write Access        read/write
  LV Creation host, time localhost, 2022-04-28 03:33:48 -0400
  LV Status              available
  # open                 1
  LV Size                56.99 GiB
  Current LE             14590
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0
# 指定大小增加LV
➜  ~ lvextend -L +1.9G /dev/centos/root
  Rounding size to boundary between physical extents: 1.90 GiB.
  Size of logical volume centos/root changed from 56.99 GiB (14590 extents) to 58.89 GiB (15077 extents).
  Logical volume centos/root successfully resized.
# 百分比增加LV
➜  ~ lvextend -l +100%FREE /dev/centos/root
  Size of logical volume centos/root changed from 58.89 GiB (15077 extents) to <58.99 GiB (15101 extents).
  Logical volume centos/root successfully resized.

➜  ~  resize2fs /dev/centos/root
resize2fs 1.42.9 (28-Dec-2013)
resize2fs: Bad magic number in super-block while trying to open /dev/centos/root
Couldn't find valid filesystem superblock.

# 检查文件系统
➜  ~ mount | grep root
/dev/mapper/centos-root on / type xfs (rw,relatime,seclabel,attr2,inode64,noquota)

# xfs扩容命令  
➜  ~ xfs_growfs /dev/centos/root
meta-data=/dev/mapper/centos-root isize=512    agcount=4, agsize=1113856 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=4455424, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 4455424 to 15463424
# 减小逻辑卷
➜  ~ lvreduce -L -2G /dev/centos/root
  WARNING: Reducing active and open logical volume to <54.99 GiB.
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce centos/root? [y/n]: y
  Size of logical volume centos/root changed from <56.99 GiB (14589 extents) to <54.99 GiB (14077 extents).
  Logical volume centos/root successfully resized.
# 从卷组上移除物理卷
➜  ~ vgreduce centos /dev/sdb1
  Removed "/dev/sdb1" from volume group "centos"
# 移除物理卷
➜  ~ pvremove /dev/sdb1
  Labels on physical volume "/dev/sdb1" successfully wiped.
# 删除分区
➜  ~ fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): d
No partition is defined yet!

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
# 查看分区
➜  ~ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   60G  0 disk
├─sda1            8:1    0    1G  0 part /boot
├─sda2            8:2    0   19G  0 part
│ ├─centos-root 253:0    0   55G  0 lvm  /
│ └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
└─sda3            8:3    0   40G  0 part
  └─centos-root 253:0    0   55G  0 lvm  /
sdb               8:16   0    2G  0 disk
sr0              11:0    1 1024M  0 rom
```