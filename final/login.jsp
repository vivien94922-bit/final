<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<form action="login_process.jsp" method="post">
  帳號：<input type="text" name="username"><br>
  密碼：<input type="password" name="password"><br>
  <button type="submit">登入</button>
</form>
<div onclick="location.href='member.jsp#register'">
  還沒註冊？立即註冊
</div>