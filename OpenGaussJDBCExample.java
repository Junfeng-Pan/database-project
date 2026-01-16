import java.sql.*;

public class OpenGaussJDBCExample {
    // 数据库连接信息
    static final String JDBC_URL = "jdbc:opengauss://127.0.0.1:26000/campus_test";
    static final String USER = "card_user";
    static final String PASSWORD = "Gauss#3campus";

    public static void main(String[] args) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            // 1. 注册驱动
            Class.forName("org.opengauss.Driver");

            // 2. 建立连接
            conn = DriverManager.getConnection(JDBC_URL, USER, PASSWORD);

            // 3. 设置 Schema
            stmt = conn.createStatement();
            stmt.execute("SET search_path TO campus_test, public;");

            // 4. 执行查询
            String sql = "SELECT id, name, url FROM campus_sites";
            rs = stmt.executeQuery(sql);

            // 5. 输出结果
            System.out.println("✅ 查询结果：");
            System.out.println("ID\tName\t\t\tURL");
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String url = rs.getString("url");
                System.out.println(id + "\t" + name + "\t\t" + url);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 6. 关闭连接
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
