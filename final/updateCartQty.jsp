<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="dbutil.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) {
    response.setStatus(401);
    out.print("{\"success\":false}");
    return;
}

int cartId = Integer.parseInt(request.getParameter("cart_id"));
int qty = Integer.parseInt(request.getParameter("quantity"));

try (Connection conn = getConnection()) {

    PreparedStatement ps = conn.prepareStatement(
        "UPDATE cart SET quantity=? WHERE cart_id=? AND user_id=?"
    );

    ps.setInt(1, qty);
    ps.setInt(2, cartId);
    ps.setInt(3, userId);
    ps.executeUpdate();

    out.print("{\"success\":true}");

} catch (Exception e) {
    out.print("{\"success\":false}");
}
%>