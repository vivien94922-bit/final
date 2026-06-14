<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId != null) {
    out.print("OK");
} else {
    out.print("NO");
}
%>