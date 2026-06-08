<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.SecureRandom" %>
<%!
    /* =============================================================
     * 全站共用：DB連線 + 密碼雜湊
     * -------------------------------------------------------------
     * 原本以 util.DBUtil / util.PasswordUtil（.java）提供，
     * 因提交限制不可使用 .java / .class，故改以本 JSP 內的宣告區
     * 提供相同功能，各頁面以 <%@ include file="dbutil.jsp" %> 引入。
     * ============================================================= */

    // ===== DB連線（原 DBUtil.java） =====
    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/shopdb"
        + "?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Taipei"
        // MySQL 8/9（caching_sha2_password）でローカル接続するための定番設定
        + "&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USER = "root";
    // ↓ プレースホルダ。各自のローカルMySQLのパスワードに書き換える（コミットしないこと）
    private static final String DB_PASSWORD = "1234";

    public Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // ===== 密碼加鹽 SHA-256（原 PasswordUtil.java） =====
    public String generateSalt() {
        byte[] bytes = new byte[16];
        new SecureRandom().nextBytes(bytes);
        return toHex(bytes);
    }

    public String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            return toHex(md.digest((salt + password).getBytes("UTF-8")));
        } catch (Exception e) {
            throw new RuntimeException("密碼雜湊失敗：" + e.getMessage(), e);
        }
    }

    public boolean verifyPassword(String input, String storedSalt, String storedHash) {
        if (storedSalt == null || storedHash == null) return false;
        return hashPassword(input, storedSalt).equalsIgnoreCase(storedHash);
    }

    private String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(Character.forDigit((b >> 4) & 0xF, 16));
            sb.append(Character.forDigit(b & 0xF, 16));
        }
        return sb.toString();
    }
%>
