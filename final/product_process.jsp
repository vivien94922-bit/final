<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("admin_login.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        conn = getConnection();

        // ==================== 動作一：新增上架 ====================
        if ("insert".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String img = request.getParameter("img");
            
            int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

            String sql = "INSERT INTO product (name, price, image) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, img);
            ps.executeUpdate();
            
            out.println("<script>alert('商品上架成功！'); location.href='admin_products.jsp';</script>");
        }

        // ==================== 動作二：修改更新 ====================
        else if ("update".equals(action)) {
            String pIdStr = request.getParameter("p_id");
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String img = request.getParameter("img");

            int pId = Integer.parseInt(pIdStr);
            int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

            String sql = "UPDATE product SET name = ?, price = ?, image = ? WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, price);
            ps.setString(3, img);
            ps.setInt(4, pId);
            ps.executeUpdate();

            out.println("<script>alert('商品修改成功！'); location.href='admin_products.jsp';</script>");
        }

        // ==================== 動作三：刪除產品 ====================
        else if ("delete".equals(action)) {
            String pIdStr = request.getParameter("p_id");
            int pId = Integer.parseInt(pIdStr);

            String sql = "DELETE FROM product WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, pId);
            ps.executeUpdate();

            out.println("<script>alert('商品已成功刪除！'); location.href='admin_products.jsp';</script>");
        }

    } catch (Exception e) {
        out.println("<script>alert('作業失敗：" + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
