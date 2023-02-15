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

