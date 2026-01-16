# 校园一卡通系统 Java 开发指导文档 (Spring Boot + MyBatis-Plus)

## 1. 项目概述
本文档旨在指导开发人员基于 **Spring Boot**、**Maven** 和 **MyBatis-Plus** 框架，开发连接 openGauss 数据库的校园一卡通消费系统。文档涵盖了项目环境搭建、数据库结构说明、核心配置以及代码开发规范。

## 2. 技术栈
*   **开发语言**: Java 17+ (推荐)
*   **构建工具**: Maven 3.6+
*   **Web 框架**: Spring Boot 3.x
*   **ORM 框架**: MyBatis-Plus 3.5.x
*   **数据库**: openGauss (兼容 PostgreSQL 协议，但建议使用原生驱动)
*   **连接池**: HikariCP (Spring Boot 默认)

## 3. 数据库结构说明
项目数据库名为 `campus_card`，核心表位于 `campus` Schema 下。

### 3.1 实体关系图 (ER)
*   **Users (用户)** 1:1 **Cards (一卡通)**
*   **Users (用户)** 1:N **Cards (一卡通)** (逻辑上是一对一，设计上通过 `UNIQUE` 约束保证)
*   **Cards (一卡通)** 1:N **Recharge_Records (充值记录)**
*   **Cards (一卡通)** 1:N **Consumption_Records (消费记录)**
*   **Merchants (商户)** 1:N **Consumption_Records (消费记录)**

### 3.2 核心数据表
| 表名 (Table) | 实体类名 (Entity) | 主键 | 描述 |
| :--- | :--- | :--- | :--- |
| `campus.users` | `User` | `user_id` | 用户基本信息（姓名、身份证、类型等） |
| `campus.cards` | `Card` | `card_no` | 一卡通账户信息（余额、状态、开卡时间） |
| `campus.merchants` | `Merchant` | `merchant_id` | 商户信息（名称、地址、营业状态） |
| `campus.recharge_records` | `RechargeRecord` | `recharge_id` | 充值流水（关联卡号） |
| `campus.consumption_records` | `ConsumptionRecord` | `consumption_id` | 消费流水（关联卡号和商户） |

## 4. 项目配置指南

### 4.1 Maven 依赖 (`pom.xml`)
需要在 `dependencies` 中添加 openGauss 驱动和 MyBatis-Plus 启动器。

```xml
<dependencies>
    <!-- Web Starter -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <!-- MyBatis-Plus Starter -->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>3.5.3.1</version> <!-- 请检查最新版本 -->
    </dependency>

    <!-- openGauss JDBC Driver -->
    <!-- 注意：若中央仓库无此依赖，需手动导入或配置华为镜像源 -->
    <dependency>
        <groupId>org.opengauss</groupId>
        <artifactId>opengauss-jdbc</artifactId>
        <version>3.0.0</version>
        <scope>runtime</scope>
    </dependency>

    <!-- Lombok (可选，简化实体类) -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

### 4.2 配置文件 (`application.yml`)
配置数据库连接信息和 MyBatis-Plus 策略。

```yaml
server:
  port: 8080

spring:
  datasource:
    # 替换为你的云服务器公网IP
    url: jdbc:opengauss://<YOUR_SERVER_IP>:26000/campus_card?currentSchema=campus
    username: card_user
    password: Gauss#3campus
    driver-class-name: org.opengauss.Driver
    type: com.zaxxer.hikari.HikariDataSource
    hikari:
      minimum-idle: 5
      maximum-pool-size: 15
      idle-timeout: 30000
      pool-name: CampusCardHikariCP

mybatis-plus:
  # 实体类扫描包路径
  type-aliases-package: com.example.campus.entity
  configuration:
    # 开启驼峰命名转换 (users_id -> userId)
    map-underscore-to-camel-case: true
    # 打印 SQL 日志 (开发环境开启)
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      # 默认主键生成策略 (根据表结构选择，这里设为自增)
      id-type: auto
      # 逻辑删除字段 (如有)
      # logic-delete-value: 1
      # logic-not-delete-value: 0
```

## 5. 开发规范与示例

### 5.1 实体类 (Entity)
使用 MyBatis-Plus 注解映射表结构。

```java
package com.example.campus.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 用户实体
 */
@Data
@TableName(value = "users", schema = "campus") // 指定Schema
public class User {
    @TableId(type = IdType.AUTO)
    private Integer userId;
    private String name;
    private String identityNo;
    private String phone;
    private String email;
    private String password;
    private String userType;
}

/**
 * 消费记录实体
 */
@Data
@TableName(value = "consumption_records", schema = "campus")
public class ConsumptionRecord {
    @TableId(type = IdType.AUTO)
    private Long consumptionId;
    private String cardNo;
    private Integer merchantId;
    private BigDecimal amount;
    private LocalDateTime consumeTime;
}
```

### 5.2 Mapper 接口
继承 `BaseMapper` 以获取 CRUD 能力。

```java
package com.example.campus.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.campus.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper extends BaseMapper<User> {
    // 可在此定义自定义 SQL 查询
}
```

### 5.3 Service 层
建议继承 `IService` 和 `ServiceImpl`。

```java
package com.example.campus.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.campus.entity.User;

public interface UserService extends IService<User> {
    // 业务方法定义
}
```

### 5.4 Controller 层 (Rest API)

```java
package com.example.campus.controller;

import com.example.campus.entity.User;
import com.example.campus.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public List<User> getAllUsers() {
        return userService.list();
    }

    @GetMapping("/{id}")
    public User getUserById(@PathVariable Integer id) {
        return userService.getById(id);
    }
}
```

## 6. 注意事项
1.  **Schema 设置**: openGauss 中我们的表在 `campus` 模式下，务必在 `application.yml` 的 URL 中指定 `currentSchema=campus`，或者在实体类 `@TableName` 中显式指定 `schema = "campus"`。
2.  **驱动兼容性**: 请确保使用的 `opengauss-jdbc` 版本与服务器端的 openGauss 版本兼容。
3.  **主键策略**: 数据库中 `users`, `merchants` 使用了 `SERIAL` (自增)，实体类中 `@TableId` 应设为 `AUTO`。`cards` 表主键为字符串（卡号），应设为 `INPUT` 或 `NONE`（手动赋值）。

## 7. 启动与验证
1.  在 IDEA 中启动 Spring Boot 应用。
2.  观察控制台日志，确认连接池初始化成功。
3.  使用 Postman 或浏览器访问 `http://localhost:8080/api/users`，若能返回 JSON 格式的用户列表，说明集成成功。
