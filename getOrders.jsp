<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%@ page import="java.sql.*" %>
<%
    // 管理者權限檢查
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <title>訂單管理</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body { padding: 30px; font-family: sans-serif; }
        h2   { margin-bottom: 20px; }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px 14px;
            text-align: left;
        }
        th { background: #f5f5f5; }
        tr:hover { background: #fafafa; }
        .detail-btn {
            cursor: pointer;
            color: #1a73e8;
            background: none;
            border: none;
            font-size: 14px;
            padding: 0;
        }
        .detail-row { display: none; }
        .detail-row td { background: #f9f9f9; padding: 8px 20px; }
        .detail-row table { width: auto; font-size: 13px; }
        .badge {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 12px;
            font-size: 12px;
            background: #e8f5e9;
            color: #2e7d32;
        }
    </style>
</head>
<body>
    <h2>訂單管理</h2>
    <table id="ordersTable">
        <thead>
            <tr>
                <th>訂單編號</th>
                <th>會員帳號</th>
                <th>實付金額</th>
                <th>狀態</th>
                <th>下單時間</th>
                <th>明細</th>
            </tr>
        </thead>
        <tbody>
<%
    try (Connection conn = getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT o.order_id, m.username, o.total_price, o.status, o.create_time " +
            "FROM orders o JOIN members m ON o.user_id = m.id " +
            "ORDER BY o.create_time DESC");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int    orderId   = rs.getInt("order_id");
            String username  = rs.getString("username");
            int    total     = rs.getInt("total_price");
            String status    = rs.getString("status");
            String createTime= rs.getTimestamp("create_time").toString();
%>
            <tr>
                <td><%= orderId %></td>
                <td><%= username %></td>
                <td>NT$<%= String.format("%,d", total) %></td>
                <td><span class="badge"><%= status %></span></td>
                <td><%= createTime.substring(0, 16) %></td>
                <td>
                    <button class="detail-btn" onclick="toggleDetail(<%= orderId %>)">▶ 展開</button>
                </td>
            </tr>
            <tr class="detail-row" id="detail-<%= orderId %>">
                <td colspan="6">
                    <table>
                        <tr><th>商品名稱</th><th>單價</th><th>數量</th><th>小計</th></tr>
<%
            PreparedStatement itemPs = conn.prepareStatement(
                "SELECT name, price, quantity FROM order_items WHERE order_id=?");
            itemPs.setInt(1, orderId);
            ResultSet itemRs = itemPs.executeQuery();
            while (itemRs.next()) {
                int price = itemRs.getInt("price");
                int qty   = itemRs.getInt("quantity");
%>
                        <tr>
                            <td><%= itemRs.getString("name") %></td>
                            <td>NT$<%= String.format("%,d", price) %></td>
                            <td><%= qty %></td>
                            <td>NT$<%= String.format("%,d", price * qty) %></td>
                        </tr>
<%
            }
%>
                    </table>
                </td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='6'>載入失敗：" + e.getMessage() + "</td></tr>");
    }
%>
        </tbody>
    </table>

    <script>
        function toggleDetail(orderId) {
            const row = document.getElementById('detail-' + orderId);
            const btn = row.previousElementSibling.querySelector('.detail-btn');
            if (row.style.display === 'table-row') {
                row.style.display = 'none';
                btn.textContent = '▶ 展開';
            } else {
                row.style.display = 'table-row';
                btn.textContent = '▼ 收合';
            }
        }
    </script>
</body>
</html>
