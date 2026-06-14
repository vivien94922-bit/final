<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
session.invalidate();
%>

<p>已成功登出，1 秒後返回首頁...</p>

<script>
setTimeout(() => {
    location.href = "index.jsp";
}, 1000);
</script>