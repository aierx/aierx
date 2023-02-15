>[MySql+webService cxf+json 简单框架（转） - shenming - 博客园 (cnblogs.com)](https://www.cnblogs.com/shenming/p/4560871.html)

>[aierx/qr - 码云 - 开源中国 (gitee.com)](https://gitee.com/aierx/qr)

# 项目结构

```
├─java
│  └─org
│      └─example
│          │  Server.java
│          │  WSClient.java
│          ├─model
│          │      User.java
│          └─service
│              ├─rs
│              │      IUserService.java
│              │      UserService.java
│              └─ws
│                      IUserWebService.java
│                      UserWebService.java
└─resources
```

# pom.xml配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>cxf-jetty</artifactId>
    <version>1.0-SNAPSHOT</version>

    <parent>
        <artifactId>spring-boot-starter-parent</artifactId>
        <groupId>org.springframework.boot</groupId>
        <version>2.2.10.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.apache.cxf</groupId>
            <artifactId>cxf-rt-frontend-jaxrs</artifactId>
            <version>4.0.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.apache.cxf</groupId>
            <artifactId>cxf-rt-frontend-jaxws</artifactId>
            <version>4.0.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.apache.cxf</groupId>
            <artifactId>cxf-rt-transports-http-jetty</artifactId>
            <version>4.0.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.codehaus.jettison</groupId>
            <artifactId>jettison</artifactId>
            <version>1.4.1</version>
        </dependency>
        <dependency>
            <groupId>org.apache.cxf</groupId>
            <artifactId>cxf-rt-rs-extension-providers</artifactId>
            <version>4.0.0-SNAPSHOT</version>
            <scope>compile</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-web</artifactId>
            <version>5.2.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
            <version>5.2.9.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-aop</artifactId>
            <version>5.2.9.RELEASE</version>
        </dependency>
    </dependencies>
</project>
```

# 实体文件

```java
package org.example.model;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "User")
public class User {

    String username;

    String password;

    public User() {
    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}
```

# rs服务接口

```java
package org.example.service.rs;


import org.example.model.User;

import javax.ws.rs.*;

@Path("/user")
@Produces("application/json")
@Consumes("application/json")
public interface IUserService {
    @GET
    @Path("/{id}")
    public User getUserById(@PathParam("id")int id) ;
}
```

# rs服务实现

```java
package org.example.service.rs;


import org.example.model.User;

public class UserService  implements IUserService{

    @Override
    public User getUserById(int id) {
        return new User("leiwenyong","1231231231");
    }
}
```

# ws服务接口

```java
package org.example.service.ws;

import org.example.model.User;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface IUserWebService {

    @WebMethod
    public User getUser(int id);
}
```

# ws服务实现

```java
package org.example.service.ws;

import org.example.model.User;

import javax.jws.WebService;

@WebService(serviceName = "user",endpointInterface = "org.example.service.ws.IUserWebService")
public class UserWebService implements IUserWebService{
    @Override
    public User getUser(int id) {
        System.out.println(id);
        return new User("leiwenyong","12321321313");
    }
}
```

# 服务启动类

```java
package org.example;

import org.apache.cxf.feature.LoggingFeature;
import org.apache.cxf.jaxrs.JAXRSServerFactoryBean;
import org.apache.cxf.jaxws.JaxWsServerFactoryBean;
import org.example.service.rs.UserService;
import org.example.service.ws.UserWebService;

import java.util.Collections;

public class Server {
    public static void main(String[] args) {
        // restful
        JAXRSServerFactoryBean rsServerBean = new JAXRSServerFactoryBean();
        rsServerBean.setAddress("http://localhost:8080/rs");
        rsServerBean.setServiceBean(new UserService());
        rsServerBean.setFeatures(Collections.singletonList(new LoggingFeature()));
        rsServerBean.create();
        // webservice
        JaxWsServerFactoryBean wsServerBean = new JaxWsServerFactoryBean();
        wsServerBean.setAddress("http://localhost:8080/ws");
        wsServerBean.setFeatures(Collections.singletonList(new LoggingFeature()));
        wsServerBean.setServiceBean(new UserWebService());
        wsServerBean.create();
    }
}
```

# 客户端启动类

```java
package org.example;

import org.apache.cxf.feature.LoggingFeature;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.example.service.ws.IUserWebService;

import java.util.Collections;

public class WSClient {
    public static void main(String[] args) {
        JaxWsProxyFactoryBean jaxWsProxyFactoryBean = new JaxWsProxyFactoryBean();
        jaxWsProxyFactoryBean.setAddress("http://localhost:8080/ws");
        jaxWsProxyFactoryBean.setServiceClass(IUserWebService.class);
        jaxWsProxyFactoryBean.setFeatures(Collections.singletonList(new LoggingFeature()));
        IUserWebService webService = (IUserWebService)jaxWsProxyFactoryBean.create();
        System.out.println(webService.getUser(10));
    }
}
```