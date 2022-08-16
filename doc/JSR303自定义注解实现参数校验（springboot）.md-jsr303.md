# JSR303自定义注解实现参数校验（springboot）

> 可实现功能：

> 避免重复保存

> 参考文章：[Spring Validation最佳实践及其实现原理，参数校验没那么简单！](https://www.cnblogs.com/chentianming/p/13424303.html)

### 0、目录结构

```cmd
$ tree /f /src/main
├─java
│  └─com
│      └─aierx
│          └─jsr303
│              │  App.java
│              ├─controll
│              │      UserController.java
│              ├─dao
│              │      UserDao.java
│              │      UtilDao.java
│              ├─exception
│              │      GlobalControllerAdvice.java
│              ├─model
│              │  └─po
│              │          DecisionPO.java
│              │          UserPO.java
│              ├─util
│              │      Result.java
│              │      StatusCode.java
│              └─validate
│                      VersionCheck.java
│                      VersionCheckValidator.java
└─resources
    │  application.properties
    └─mapper
            UserMapper.xml
            UtilMapper.xml
```

### 1、引入相关依赖文件pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>jsr303</artifactId>
    <version>1.0-SNAPSHOT</version>

    <parent>
        <artifactId>spring-boot-starter-parent</artifactId>
        <groupId>org.springframework.boot</groupId>
        <version>2.2.10.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>2.2.2</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
    </dependencies>

</project>
```

### 2、springboot配置文件

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/aierx?serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=root
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

mybatis.mapper-locations=classpath:mapper/*Mapper.xml
```

### 3、启动文件

```java
@SpringBootApplication
@MapperScan(basePackages = {"com.aierx.jsr303.dao"})
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class);
    }
}
```

### 4、实体类

```java
@Data
@ToString
@AllArgsConstructor
@NoArgsConstructor
@VersionCheck
public class UserPO {
    public int id;
    public String status;
    public String reviewer;
    public String username;
    public String password;
    public int version;
}
```

### 5、工具DAO

```java
@Repository
public interface UtilDao {
    public int getVersionById(@Param("tableName") String tableName,@Param("id") int id);
}
```

### 6、工具mapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.aierx.jsr303.dao.UtilDao">
    <select id="getVersionById" resultType="int">
        select version from ${tableName} where id = #{id}
    </select>
</mapper>
```

### 7、实体DAO

```java
@Repository
public interface UserDao {
    public int getVersionById(int id);

    public int updateUser(UserPO userPO);
}
```

### 8、实体mapper

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.aierx.jsr303.dao.UserDao">
    <insert id="updateUser">
        update db_user set username = #{username},password=#{password},status=#{status},reviewer=#{reviewer},version=version+1;
    </insert>
    <select id="getVersionById" parameterType="int" resultType="int">
        select version from db_user where id = #{id}
    </select>
</mapper>
```

### 9、校验注解

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = VersionCheckValidator.class)
public @interface VersionCheck {

    public String tableName() default "";

    String message() default "该版本已存在，请刷新后保存";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
```

### 10、校验注解具体逻辑实现

```java
public class VersionCheckValidator implements ConstraintValidator<VersionCheck, Object> {

    @Autowired
    UtilDao utilDao;

    private String tableName;

    @Override
    public void initialize(VersionCheck constraintAnnotation) {
        tableName = constraintAnnotation.tableName();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        Method methodGetId = null;
        Method methodGetVersion = null;
        try {
            methodGetId = value.getClass().getMethod("getId");
            int id = (int) methodGetId.invoke(value);
            methodGetVersion = value.getClass().getMethod("getVersion");
            int newVersion = (int) methodGetVersion.invoke(value);
            if (StringUtils.isEmpty(tableName)) {
                String simpleName = value.getClass().getSimpleName();
                tableName = "db_" + simpleName.substring(0, simpleName.length() - 2).toLowerCase();
            }
            int tableVersion = utilDao.getVersionById(tableName, id);
            if (newVersion + 1 > tableVersion) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
```

### 11、全局异常处理

```java
@RestControllerAdvice
public class GlobalControllerAdvice {
    // 1、处理 form data方式调用接口校验失败抛出的异常 
    @ExceptionHandler(BindException.class)
    public Result bindExceptionHandler(BindException e) {
        List<FieldError> fieldErrors = e.getBindingResult().getFieldErrors();
        List<String> collect = fieldErrors.stream()
                .map(DefaultMessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.toList());
        return Result.makeFail("参数校验失败", collect);
    }

    // 2、处理 json 请求体调用接口校验失败抛出的异常
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result methodArgumentNotValidExceptionHandler(MethodArgumentNotValidException e) {
        List<ObjectError> allErrors = e.getBindingResult().getAllErrors();
        List<String> collect = allErrors.stream()
                .map(DefaultMessageSourceResolvable::getDefaultMessage)
                .collect(Collectors.toList());
        return Result.makeFail("参数校验失败", collect);
    }

    // 3、处理单个参数校验失败抛出的异常
    @ExceptionHandler(ConstraintViolationException.class)
    public Result constraintViolationExceptionHandler(ConstraintViolationException e) {
        Set<ConstraintViolation<?>> constraintViolations = e.getConstraintViolations();
        List<String> collect = constraintViolations.stream()
                .map(ConstraintViolation::getMessage)
                .collect(Collectors.toList());
        return Result.makeFail("参数校验失败", collect);
    }
}
```

### 12、统一返回值

```java
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Result {

    private Boolean flag;

    private String message;

    private Object data;
    
    public static Result makeFail(String message){
        return new Result(Boolean.FALSE, message);
    }

    public static Result makeFail(String message,Object data){
        return new Result(Boolean.FALSE, message,data);
    }

    public static Result makeSuccess(String message,Object data){
        return new Result(Boolean.TRUE, message,data);
    }

    public Result(Boolean flag, String message) {
        this.flag = flag;
        this.message = message;
    }
}
```

### 13、统一状态码

```java
public class StatusCode {
    public static final int OK=20000;//成功
    public static final int ERROR =20001;//失败
    public static final int LOGINERROR =20002;//用户名或密码错误
    public static final int ACCESSERROR =20003;//权限不足
    public static final int REMOTEERROR =20004;//远程调用失败
    public static final int REPERROR =20005;//重复操作
}
```