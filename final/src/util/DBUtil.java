package util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * 全站統一的資料庫連線工具。
 *
 * 整合說明（組員D）：
 *   原本各 JSP 各自以 DriverManager 內嵌連線，且資料庫分散在
 *   clothing_shop / counter / shopdb 三個 DB。現已全部統一到單一資料庫
 *   shopdb，並由本類別集中管理連線字串與帳密，避免重複與不一致。
 *
 *   連線參數統一加上：
 *     useUnicode=true&characterEncoding=UTF-8 → 確保中文正確
 *     serverTimezone=Asia/Taipei            → 留言時間等時區一致
 */
public class DBUtil {

    private static final String URL =
        "jdbc:mysql://localhost:3306/shopdb"
        + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Taipei";

    private static final String USER = "root";
    private static final String PASSWORD = "1234";

    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
