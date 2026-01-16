# openGauss JDBC 连接测试指南

本文档详细说明了如何在 Linux 服务器上配置 Java 环境、准备测试数据库、下载 openGauss JDBC 驱动，并编写 Java 代码连接数据库的完整流程。

## 1. 环境准备

### 1.1 安装 JDK
确保服务器安装了 JDK 1.8 或更高版本。
```bash
# 以 openEuler/CentOS 为例
yum install -y --nogpgcheck java-1.8.0-openjdk-devel

# 验证安装
java -version
javac -version
```

### 1.2 下载 openGauss JDBC 驱动
openGauss 需要专用驱动，不能混用 PostgreSQL 驱动。从 Maven Central 下载：
```bash
wget https://repo1.maven.org/maven2/org/opengauss/opengauss-jdbc/3.0.0/opengauss-jdbc-3.0.0.jar
```

## 2. 数据库准备

### 2.1 创建测试数据库与表
我们需要一个独立的测试库 `campus_test`。请使用 `omm` 用户执行以下 SQL 脚本。

**SQL 脚本内容 (`sql/create_test_db.sql`)**：
```sql
CREATE DATABASE campus_test WITH ENCODING = 'UTF8';
-- 切换连接后执行：
CREATE SCHEMA IF NOT EXISTS campus_test;
SET search_path TO campus_test, public;
CREATE TABLE campus_sites (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    url VARCHAR(100)
);
INSERT INTO campus_sites VALUES (1, 'openGauss', 'https://opengauss.org');
```

**执行命令**：
```bash
# 1. 创建数据库
su - omm -c "gsql -d postgres -p 26000 -c \"CREATE DATABASE campus_test WITH ENCODING = 'UTF8';\""

# 2. 创建表及数据 (注意忽略 'database already exists' 错误)
su - omm -c "gsql -d campus_test -p 26000 -f sql/create_test_db.sql"
```

### 2.2 用户授权
确保测试用户 `card_user` 拥有访问该数据库的权限。
```bash
su - omm -c "gsql -d campus_test -p 26000 -c \"GRANT CONNECT ON DATABASE campus_test TO card_user; GRANT USAGE ON SCHEMA campus_test TO card_user; GRANT SELECT ON TABLE campus_test.campus_sites TO card_user;\""
```

## 3. Java 代码编写

创建文件 `OpenGaussJDBCExample.java`：

```java
import java.sql.*;

public class OpenGaussJDBCExample {
    // 数据库连接配置
    static final String JDBC_URL = "jdbc:opengauss://127.0.0.1:26000/campus_test";
    static final String USER = "card_user";
    static final String PASSWORD = "Gauss#3campus";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // 加载 openGauss 驱动
            Class.forName("org.opengauss.Driver");

            // 建立连接
            System.out.println("正在连接数据库...");
            conn = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);

            // 执行查询
            stmt = conn.createStatement();
            // 确保查询路径包含我们的 schema
            stmt.execute("SET search_path TO campus_test, public;");
            
            String sql = "SELECT id, name, url FROM campus_sites";
            rs = stmt.executeQuery(sql);

            // 输出结果
            System.out.println("✅ 连接成功，查询结果如下：");
            System.out.println("ID\tName\t\tURL");
            while (rs.next()) {
                System.out.println(rs.getInt("id") + "\t" + rs.getString("name") + "\t" + rs.getString("url"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 资源释放
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
}
```

## 4. 编译与运行

在包含 `.java` 文件和 `.jar` 驱动的目录下执行：

### 4.1 编译
```bash
javac -cp opengauss-jdbc-3.0.0.jar OpenGaussJDBCExample.java
```

### 4.2 运行
注意 Linux 下 classpath 分隔符为冒号 `:`。
```bash
java -cp .:opengauss-jdbc-3.0.0.jar OpenGaussJDBCExample
```

### 预期输出
```text
正在连接数据库...
INFO: Connection is established.
✅ 连接成功，查询结果如下：
ID	Name		URL
1	openGauss	https://opengauss.org
...
```

## 5. 常见问题排查
1.  **SCRAM 错误 / Auth 失败**：
    *   确保使用 `opengauss-jdbc` 驱动，而非 `postgresql` 驱动。
    *   检查 `pg_hba.conf` 配置，确保允许 `127.0.0.1` 或本机 IP 连接。
2.  **Schema 找不到**：
    *   确保在 SQL 或 Java 代码中执行了 `SET search_path`。
    *   或者使用全限定名 `campus_test.campus_sites` 访问表。
