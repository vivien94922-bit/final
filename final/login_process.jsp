<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%@ page import="util.PasswordUtil" %>
<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");

if(username == null || password == null){
    out.println("<script>alert('請輸入帳密'); history.back();</script>");
    return;
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
boolean ok = false;

try {
    // 統一連線（組員D：DBUtil）
    conn = DBUtil.getConnection();

    // 只用帳號查詢，再以加鹽 SHA-256 比對密碼（不再比對明文）
    String sql = "SELECT id, username, password, salt FROM members WHERE username=?";
    ps = conn.prepareStatement(sql);
    ps.setString(1, username);

    rs = ps.executeQuery();

    if(rs.next()){
        String storedHash = rs.getString("password");
        String storedSalt = rs.getString("salt");

        if(PasswordUtil.verify(password, storedSalt, storedHash)){
            ok = true;
            session.setAttribute("user_id", rs.getInt("id"));
            session.setAttribute("username", rs.getString("username"));
            session.setAttribute("isLogin", "true");
        }
    }
} catch(Exception e){
    out.println("錯誤：" + e.getMessage());
} finally {
    if(rs != null) try { rs.close(); } catch(Exception e){}
    if(ps != null) try { ps.close(); } catch(Exception e){}
    if(conn != null) try { conn.close(); } catch(Exception e){}
}

if(ok){
    response.sendRedirect("member.jsp");
} else {
    out.println("<script>alert('登入失敗'); history.back();</script>");
}
%>
