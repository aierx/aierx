[MySQL :: MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)

[数据库并发事务所带来的问题](https://blog.csdn.net/wkt520zch/article/details/118178601)

[数据结构可视化](https://www.cs.usfca.edu/~galles/visualization/Algorithms.html)

# 常用命令

```sql
alert USER 'root'@'localhost' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;
flush privileges;
SELECT @@global.TRANSACTION_ISOLATION;
show global variables like '%trans%';
set global transaction isolation level read committed;
-- 查看表详情
show create table user;
desc user;
-- 创建表
create table user
(
    id   int                               not null,
    name varchar(255) default 'leiwenyong' not null,
    constraint user_pk
        primary key (id)
)engine innodb;
-- 查看索引
show index from user;
-- 删除索引
alter table t1.user drop index name;
drop index pass on user;
-- 添加索引
alter table user add index pass (pass) using btree;
-- 更改存储引擎
alter table user engine=myisam;
-- 优化过程
set optimizer_trace="enabled=on";
select * from information_schema.optimizer_trace\G
```

# 开启日志功能

```shell
# 命令行 无需重启
$ set GLOBAL log_output='FILE'
$ set global general_log=on;
$ set global general_log_file='C:/app/mysql_log.log';
# 修改配置文件
[mysqld]
log_output=FILE	# 日志打印到文件，默认配置，可以配置成table，日志就会记录到mysql库中的相应的表中(slow日志也会受影响)
general_log=1
general_log_file=/application/mysql/logs/query_log.log
# 修改密码
alter user 'root'@'localhost' identified by '123456';
flush privileges; 
```

# 开启慢日志记录

```shell
# 查看慢日志开启状态
$ show variables like 'slow_query%';
# 查看多少秒开始记录
$ show variables like 'long_query_time';

```

# ACID介绍

- atomicity   原子性
  使用undolog文件实现原子性。
- consistency 一致性
  使用redolog文件实现一致性，先写redolog文件，将状redolog文件态设置为prepare，再写binlog文件（用于主从、主主、级联同步），将redolog日志设置commit，最后提交事务。掉电后通过比对redolog文件和undolog文件是否一致确定要提交记录还是恢复记录。
- isolation   隔离性
  使用悲观锁（每次获取资源加锁）、乐观锁（不加锁，自旋，版本控制）、Mutil Version concurrency control实现隔离性。
- durability  持久性。

# 事务隔离级别

  所有事务都不存在一类丢失更新。

- 【RU】read uncommitted  `脏读`、 `幻读`、 `不可重复读`、 `二类丢失更新`
  当前读，每次读取的都是最新记录。
- 【RC】read committed  `幻读`、 `不可重复读`、 `二类丢失更新`
  快照读，每次查询重新构建read_view,所以每次读出来的记录都是已经提交的记录。
- 【RR】repeatable read  `不可重复读`、 `二类丢失更新`
  快照读，创建session时创建read_view,不能读出已经提交的记录。
- 【SE】serializable  `串行执行，不存在并发问题`
  当前读，成一个队列执行。

# 常用命令

```sql
-- 设置会话隔离级别
set session transaction isolation level read uncommitted;
set session transaction isolation level read committed;
set session transaction isolation level repeatable read;
set session transaction isolation level serializable;
-- 查看当前会话隔离级别
select @@transaction_isolation;
-- 查看是否自动提交
show session variables like 'autocommit';
show global variables like 'autocommit';
show variables like 'autocommit';
-- 设置不自动提交
set session autocommit=0;
set global autocommit=0;
set @@autocommit = 0;
-- 查看mysql table引擎
show create table demo;
show table status from `ruoyi` where name='table_name';
-- 慢查询日志
show variables like '%slow_query_log%';
-- 开启慢查询日志
set global slow_query_log=1;
-- 查看锁状态
show status like '%innodb_row_lock%';
show status like '%lock%';
show variables like '%timeout%'
-- 查看当前锁
use information_schema;
-- 建立索引
create index idx_lock_count on demo(count);
-- 创建表
CREATE TABLE `test_innodb_lock` ( 
	`a` INT(11) DEFAULT NULL,
	`b` VARCHAR(20) DEFAULT NULL,
	KEY `idx_lock_a` (`a`),
	KEY `idx_lock_b` (`b`) 
) ENGINE = INNODB DEFAULT charset = utf8mb3;
-- 查询是否锁表
show OPEN TABLES where In_use > 0;
show open tables;
-- 查询进程（如果您有SUPER权限，您可以看到所有线程。否则，您只能看到您自己的线程）
show processlist;
show full processlist;
kill id
-- 查看正在执行的事务
SELECT * FROM INFORMATION_SCHEMA.INNODB_TRX \G;
kill id
-- 查看正在锁的事务
SELECT * FROM performance_schema.data_LOCKS \G;
-- 查看等待锁的事务
SELECT * FROM performance_schema.data_LOCK_WAITS \G;
```
> rlike #可以使用正则表达式匹配

# 开启日志功能

```shell
# 命令行 无需重启
$ set GLOBAL log_output='FILE'
$ set global general_log=on;
$ set global general_log_file='C:/app/mysql_log.log';
# 修改配置文件
[mysqld]
log_output=FILE	# 日志打印到文件，默认配置，可以配置成table，日志就会记录到mysql库中的相应的表中(slow日志也会受影响)
general_log=1
general_log_file=/application/mysql/logs/query_log.log
```

# 开启慢日志记录
```shell
# 查看慢日志开启状态
$ show variables like 'slow_query%';
# 查看多少秒开始记录
$ show variables like 'long_query_time';

```


# imhex工具可视化脚本
```shell
struct b10{
    u64 start;
    u16 end;
};

struct b13{
    u8 start;
    u32 middle;
    u64 end;
};

fn base(){
    return 1*16*1024;
};

// ------------------------cursor------------------------------

u32  cursor @base() + 0x00;

// ------------------------file header------------------------------
u32 FIL_PAGE_SPACE_OR_CHKSUM            @base();
u32 FIL_PAGE_OFFSET                     @base()+4;
u32 FIL_PAGE_PREV                       @base()+4+4;
u32 FIL_PAGE_NEXT                       @base()+4+4+4;
u64 FIL_PAGE_LSN                        @base()+4+4+4+4;
u16 FIL_PAGE_TYPE                       @base()+4+4+4+4+8;
u64 FIL_PAGE_FILE_FLUSH_LSN             @base()+4+4+4+4+8+2;
u32 FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID    @base()+4+4+4+4+8+2+8;

// ------------------------page header------------------------------
u16 PAGE_N_DIR_SLOTS                    @base()+4+4+4+4+8+2+8+4;
u16 PAGE_HEAP_TOP                       @base()+4+4+4+4+8+2+8+4+2;
u16 PAGE_N_HEAP                         @base()+4+4+4+4+8+2+8+4+2+2;
u16 PAGE_FREE                           @base()+4+4+4+4+8+2+8+4+2+2+2;
u16 PAGE_GARBAGE                        @base()+4+4+4+4+8+2+8+4+2+2+2+2;
u16 PAGE_LAST_INSERT                    @base()+4+4+4+4+8+2+8+4+2+2+2+2+2;
u16 PAGE_DIRECTION                      @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2;
u16 PAGE_N_DIRECT                       @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2;
u16 PAGE_N_RECS                         @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2;
u64 PAGE_MAX_TRX_ID                     @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2;
u16 PAGE_LEVEL                          @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8;
u64 PAGE_INDEX_ID                       @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8+2;
b10 PAGE_BTR_SEG_LEAF                   @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8+2+8;
b10 PAGE_BTR_SEG_TOP                    @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8+2+8+10;

// ---------------------generate limit record--------------------------

b13 Infimum                             @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8+2+8+10+10;
b13 Supremum                            @base()+4+4+4+4+8+2+8+4+2+2+2+2+2+2+2+2+2+8+2+8+10+10+13;

// ---------------------file trailer--------------------------
u64 File_Trailer                        @base()+0x4000-0x8;
```

# page type
| File page types                     | hex    | desc                                                |
| ----------------------------------- | ------ | --------------------------------------------------- |
| FIL_PAGE_INDEX                      | 0x45bf | B-tree node                                         |
| FIL_PAGE_RTREE                      | 0x45be | R-tree node                                         |
| FIL_PAGE_SDI                        | 0x45bd | Tablespace SDI Index page                           |
| FIL_PAGE_UNDO_LOG                   | 0x0002 | Undo log page                                       |
| FIL_PAGE_INODE                      | 0x0003 | Index node                                          |
| FIL_PAGE_IBUF_FREE_LIST             | 0x0004 | Insert buffer free list                             |
| FIL_PAGE_TYPE_ALLOCATED             | 0x0000 | Freshly allocated page                              |
| FIL_PAGE_IBUF_BITMAP                | 0x0005 | Insert buffer bitmap                                |
| FIL_PAGE_TYPE_SYS                   | 0x0006 | System page                                         |
| FIL_PAGE_TYPE_TRX_SYS               | 0x0007 | Transaction system data                             |
| FIL_PAGE_TYPE_FSP_HDR               | 0x0008 | File space header                                   |
| FIL_PAGE_TYPE_XDES                  | 0x0009 | Extent descriptor page                              |
| FIL_PAGE_TYPE_BLOB                  | 0x000a | Uncompressed BLOB page                              |
| FIL_PAGE_TYPE_ZBLOB                 | 0x000b | First compressed BLOB page                          |
| FIL_PAGE_TYPE_ZBLOB2                | 0x000c | Subsequent compressed BLOB page                     |
| FIL_PAGE_TYPE_UNKNOWN               | 0x000d | it is replaced with this value when flushing pages. |
| FIL_PAGE_COMPRESSED                 | 0x000e | Compressed page                                     |
| FIL_PAGE_ENCRYPTED                  | 0x000f | Encrypted page                                      |
| FIL_PAGE_COMPRESSED_AND_ENCRYPTED   | 0x0010 | Compressed and Encrypted page                       |
| FIL_PAGE_ENCRYPTED_RTREE            | 0x0011 | Encrypted R-tree page                               |
| FIL_PAGE_SDI_BLOB                   | 0x0012 | Uncompressed SDI BLOB page                          |
| FIL_PAGE_SDI_ZBLOB                  | 0x0013 | Commpressed SDI BLOB page                           |
| FIL_PAGE_TYPE_LEGACY_DBLWR          | 0x0014 | Legacy doublewrite buffer page.                     |
| FIL_PAGE_TYPE_RSEG_ARRAY            | 0x0015 | Rollback Segment Array page                         |
| FIL_PAGE_TYPE_LOB_INDEX             | 0x0016 | Index pages of uncompressed LOB                     |
| FIL_PAGE_TYPE_LOB_DATA              | 0x0017 | Data pages of uncompressed LOB                      |
| FIL_PAGE_TYPE_LOB_FIRST             | 0x0018 | The first page of an uncompressed LOB               |
| FIL_PAGE_TYPE_ZLOB_FIRST            | 0x0019 | The first page of a compressed LOB                  |
| FIL_PAGE_TYPE_ZLOB_DATA             | 0x001a | Data pages of compressed LOB                        |
| FIL_PAGE_TYPE_ZLOB_INDEX            | 0x001b | Index pages of compressed LOB.                      |
| FIL_PAGE_TYPE_ZLOB_FRAG = 28;       | 0x001c | Fragment pages of compressed LOB.                   |
| FIL_PAGE_TYPE_ZLOB_FRAG_ENTRY = 29; | 0x001f | Index pages of fragment pages (compressed LOB)      |

# 行记录格式
[row format](https://zhuanlan.zhihu.com/p/552303064)
[table space](https://blog.51cto.com/59090939/1955122)
## record header
![row format](https://pic3.zhimg.com/80/v2-a75b74c85463d6718b8d251725e8c646_720w.webp)

| hex  | type   |
| ---- | ------ |
| 0x00 | normal |
| 0x01 | index  |
| 0x02 | min    |
| 0x03 | max    |

# undo log page header 

[undolog](https://catkang.github.io/2021/10/30/mysql-undo.html)

```shell
struct b10{
    u32 start;
    u48 end;
};


struct b12{
    u32 start;
    u64 end;
};

struct b16{
    u64 start;
    u64 end;
};

fn base(){
    return 339*16*1024;
};

// ------------------------cursor------------------------------

u32  cursor @base() + 0x00;

// ------------------------file header------------------------------
u32 FIL_PAGE_SPACE_OR_CHKSUM            @base();
u32 FIL_PAGE_OFFSET                     @base()+4;
u32 FIL_PAGE_PREV                       @base()+4+4;
u32 FIL_PAGE_NEXT                       @base()+4+4+4;
u64 FIL_PAGE_LSN                        @base()+4+4+4+4;
u16 FIL_PAGE_TYPE                       @base()+4+4+4+4+8;
u64 FIL_PAGE_FILE_FLUSH_LSN             @base()+4+4+4+4+8+2;
u32 FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID    @base()+4+4+4+4+8+2+8;

// ------------------------undo page header------------------------------
u16 UNDO_PAGE_TYPE                      @base()+4+4+4+4+8+2+8+4;
u16 P_LASTED_LOG_RECORD_OFFSET          @base()+4+4+4+4+8+2+8+4+2;
u16 FREE_SPACE_OFFSET                   @base()+4+4+4+4+8+2+8+4+2+2;
b12 UNDO_PAGE_LIST_NODE                 @base()+4+4+4+4+8+2+8+4+2+2+2;

// ------------------------undo segment header------------------------------

u16 STATE                               @base()+4+4+4+4+8+2+8+4+2+2+2+12;
u16 S_LASTED_LOG_RECORD_OFFSET          @base()+4+4+4+4+8+2+8+4+2+2+2+12+2;
b10 UNDO_SEGMENT_FSEG_HEADER            @base()+4+4+4+4+8+2+8+4+2+2+2+12+2+2;
b16 UNDO_SEGMENT_PAGE_LIST_BASE_NODE    @base()+4+4+4+4+8+2+8+4+2+2+2+12+2+2+10;


// ---------------------file trailer--------------------------
u64 File_Trailer                        @base()+0x4000-0x8;
```
![表结构](https://s2.loli.net/2023/08/07/VWr8CxJSRydi9E6.jpg)
