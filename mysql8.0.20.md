# mysql8.0.20源码解析

> 前置条件：熟悉C、C++语言和Cmake、ninja、make编译工具以及lldb调试工具
> https://blog.csdn.net/weixin_47156401/article/details/133579904 \
> [第9章 存放页的大池子-InnoDB的表空间 · 《MySQL 是怎样运行的：从根儿上理解 MySQL》](https://docs.kilvn.com/mysql-learning-notes/09-%E5%AD%98%E6%94%BE%E9%A1%B5%E7%9A%84%E5%A4%A7%E6%B1%A0%E5%AD%90-InnoDB%E7%9A%84%E8%A1%A8%E7%A9%BA%E9%97%B4.html) \
> [InnoDB 表空间](https://luyee.dev/archives/innodb-tablespace) \
> [segment 文档](https://blog.jcole.us/2013/01/04/page-management-in-innodb-space-files/)
## 一、编译

### 1、环境准备

#### 1.1、macos

- xcode12 xcode-select version 2396.
- 系统：macos ventura 13.2.1
- clang Apple clang version 14.0.0 (clang-1400.0.29.202)
- lldb lldb-1400.0.38.17
- cmake version 3.25.2
- [mysql-8.0.20](https://downloads.mysql.com/archives/community/)

更新系统 Sonoma 14.1

![macos](https://raw.githubusercontent.com/aierx/images/master/202401190953583.png)

### 1.2、centos

- cmake3
- gcc 7.5

```shell
yum -y install ncurses-devel
ln -s /usr/local/bin/gcc /usr/bin/cc
ln -s /usr/local/bin/g++ /usr/bin/c++
ln -s /usr/local/lib64/libstdc++.so.6.0.24 /usr/lib64/libstdc++.so.6
增加sys/sycall.h
修改os_compare_and_swap_thread_id->os_compare_and_swap_lint
```

#### 1.3、windows

#### 1.4、ubuntu 18.04
![ubuntu 18.04](https://raw.githubusercontent.com/aierx/images/master/20240115202640.png)

```shell
sudo apt install cmake
sudo apt-get install build-essential

wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz --no-check-certificate
tar -zxvf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
make -j 8 && make install
apt install libncurses5-dev pkg-config
```


### 2、下载源代码

```shell
# 执行路径 /Users/leiwenyong/Downloads
brew install openssl@1.1

wget https://cdn.mysql.com/archives/mysql-8.0/mysql-boost-8.0.20.tar.gz

tar -zxvf mysql-boost-8.0.20.tar.gz

cd mysql-8.0.2

# 修改一些代码（在macos上，因为lldb的编译器过高需要修改）（若不修改，后期编译会不通过）参考：https://zhuanlan.zhihu.com/p/411666378

mv VERSION MYSQL_VERSION 

sed -i '' 's|${CMAKE_SOURCE_DIR}/VERSION|${CMAKE_SOURCE_DIR}/MYSQL_VERSION|g' cmake/mysql_version.cmake
```

### 3、编译

```shell
# 执行路径 /Users/leiwenyong/Downloads/mysql-8.0.20/bld
mkdir bld
cd bld

# 需要指定自己openssl位置
cmake .. -DWITH_BOOST=../boost -DWITH_SSL=/usr/local/Cellar/openssl@1.1/1.1.1t -DWITH_DEBUG=true
make -j 8
```

### 4、运行 mysql 服务

```shell
# 执行路径  /Users/leiwenyong/Downloads/mysql-8.0.20/bld
cd bin

# 初始化数据库，会有个初始密码，需要记住
./mysqld --initialize

# 查看配置位置命令
mysql --help | grep 'my.cnf'

#启动mysql服务
./mysqld 
```

### 5、登入mysql

```shell
# 执行路径  /Users/leiwenyong/Downloads/mysql-8.0.20/bld/bin
./mysql -uroot -p'W9LzhqEwa,i&'

#修改密码 开启远程访问
alter user root@localhost identified by '02580258@lL';
use mysql;
select host from user where user='root';
update user set host='%' where user = 'root';
flush privileges;

#查看一些配置信息命令
show variables like '%dir%';
show processlist;
```

### 6、单步调试

 select语句断点位置 [CSDN 一条简单的sql是如何执行的](https://blog.csdn.net/why444216978/article/details/119857088)

 断点位置

 ```shell
 >do_command
| >dispatch_command
| | >mysql_parse
| | | >mysql_execute_command
| | | | >bool Sql_cmd_dml::execute
| | | | | >bool Sql_cmd_dml::prepare
| | | | | >SELECT_LEX_UNIT::optimize
| | | | | | >SELECT_LEX::optimize
| | | | | | >bool Query_result_send::send_data
| | | | | | | >THD::send_result_set_row
| | | | | | | <THD::send_result_set_row
| | | | | | <bool Query_result_send::send_data
# 读表
MYSQL_TABLE_IO_WAIT
# 最后发送数据位置
THD::send_result_set_row
 ```

 ```shell
 ps -ef | grep mysqld # 查看pid 我的14116
lldb #进入
attach 14116 #附加到进程
b handle_query # 下个断点
b mysql_execute_command #再下一个断点
mysql -uroot -p02580258@lL # 登入会卡住，在lldb中使用c继续运行
select * from user where user = 'root'; #执行此命令，进入断点
 ```

 常用断点位置便签
 ![mark](https://raw.githubusercontent.com/aierx/images/master/1f7c1c354603aae6dd6d573db540d4dc179593.png)

#### 6.1、lldb

lldb中使用gui命令可打开图形化界面

![lldb](https://raw.githubusercontent.com/aierx/images/master/202401151248949.png)

#### 6.2、clion

toolchains设置

![toochains](https://raw.githubusercontent.com/aierx/images/master/202401151250578.png)

cmake设置

![cmake](https://raw.githubusercontent.com/aierx/images/master/202401151251005.png)

选中mysqld项目，点击编译，然后启动就可以进入调试模式

![myqld](https://raw.githubusercontent.com/aierx/images/master/202401151252369.png)

### 7、其他

#### 7.1、mysql mysql.trace 定位方法调用过程

[MySQL 调试方式之mysqld.trace](https://www.cnblogs.com/jkin/p/16497783.html)

#### 7.2、优化 查看优化选项

```shell
-- 首先开启trace
set session optimizer_trace="enabled=on", end_markers_in_json=on;

-- 执行查询SQL
select * from employees where name > 'wei' order by position;

-- 查询trace字段
SELECT * FROM information_schema.OPTIMIZER_TRACE;

-- 当分析完SQL，关闭trace 
set session optimizer_trace="enabled=off"; 
```

### 二、命令解析

> yacc Shifting/Reducing （移进规约过程日志打印，启动参数：--debug="d,parser_debug"） \
> 日志参数（set debug = 'd:t:o';）

#### 1、常用的mysql命令

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
CREATE TABLE `test_innodb_lock` ( `a` INT(11) DEFAULT NULL,`b` VARCHAR(20) DEFAULT NULL,KEY `idx_lock_a` (`a`),KEY `idx_lock_b` (`b`) ) ENGINE = INNODB DEFAULT charset = utf8mb3;
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

#### 2、mysql存储结构

#### 3、抽象语法树 AST

#### 4、select语句处理流程

在information_schema.INNODB_INDEXS表中，保存了当前INNODB存储引擎的索引所在的页面。经过optimize计算是否需要索引，以及有没有主键。

open_tables_for_query (sql_base.cc:6508)

首先 open_table，然后打开索引表，

经过一系列的前置处理，最后会调用到row_search_mvcc这个方法

参数定义

```c++
dict_index_t *index = prebuilt->index; //索引

const dtuple_t *search_tuple = prebuilt->search_tuple; //查询条件

btr_pcur_t *pcur = prebuilt->pcur; // 当前游标

trx_t *trx = prebuilt->trx; // 事物

dict_index_t *clust_index; // 聚蔟索引（主键索引）

```

dict_index_t *index = prebuilt->index; //索引

const dtuple_t *search_tuple = prebuilt->search_tuple; //查询条件

btr_pcur_t *pcur = prebuilt->pcur; // 当前游标

trx_t *trx = prebuilt->trx; // 事物

dict_index_t *clust_index; // 聚蔟索引（主键索引）

根据主键、二级索引或者全表扫面，得到一行数据。第一行数据会存入buf指向的区域中，在后续遍历filedList的过程中，会从buf之前的区域中读取对应的字段值，并存入网络数据包的发送区域。紧接着，判断当前缓存区域有没有满（默认是8），若没有满读取下一条数据，存入缓存。当下一次读取的时候，先判断缓存中有没有数据，若缓存中存在数据直接从缓存中读数据即可。

mysql通过如下的迭代器，完成复杂语句的查询任务：

- TableScanIterator：顺序扫描，调用存储引擎接口ha_rnd_next获取一行记录。
- IndexScanIterator：全量索引扫描，根据扫描顺序，分别调用ha_index_next或者ha_index_prev来获取一行记录。
- IndexRangeScanIterator：范围索引扫描，包装了下QUICK_SELECT_I，调用QUICK_SELECT_I::get_next来获取一行记录。
- SortingIterator：对另一个迭代器输出进行排序。
- SortBufferIterator：从缓冲区读取已经排好序的结果集，(主要给SortingIterator调用)
- SortBufferIndirectIterator：从缓冲区读取行ID然后从表中读取对应的行（由SortingIterator和某些形式的unique操作使用）
- SortFileIterator：从文件中读取已经排好序的结果集(主要给SortingIterator调用)
- SortFileIndirectIterator：从文件读取行ID然后从表中读取对应的行（由SortingIterator和某些形式的unique操作使用）
- RefIterator：从连接右表中读取指定key的行。
- RefOrNullIterator：从连接右表中读取指定key或者为NULL的行。
- EQRefIterator：使用唯一key来从连接的右表中读取行。
- ConstIterator：从一个只可能匹配出一行的表(Const Table)中读取一行数据。
- FullTextSearchIterator：使用全文检索索引读取一行数据。
- DynamicRangeIterator：为每一行调用范围优化器，然后根据需要包装QUICK_SELECT_I或表扫描。
- PushedJoinRefIterator:读取已下推到NDB的连接的输出。
- FilterIterator: 读取一系列行，输出符合条件的行，用来实现WHERE/HAVING。
- LimitOffsetIterator: 从offset开始读取行，直到满足limit限制，用来实现LIMIT/OFFSET。
- AggregateIterator: 实现聚集函数并且如果需要的话进行分组操作。
- NestedLoopiterator: 使用嵌套循环算法连接两个迭代器（内连接，外连接或反连接）。
- MaterializeIterator: 从另一个迭代器读取结果，并放入临时表，然后读取临时表记录。
- FakeSingleRowIterator: 返回单行，然后结束。 仅在某些使用const表情况下才使用（例如只有const表，仍然需要一个迭代器来读取该单行）

##### 4.1、group by语句处理流程

##### 4.2、join语句处理流程

##### 4.3、子查询处理流程

##### 4.4、sorting实现

##### 4.5、窗口函数实现

### 5、update语句处理流程

>索引作为特殊的行记录，操作和普通行记录操作类似
> 索引没有transactionId和roll point，理所应当不会去记录undolog日志，如何做到正确查询到对应的行记录，如何保证的事物的一致性。
> 如果在删除行和修改行时，在事物没有提交前不将对应的索引行记录加入的page_free链表中就可以解决这个问题，只有在事物提交之后再去做删除操作就可以了。也就是在做更新和删除操作时，可能存在同一个索引字段对应多个主键的情况。

如下是索引对应的记录页

![idb1](https://raw.githubusercontent.com/aierx/images/master/202401151258550.png)

该页面中有如下行记录

1、01 00 02 00 1C 69 6E 66 69 6D 75 6D 00

2、06 00 0B 00 00 73 75 70 72 65 6D 75 6D

3、03 00 00 00 10 00 0E 61 61 61 80 00 00 01

4、03 00 00 00 18 00 1C 62 62 62 80 00 00 02

5、03 00 20 00 20 00 00 64 64 64 80 00 00 04

6、05 00 20 00 28 00 10 72 72 72 72 72 80 00 00 04

7、06 00 00 00 30 00 11 75 75 75 75 75 75 80 00 00 05

8、06 00 00 00 38 FF A6 78 78 78 78 78 78 80 00 00 04

record链表：1 -> 3 -> 4 -> 6 -> 7-> 8 -> 2

page_free链表：root -> 5

可见 5、6、8对应的主键都是0x80000004

#### 5.1、不更新主键

1. 原地更新\
行记录中不存在变长字段，或变长字段更新后的值小于等于更新前的值（并且需要有相同的前缀的时候）（以及当前行记录为最后一条时），采用就地更新。

2. 非原地更新\
当行记录中存在变长字段，变长字段更新后的值大于更新前的值，采用非原地更新。也就是将之前的行记录加入free链表，。如果当前页能够容纳新增的记录行，在当前页进行新增处理，若当前页不能够容纳新的记录行，需要进行分裂页处理。若当前行是第一行，修改infimum的offset为到当前行的偏移长度（偏移长度可为负值），若当前行为最后一行则需要将新增行的offset设置为到supremum的偏移长度。其他情况只需要将链表串起来即可。

创建一张空白的staff表

```sql
CREATE TABLE test.staff (
    id int NOT NULL,
    age int NULL,
    username varchar(100) NULL,
    CONSTRAINT pk PRIMARY KEY (id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci;
```

初始的page页

![idb2](https://raw.githubusercontent.com/aierx/images/master/202401151300808.png)

插入一条数据：

```sql
insert into staff (id,age,username) values(1,24,'leiwenyong');
```

![idb3](https://raw.githubusercontent.com/aierx/images/master/202401151300242.png)

当前有三条行记录

1、01 00 02 00 1C 69 6E 66 69 6D 75 6D 00

2、02 00 0B 00 00 73 75 70 72 65 6D 75 6D

3、0A 00 00 00 10 FF F1 80 00 00 01 00 00 00 00 56 4D 82 00 00 00 8F 01 10 80 00 00 18 6C 65 69 77 65 6E 79 6F 6E 67

第一条为infimum，offset值为 0x001C即十进制28，从当前位置0x696e开始数28个字节，也就是刚刚插入行的主键开始位置。新插入行的主键前量字节0xFFF1(补码)对应十进制的-15，也就是从0x8000位置向前数15字节，对应的行就是supremum。

当前的链表指向为1 -> 3 ->2

执行sql：

```sql
update staff  set username = 'leiwen' where id = 1;
```

![idb4](https://raw.githubusercontent.com/aierx/images/master/202401151301996.png)

可以看到，第二条行记录改为了

06 00 00 00 10 FF F1 80 00 00 01 00 00 00 00 56 52 02 00 00 01 22 02 6C 80 00 00 18 6C 65 69 77 65 6E

0A -> 06，也就是变长字段的长度从之前的10->6

执行sql：

```sql
update staff  set username = 'aleiwenyong' where id = 1;
```

![idb5](https://raw.githubusercontent.com/aierx/images/master/202401151302913.png)

长度再次发生改变，由此可见，假如当前需要更新的行记录是最后一条时，就会远点更新，不会重新创建一条记录。

执行sql：

```sql
insert into staff (id,age,username) values(2,30,'xiaoming');

update staff  set username = 'aleiwenyong1' where id = 1;
```

![idb6](https://raw.githubusercontent.com/aierx/images/master/202401151302584.png)

1、01 00 02 00 67 69 6E 66 69 6D 75 6D 00

2、03 00 0B 00 00 73 75 70 72 65 6D 75 6D

3、0B 00 00 00 10 00 00 80 00 00 01 00 00 00 00 56 54 01 00 00 01 28 04 16 80 00 00 18 61 6C 65 69 77 65 6E 79 6F 6E 67

4、08 00 00 00 18 FF CA 80 00 00 02 00 00 00 00 56 56 82 00 00 00 92 01 10 80 00 00 1E 78 69 61 6F 6D 69 6E 67

5、0C 00 00 00 20 FF DC 80 00 00 01 00 00 00 00 56 5B 01 00 00 01 4B 01 51 80 00 00 18 61 6C 65 69 77 65 6E 79 6F 6E 67 31

当前指向1->5->4->2

PAGE_FREE为0x007F，经过计算从当前页的开始位置到3这条行记录的主键位置刚好为127。（可以猜测PAGE_FREE链表为当前page的开始位置到第一条free行记录的长度

执行sql：

```sql
update staff  set username = 'xiao' where id = 2;

update staff  set username = 'xiao1' where id = 2; 

update staff  set username = 'aleiwenyong' where id = 1;
```

![idb7](https://raw.githubusercontent.com/aierx/images/master/202401151303567.png)

1、01 00 02 00 67 69 6E 66 69 6D 75 6D 00

2、03 00 0B 00 00 73 75 70 72 65 6D 75 6D

3、0B 00 00 00 10 00 00 80 00 00 01 00 00 00 00 56 54 01 00 00 01 28 04 16 80 00 00 18 61 6C 65 69 77 65 6E 79 6F 6E 67

4、04 00 00 00 18 FF D9 80 00 00 02 00 00 00 00 56 5D 02 00 00 01 40 01 51 80 00 00 1E 78 69 61 6F 6D 69 6E 67

5、0B 00 00 00 20 00 28 80 00 00 01 00 00 00 00 56 61 02 00 00 01 41 01 51 80 00 00 18 61 6C 65 69 77 65 6E 79 6F 6E 67 31

6、05 00 00 00 28 FF 7E 80 00 00 02 00 00 00 00 56 5F 01 00 00 01 4C 01 51 80 00 00 1E 78 69 61 6F 31

record链表：1->5->6->2

free链表：page header ->4->3

存在问题：原地更新的情况下，如aleiwenyong1->aleiwenyong减少了一位，体现在变长字段上面由0x0C->0x0b，mysql是如何确定age字段的起始位置的。此处age字段位于第二列，所以不存在不能判断的情况，假如变长字段在username在第二列，而定长字段age在第三行时，又当如何。(实际情况是，假如缩减字段长度，mysql会将之后的字段向前移动)

> 使用optimize table tablename命令可以彻底page_free链表

#### 5.2、更新主键

更新操作在更新主键时，首先会将之前的行记录加入page_free链表头，然后执行新增一条行记录的操作。

### 6、insert语句处理流程

insert语句在执行操作时（不考虑分裂页的情况下，也就是当前页能够容纳需要新增的行记录），在更新操作和删除中我们可以知道，更新或删除清除掉的行记录会加入page_free链表的表头。进行插入操作，首先会获取当前free链表的表头行记录，判断当前表头行记录占用的空间是不是满足新增行记录所需要的空间，如果满足，直接在当前行记录上进行操作。否则将在当前页空闲位置进行插入操作（不会遍历free链表，寻找合适位置进行插入操作）。

### 7、delete语句处理流程

delete语句处理比较简单，将当前行记录的delete_mark标记置为已删除，并且将当前行加入free链表表头。

### 8、mysql binlog、undolog、redolog日志分析

### 9、mvcc （Multiversion Concurrency Control）如何实现

#### 9.1、ACID

- atomicity 原子性 使用undolog文件实现原子性。

- consistency 一致性 使用redolog文件实现一致性，先写redolog文件，将状redolog文件态设置为prepare，再写binlog文件（用于主从、主主、级联同步），将redolog日志设置commit，最后提交事务。掉电后通过比对redolog文件和undolog文件是否一致确定要提交记录还是恢复记录。

- isolation 隔离性 使用悲观锁（每次获取资源加锁）、乐观锁（不加锁，自旋，版本控制）、Mutil Version concurrency control实现隔离性。

- durability 持久性。

#### 9.2、事物隔离级

所有事务都不存在一类丢失更新。

- 【RU】read uncommitted 脏读、 幻读、 不可重复读、 二类丢失更新 当前读，每次读取的都是最新记录。

- 【RC】read committed 幻读、 不可重复读、 二类丢失更新 快照读，每次查询重新构建read_view,所以每次读出来的记录都是已经提交的记录。

- 【RR】repeatable read 不可重复读、 二类丢失更新 快照读，创建session时创建read_view,不能读出已经提交的记录。

- 【SE】serializable 串行执行，不存在并发问题 当前读，成一个队列执行。

#### 9.3、当前读

在select语句的后面加上for update，就可以开启当前读

```sql
CREATE TABLE `user1` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
insert into user1 （id,name) values(1,'aaaa');

-- session 1
begin;
update user1 set name = 'bbbb' where id = 1;

-- session 2
begin;
select * from user1 where id = 1 for update;  -- 此时session2会卡住，等待其他session提交任务；

-- session 1
commit; -- 此时session2会读取到最新的值
```

当前栈帧

![stack](https://raw.githubusercontent.com/aierx/images/master/202401151306709.png)

先获取表锁 ->  通过主键索引获取第一行记录

当读取到一行数据之后，根据查询的条件，判读需要加什么锁。当前采用id查询加的是LOCK_REC_NOT_GAP锁。

拿到需要加锁的类型之后，调用添加sel_set_rec_lock方法进行加锁。

由于当前for update进行查询的，并且另外一个session还没commit，sel_set_rec_lock方法返回结果是DB_LOCK_WAIT

![stack](https://raw.githubusercontent.com/aierx/images/master/202401151307094.png)

最后调用lock_wait_suspend_thread将当前线程进行挂起 (最后调用的是pthread库中的pthread_cond_wait)。

（如果超时，此处的pthread_cond_wait会由pthread_cond_broadcast方法进行唤醒）

当session1进行commit操作之后，session2再次进入rec_loop。再次尝试获取行锁。

如果session1长时间没有提交事物，session2进入处理超时逻辑，返回超时文本。

#### 9.4、快照读

[MySQL-MVCC实现原理](https://www.cnblogs.com/panxianhao/p/14904874.html)

快照读是实现事物的基础，在执行查询语句时不加for update时使用的就是快照读。

在row_search_mvcc方法中获取通过调用trx_assign_read_view方法获取一个readview

![eval](https://raw.githubusercontent.com/aierx/images/master/202401151308508.png)

通过lock_clust_rec_cons_read_sees方法判断当前行对于当前事物id是不是可见，如果是临时表直接返回true。

![code](https://raw.githubusercontent.com/aierx/images/master/202401151308361.png)

changes_visible方法中传入的trx_id是行记录上面的id：

- 如果当前行记录的事物id小于活跃事务id的最小值，返回true

- 如果当前行记录的事物id等于当前线程的事物id，返回true

- 如果当前行记录的事物id大于最大的活跃事物id，返回false

- 如果活跃事物id列表为空，返回true

- 如果当前线程事物id存在于活跃事物id列表，返回false

#### 10、mysql主从同步

### 三、wireshark抓包

> 使用 mysql -h127.0.0.1 -P3306 -uroot -pyour_password登入才能进行正常抓包 \
> wireshark选择Loopback:lo0接口，设置过滤条件为tcp.port == 3306

select * from user; 命令解析

![terminal](https://raw.githubusercontent.com/aierx/images/master/202401151310931.png)

为了读懂wireshark的数据包，我们需要亿点点网络知识：参考链接 [protocol](https://zhangbinalan.gitbooks.io/protocol/content/)

网络模型

![picture1](https://raw.githubusercontent.com/aierx/images/master/netio.png)

IP首部20字节含义如下表，数据部分对应就是上层协议：

![picture2](https://raw.githubusercontent.com/aierx/images/master/ip.png)

本次对应就是TCP协议，TCP首部字节如下表：

![picture3](https://raw.githubusercontent.com/aierx/images/master/tcp.png)

有一点点网络基础我们就可以开始看wireShark的数据包了 wireshark文件下载

![picture4](https://raw.githubusercontent.com/aierx/images/master/202401151317595.png)

### 四、物理存储格式

#### 1、行记录格式

|                                            |
| ------------------------------------------ |
| grow longer (not fix)                      |
| null flags (not fix,but minimun is 1 byte) |
|                                            |
| reserved field 1 (1 bit)                   |
| reserved  field 2 (1 bit)                  |
| delete_mask (1 bit)                        |
| min_rec_mask (1 bit)                       |
| n_owned (4 bits)                           |
| heap_no (13 bits)                          |
| record_type (3 bit3)                       |
| next_record (2 bytes)                      |
|                                            |
| row_id (6 bytes or define size)            |
| tx_id (6 bytes)                            |
| roll_ptr (7 bytes)                         |


![record format](https://raw.githubusercontent.com/aierx/images/master/record.png)

#### 2、table space

##### page type
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

## FIL_PAGE_TYPE_FSP_HDR
```shell
fn base(){
    return 0*16*1024;
};

// ------------------------cursor------------------------------
u32  _cursor @base() + 0x00;

// ------------------------file header------------------------------
struct file_header{
	u32 a_FIL_PAGE_SPACE_OR_CHKSUM;
	u32 b_FIL_PAGE_OFFSET;
	u32 c_FIL_PAGE_PREV;
	u32 d_FIL_PAGE_NEXT;
	u64 e_FIL_PAGE_LSN;
	u16 f_FIL_PAGE_TYPE;
	u64 g_FIL_PAGE_FILE_FLUSH_LSN;
	u32 h_FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID;
};

// ------------------------fsp header------------------------------
struct fsp_header{
	u32  a_fsp_space_id;
	u32  b_fsp_not_used;
	u32  c_fsp_size;
	u32  d_fsp_free_limit;
	u32  e_fsp_space_flags;
	u32  f_fsp_frag_n_used;
	u128 g_fsp_free;
	u128 h_fsp_free_frag;
	u128 i_fsp_full_frag;
	u64  j_fsp_seg_id;
	u128 k_fsp_seg_inodes_full;
	u128 l_fsp_seg_inode_free;
};


// ---------------------XDES Entry--------------------------
struct xdes_flst_node{
    u32 pre_no;
    u16 pre_offset;
    u32 next_no;
    u16 nex_offset;
};

struct xdes_entry{
	u64 		a_xdes_id;
	xdes_flst_node 	b_xdes_flst_node;
	u32		c_xdes_state;
	u128		d_xdes_bitmap;
};

// ---------------------file trailer--------------------------
struct file_trailer{
	u64 File_Trailer;
};

// -------------------------main------------------------------
struct main{
	file_header;
	fsp_header;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
	xdes_entry;
};
main a_main @base();
file_trailer 	d_file_trailer 		@base()+16*1024-8;
```

## FIL_PAGE_IBUF_BITMAP
```shell
fn base(){
    return 1*16*1024;
};

// ------------------------cursor------------------------------
u32  _cursor @base() + 0x00;

// ------------------------file header------------------------------
struct file_header{
	u32 a_FIL_PAGE_SPACE_OR_CHKSUM;
	u32 b_FIL_PAGE_OFFSET;
	u32 c_FIL_PAGE_PREV;
	u32 d_FIL_PAGE_NEXT;
	u64 e_FIL_PAGE_LSN;
	u16 f_FIL_PAGE_TYPE;
	u64 g_FIL_PAGE_FILE_FLUSH_LSN;
	u32 h_FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID;
};

// ------------------------ibuf bitmap list------------------------------
struct ibuf_bitmap{
	u16  a_free_space;
	u8  b_buffered_flag;
	u8  c_change_buffer_flag;
};

// ---------------------file trailer--------------------------
struct file_trailer{
	u64 File_Trailer;
};

// -------------------------main------------------------------
struct main{
	file_header;
	ibuf_bitmap;
	ibuf_bitmap;
};
main a_main @base();
file_trailer 	d_file_trailer 		@base()+16*1024-8;
```

## FIL_PAGE_INODE
```shell
fn base(){
    return 2*16*1024;
};

// ------------------------cursor------------------------------
u32  _cursor @base() + 0x00;

// ------------------------file header------------------------------
struct file_header{
	u32 a_FIL_PAGE_SPACE_OR_CHKSUM;
	u32 b_FIL_PAGE_OFFSET;
	u32 c_FIL_PAGE_PREV;
	u32 d_FIL_PAGE_NEXT;
	u64 e_FIL_PAGE_LSN;
	u16 f_FIL_PAGE_TYPE;
	u64 g_FIL_PAGE_FILE_FLUSH_LSN;
	u32 h_FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID;
};
// ------------------------list node for inode page list------------------------------

struct lnfipl{
	u32	a_prev_page_number;
	u16	b_prev_offset;
	u32	c_next_page_number;
	u16	d_offset;
};

// ------------------------inode header------------------------------
struct base_node{
	u32	list_length;
	u32	first_page_number;
	u16	first_offset;
	u32	last_page_number;
	u16	last_offset;
};


struct inode_entry{
	u64  		fseg_id;
	u32  		fseg_not_full_n_used;
	base_node  fseg_free;
	base_node  fseg_not_full;
	base_node  fseg_full;
	u32 f_fseg_magic_n;
	u32 entry_0;
	u32 entry_1;
	u32 entry_2;
	u32 entry_3;
	u32 entry_4;
	u32 entry_5;
	u32 entry_6;
	u32 entry_7;
	u32 entry_8;
	u32 entry_9;
	u32 entry_10;
	u32 entry_11;
	u32 entry_12;
	u32 entry_13;
	u32 entry_14;
	u32 entry_15;
	u32 entry_16;
	u32 entry_17;
	u32 entry_18;
	u32 entry_19;
	u32 entry_20;
	u32 entry_21;
	u32 entry_22;
	u32 entry_23;
	u32 entry_24;
	u32 entry_25;
	u32 entry_26;
	u32 entry_27;
	u32 entry_28;
	u32 entry_29;
	u32 entry_30;
	u32 entry_31;
};


// ---------------------file trailer--------------------------
struct file_trailer{
	u64 File_Trailer;
};

// -------------------------main------------------------------
struct main{
	file_header;
	lnfipl;
    inode_entry;
    inode_entry;
    inode_entry;
    inode_entry;
    inode_entry;
    inode_entry;
};
main a_main @base();
file_trailer 	d_file_trailer 		@base()+16*1024-8;
```

## FIL_PAGE_INDEX & FIL_PAGE_RTREE
```shell
fn base(){
    return 4*16*1024;
};

// ------------------------cursor------------------------------
u32  _cursor @base() + 0x00;

// ------------------------file header------------------------------
struct file_header{
	u32 a_FIL_PAGE_SPACE_OR_CHKSUM;
	u32 b_FIL_PAGE_OFFSET;
	u32 c_FIL_PAGE_PREV;
	u32 d_FIL_PAGE_NEXT;
	u64 e_FIL_PAGE_LSN;
	u16 f_FIL_PAGE_TYPE;
	u64 g_FIL_PAGE_FILE_FLUSH_LSN;
	u32 h_FIL_PAGE_ARCH_LOG_NO_OR_SPACE_ID;
};

// ------------------------page header------------------------------
struct b10{
    u64 a_start;
    u16 b_end;
};

struct page_header{
	u16 a_PAGE_N_DIR_SLOTS;
	u16 b_PAGE_HEAP_TOP;
	u16 c_PAGE_N_HEAP;
	u16 d_PAGE_FREE;
	u16 e_PAGE_GARBAGE;
	u16 f_PAGE_LAST_INSERT;
	u16 g_PAGE_DIRECTION;
	u16 h_PAGE_N_DIRECT;
	u16 i_PAGE_N_RECS;
	u64 j_PAGE_MAX_TRX_ID;
	u16 k_PAGE_LEVEL;
	u64 l_PAGE_INDEX_ID;
	b10 m_PAGE_BTR_SEG_LEAF;
	b10 n_PAGE_BTR_SEG_TOP;
};


// ---------------------system record--------------------------
struct b13{
    u8 a_start;
    u32 b_middle;
    u64 c_end;
};

struct system_record{
	b13 a_Infimum;
	b13 b_Supremum;
};

// ---------------------file trailer--------------------------
struct file_trailer{
	u64 File_Trailer;
};

// -------------------------main------------------------------
file_header 	a_file_header 		@base();
page_header 	b_page_header 		@base()+38;
system_record 	c_system_record  	@base()+38+56;
file_trailer 	d_file_trailer 		@base()+16*1024-8;

```



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
