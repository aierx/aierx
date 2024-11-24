> 参考文章：[数据库的4种隔离级别 - myseries - 博客园](https://www.cnblogs.com/myseries/p/10748912.html)

## 1、先上一份源码

```java
/*
 * Copyright 2002-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.transaction.annotation;

import org.springframework.transaction.TransactionDefinition;

/**
 * Enumeration that represents transaction propagation behaviors for use
 * with the {@link Transactional} annotation, corresponding to the
 * {@link TransactionDefinition} interface.
 *
 * @author Colin Sampaleanu
 * @author Juergen Hoeller
 * @since 1.2
 */
public enum Propagation {

	/**
	 * Support a current transaction, create a new one if none exists.
	 * Analogous to EJB transaction attribute of the same name.
	 * <p>This is the default setting of a transaction annotation.
	 */
	REQUIRED(TransactionDefinition.PROPAGATION_REQUIRED),

	/**
	 * Support a current transaction, execute non-transactionally if none exists.
	 * Analogous to EJB transaction attribute of the same name.
	 * <p>Note: For transaction managers with transaction synchronization,
	 * {@code SUPPORTS} is slightly different from no transaction at all,
	 * as it defines a transaction scope that synchronization will apply for.
	 * As a consequence, the same resources (JDBC Connection, Hibernate Session, etc)
	 * will be shared for the entire specified scope. Note that this depends on
	 * the actual synchronization configuration of the transaction manager.
	 * @see org.springframework.transaction.support.AbstractPlatformTransactionManager#setTransactionSynchronization
	 */
	SUPPORTS(TransactionDefinition.PROPAGATION_SUPPORTS),

	/**
	 * Support a current transaction, throw an exception if none exists.
	 * Analogous to EJB transaction attribute of the same name.
	 */
	MANDATORY(TransactionDefinition.PROPAGATION_MANDATORY),

	/**
	 * Create a new transaction, and suspend the current transaction if one exists.
	 * Analogous to the EJB transaction attribute of the same name.
	 * <p><b>NOTE:</b> Actual transaction suspension will not work out-of-the-box
	 * on all transaction managers. This in particular applies to
	 * {@link org.springframework.transaction.jta.JtaTransactionManager},
	 * which requires the {@code javax.transaction.TransactionManager} to be
	 * made available to it (which is server-specific in standard Java EE).
	 * @see org.springframework.transaction.jta.JtaTransactionManager#setTransactionManager
	 */
	REQUIRES_NEW(TransactionDefinition.PROPAGATION_REQUIRES_NEW),

	/**
	 * Execute non-transactionally, suspend the current transaction if one exists.
	 * Analogous to EJB transaction attribute of the same name.
	 * <p><b>NOTE:</b> Actual transaction suspension will not work out-of-the-box
	 * on all transaction managers. This in particular applies to
	 * {@link org.springframework.transaction.jta.JtaTransactionManager},
	 * which requires the {@code javax.transaction.TransactionManager} to be
	 * made available to it (which is server-specific in standard Java EE).
	 * @see org.springframework.transaction.jta.JtaTransactionManager#setTransactionManager
	 */
	NOT_SUPPORTED(TransactionDefinition.PROPAGATION_NOT_SUPPORTED),

	/**
	 * Execute non-transactionally, throw an exception if a transaction exists.
	 * Analogous to EJB transaction attribute of the same name.
	 */
	NEVER(TransactionDefinition.PROPAGATION_NEVER),

	/**
	 * Execute within a nested transaction if a current transaction exists,
	 * behave like {@code REQUIRED} otherwise. There is no analogous feature in EJB.
	 * <p>Note: Actual creation of a nested transaction will only work on specific
	 * transaction managers. Out of the box, this only applies to the JDBC
	 * DataSourceTransactionManager. Some JTA providers might support nested
	 * transactions as well.
	 * @see org.springframework.jdbc.datasource.DataSourceTransactionManager
	 */
	NESTED(TransactionDefinition.PROPAGATION_NESTED);


	private final int value;


	Propagation(int value) {
		this.value = value;
	}

	public int value() {
		return this.value;
	}

}

```

## 2、当前服务存在A服务和B服务

```java
// 服务一
@Service
public class UserService1 {
    @Autowired
    UserDao userDao;

    @Autowired
    UserService2 userService2;

    //使用默认事务传播级别
    @Transactional
    public User getUser(int id) {
        user.setUsername("外部事2323232务");
        user.setId(1);
        userDao.updateUser(user);
        // 调用其他服务方法
        userService2.update(user);
        return userDao.findUserById(1);
    }
}

// 服务二
@Service
public class UserService2 {
    @Autowired
    UserDao userDao;

    @Transactional(propagation = Propagation.SUPPORTS)
    public void update(User user){
        user.setUsername("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        user.setId(2);
        userDao.updateUser(user);
    }
}

```

## 3、七种事务传播级别

- TransactionDefinition.PROPAGATION_REQUIRED 支持当前事务，不存在创建新事务
- TransactionDefinition.PROPAGATION_SUPPORTS 支持当前事务，不存在事务以非事务执行
- TransactionDefinition.PROPAGATION_MANDATORY 支持当前事务，不存在抛出异常
- TransactionDefinition.PROPAGATION_REQUIRES_NEW 创建新事务，如果当前存在事务暂停当前事务
- TransactionDefinition.PROPAGATION_NOT_SUPPORTED 以非事务执行，如果当前存在事务暂停当前事务
- TransactionDefinition.PROPAGATION_NEVER 以非事务执行，如果当前存在事务抛出异常
- TransactionDefinition.PROPAGATION_NESTED 嵌套事务，还没搞清楚

## 4、需要与数据库的隔离级别区分清楚

- read uncommitted 读未提交，可能产生“脏读”、“不可重复读”、“幻读”
- read committed 读已提交，可能产生“不可重复读”、“幻读”，同一个事务多次读取同一个字段，读出来的结果可能不一样。另一个事务修改数据已提交。（查询中加锁）
- repeatable read 可重复读，可能产生幻读，解释不清了。
- serializable 序列化，可以避免脏读、不可重复读、幻读。当开销巨大，基本没人使用。