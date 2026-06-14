<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.setStatus(401);
        return;
    }
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405);
        return;
    }

    int productId;
    try {
        productId = Integer.parseInt(request.getParameter("product_id"));
        if (productId <= 0) throw new NumberFormatException();
    } catch (Exception e) {
        response.setStatus(400);
        return;
    }

    try (Connection con = getConnection();
         PreparedStatement psCheck = con.prepareStatement(
             "SELECT id FROM favorites WHERE member_id = ? AND product_id = ?")) {
        psCheck.setInt(1, userId);
        psCheck.setInt(2, productId);
        try (ResultSet rs = psCheck.executeQuery()) {
            if (rs.next()) {
                try (PreparedStatement psDel = con.prepareStatement(
                        "DELETE FROM favorites WHERE member_id = ? AND product_id = ?")) {
                    psDel.setInt(1, userId);
                    psDel.setInt(2, productId);
                    psDel.executeUpdate();
                }
                out.print("remove");
            } else {
                try (PreparedStatement psIns = con.prepareStatement(
                        "INSERT INTO favorites (member_id, product_id) VALUES (?, ?)")) {
                    psIns.setInt(1, userId);
                    psIns.setInt(2, productId);
                    psIns.executeUpdate();
                }
                out.print("add");
            }
        }
    }
%>
