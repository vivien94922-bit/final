<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>會員註冊</title>
</head>
<body>

<h2>會員註冊</h2>

<form action="register_process.jsp" method="post">
  帳號：<input type="text" name="username" required><br><br>
  密碼：<input type="password" name="password" required><br><br>
  姓名：<input type="text" name="name" required><br><br>
  Email：<input type="email" name="email" required><br><br>
  電話：<input type="text" name="phone" required><br><br>

  <button type="submit">註冊</button>
</form>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");
String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");

Connection conn = null;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/shopdb?useUnicode=true&characterEncoding=UTF-8",
        "root",
        "你的密碼"
    );

    String sql = "INSERT INTO members(username, password, name, email, phone) VALUES(?,?,?,?,?)";
    PreparedStatement ps = conn.prepareStatement(sql);

    ps.setString(1, username);
    ps.setString(2, password);
    ps.setString(3, name);
    ps.setString(4, email);
    ps.setString(5, phone);

    ps.executeUpdate();

    out.println("<script>alert('註冊成功！請登入'); location.href='login.jsp';</script>");

} catch(Exception e) {
    out.println("錯誤：" + e.getMessage());
} finally {
    if(conn != null) conn.close();
}
%>