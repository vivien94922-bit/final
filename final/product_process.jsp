<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
if (isAdmin == null || !isAdmin) {
    response.sendRedirect("admin_login.jsp");
    return;
}
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendError(405);
    return;
}
request.setCharacterEncoding("UTF-8");
String action = request.getParameter("action");
try (Connection conn = getConnection()) {
    if ("insert".equals(action) || "update".equals(action)) {
        String name = request.getParameter("name");
        String image = request.getParameter("img");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        int price = Integer.parseInt(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        name = name == null ? "" : name.trim();
        image = image == null ? "" : image.trim();
        description = description == null ? "" : description.trim();
        if (name.isEmpty() || name.length() > 100 || image.length() > 255
                || description.length() > 5000 || price < 0 || stock < 0
                || (!"tops".equals(category) && !"bottoms".equals(category))) {
            throw new IllegalArgumentException("商品資料格式不正確");
        }
        if ("insert".equals(action)) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO product(name,price,image,description,category,stock) VALUES(?,?,?,?,?,?)")) {
                ps.setString(1, name);
                ps.setInt(2, price);
                ps.setString(3, image);
                ps.setString(4, description);
                ps.setString(5, category);
                ps.setInt(6, stock);
                ps.executeUpdate();
            }
        } else {
            int productId = Integer.parseInt(request.getParameter("p_id"));
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE product SET name=?,price=?,image=?,description=?,category=?,stock=? WHERE id=?")) {
                ps.setString(1, name);
                ps.setInt(2, price);
                ps.setString(3, image);
                ps.setString(4, description);
                ps.setString(5, category);
                ps.setInt(6, stock);
                ps.setInt(7, productId);
                if (ps.executeUpdate() != 1) throw new IllegalArgumentException("找不到商品");
            }
        }
    } else if ("delete".equals(action)) {
        int productId = Integer.parseInt(request.getParameter("p_id"));
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM product WHERE id=?")) {
            ps.setInt(1, productId);
            if (ps.executeUpdate() != 1) throw new IllegalArgumentException("找不到商品");
        }
    } else {
        throw new IllegalArgumentException("不支援的操作");
    }
    response.sendRedirect("admin_products.jsp");
} catch (Exception e) {
    out.println("<script>alert('作業失敗：" + e.getMessage() + "'); history.back();</script>");
}
%>
