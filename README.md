# 校园一卡通消费系统数据库设计与实践

## 1. 项目概述

本项目是《数据库系统原理》课程的小组大作业，旨在设计并实现一个完整的**校园一卡通消费系统**数据库。项目涵盖了从需求分析、概念设计、逻辑与物理设计，到数据库实施、SQL 运维实践以及应用开发（Java JDBC）的全流程。

核心功能包括：
*   **用户管理**：学生、教职工的身份信息。
*   **一卡通管理**：发卡、挂失、余额管理。
*   **商户管理**：商户入驻、状态管理。
*   **交易管理**：充值与消费流水记录。

## 2. 环境配置

*   **操作系统**：Linux (openEuler/CentOS ARM架构)
*   **数据库**：openGauss (单机部署)
*   **开发语言**：Java 8
*   **连接驱动**：`opengauss-jdbc-3.0.0.jar`
*   **数据库端口**：`26000`

## 3. 项目结构

```text
/root/database-project/
├── docs/                       # 文档目录
│   ├── 数据库系统原理实践小组大作业.md    # 任务书
│   ├── 数据库初始化操作说明书.md        # 初始化指南
│   ├── 详细实验操作文档.md             # 阶段5-8实验记录
│   ├── 补全约束操作说明.md             # 完整性约束补充说明
│   └── 测试jdbc连接指南.md             # Java开发指南
├── sql/                        # SQL 脚本目录
│   ├── 01_create_database.sql       # 建库与Schema
│   ├── 02_create_tables.sql         # 建表
│   ├── 03_insert_data.sql           # 数据初始化
│   ├── lab_1.4.5_queries.sql        # 复杂查询实验
│   ├── lab_1.4.6_objects.sql        # 视图与索引实验
│   ├── lab_1.4.7_data_mod.sql       # 数据修改实验
│   ├── lab_1.4.8_security.sql       # 安全性实验
│   └── lab_add_constraints.sql      # 补充约束脚本
├── OpenGaussJDBCExample.java   # Java JDBC 测试代码
└── opengauss-jdbc-3.0.0.jar    # JDBC 驱动包
```

## 4. 实施流程

### 4.1 数据库初始化
我们编写了自动化脚本来完成数据库的构建。
```bash
# 1. 拷贝脚本到公共目录
cp sql/*.sql /tmp/sql/ && chmod 777 /tmp/sql/*.sql

# 2. 执行初始化 (创建库、表、插入数据)
su - omm -c "gsql -d postgres -p 26000 -c \"CREATE DATABASE campus_card WITH ENCODING = 'UTF8';\""
su - omm -c "gsql -d campus_card -p 26000 -f /tmp/sql/02_create_tables.sql"
su - omm -c "gsql -d campus_card -p 26000 -f /tmp/sql/03_insert_data.sql"
```

### 4.2 实验与运维
项目完成了以下核心实验：
1.  **复杂查询**：实现了多表连接、聚合统计、半连接/反连接查询。
2.  **对象管理**：创建了消费视图与时间索引，提升了查询效率。
3.  **完整性约束**：通过脚本补充了金额非负约束和外键关联，保证数据质量。
4.  **安全性**：创建了专用业务用户 `card_user` 并实施最小权限控制。

### 4.3 应用开发 (Java JDBC)
我们编写了 Java 程序验证数据库的连通性。

**运行指令**：
```bash
javac -cp opengauss-jdbc-3.0.0.jar OpenGaussJDBCExample.java
java -cp .:opengauss-jdbc-3.0.0.jar OpenGaussJDBCExample
```

**运行结果截图**：
```text
Jan 16, 2026 9:57:01 AM org.opengauss.core.v3.ConnectionFactoryImpl openConnectionImpl
INFO: [127.0.0.1:34580/127.0.0.1:26000] Connection is established. ID: 72b4ece6-aee5-4324-aee6-40636078efba
✅ 查询结果：
ID      Name                    URL
1       openGauss               https://opengauss.org/zh/
2       华为云                  https://www.huaweicloud.com/
3       校园一卡通官网          https://campus-card.edu/
4       高校信息化中心          https://info.edu.cn/
```

## 5. 总结
本项目成功构建了一个符合 3NF 范式的校园一卡通数据库系统，完成了从底层数据存储到上层应用连接的全链路打通。通过大量的 SQL 实践和 openGauss 特性探索（如用户权限、Schema 管理），深入理解了企业级数据库的开发与运维规范。
