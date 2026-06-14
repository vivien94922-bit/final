<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");
String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String agreePrivacy = request.getParameter("agree_privacy");
if (!"yes".equals(agreePrivacy)) {
    out.println("<script>alert('請先閱讀並同意隱私權政策'); history.back();</script>");
    return;
}

Connection conn = null;
PreparedStatement ps = null;

try {
    // 統一連線（組員D：DBUtil）
    conn = getConnection();

    // 密碼加鹽雜湊後再儲存（加分：password hash）
    String salt = generateSalt();
    String hashed = hashPassword(password, salt);

    String sql = "INSERT INTO members(username, password, salt, name, email, phone) VALUES(?,?,?,?,?,?)";
    ps = conn.prepareStatement(sql);

    ps.setString(1, username);
    ps.setString(2, hashed);
    ps.setString(3, salt);
    ps.setString(4, name);
    ps.setString(5, email);
    ps.setString(6, phone);

    ps.executeUpdate();

    out.println("<script>alert('註冊成功！請登入'); location.href='login.jsp';</script>");

} catch(Exception e) {
    out.println("<h3>錯誤：</h3>" + e.getMessage());
} finally {
    if(ps != null) try { ps.close(); } catch(Exception e){}
    if(conn != null) try { conn.close(); } catch(Exception e){}
}
%>
