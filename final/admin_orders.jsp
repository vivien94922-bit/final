<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 💡 1. 檢查管理員登入權限
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if(isAdmin == null || !isAdmin){
        response.sendRedirect("admin_login.jsp");
        return;
    }
%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%!
private String adminOrderEscapeHtml(String value) {
    if (value == null) return "";
    return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
}
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <title>後台管理中心｜STANDARD DAY</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; display: flex; min-height: 100vh; }
    
    /* 側邊欄樣式 */
    .admin-sidebar { width: 220px; background-color: #222; color: white; padding-top: 20px; }
    .admin-sidebar h2 { text-align: center; font-size: 20px; margin-bottom: 30px; color: #fff; }
    .admin-sidebar ul { list-style: none; padding: 0; margin: 0; }
    .admin-sidebar li { padding: 15px 25px; cursor: pointer; font-weight: bold; transition: 0.2s; border-left: 4px solid transparent; }
    .admin-sidebar li:hover, .admin-sidebar li.active-tab { background-color: #333; border-left: 4px solid #007bff; color: #007bff; }
    
    /* 主要內容區塊 */
    .admin-content { flex: 1; padding: 30px; box-sizing: border-box; }
    .content-section { display: none; }
    .content-section.active { display: block; }
    
    /* 表格與表單共用樣式 */
    .box { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
    table { width: 100%; border-collapse: collapse; background: white; margin-top: 15px; border-radius: 6px; overflow: hidden; }
    th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
    th { background-color: #333; color: white; }
    tr:hover { background-color: #f9f9f9; }
    
    /* 商品管理專用樣式 */
    .form-row { margin-bottom: 12px; display: flex; align-items: center; }
    .form-row label { width: 100px; font-weight: bold; }
    .form-row input { padding: 6px; width: 300px; }
    .prod-img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
    
    /* 按鈕樣式 */
    button { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-right: 5px; }
    .btn-add { background-color: #28a745; color: white; padding: 8px 16px; }
    .btn-edit { background-color: #ffc107; color: #212529; }
    .btn-del { background-color: #dc3545; color: white; }
    .btn-cancel { background-color: #6c757d; color: white; }
    .btn-save { background-color: #007bff; color: white; }
    
    /* 價格突出樣式 */
    .price-text { font-weight: 600; color: #d9534f; }
  </style>
</head>
<body>

  <%
    // 💡 在全頁的最頂端統一開啟一次資料庫連線，變數名稱叫 con
    Connection con = null;
    try {
        con = getConnection();
  %>

  <aside class="admin-sidebar">
    <h2>管理員後台</h2>
    <ul>
      <li id="tab-orders" class="active-tab">訂單管理</li>
      <li onclick="location.href='admin_products.jsp'">商品管理</li>
      <li onclick="location.href='logout.jsp'">登出系統</li>
    </ul>
  </aside>

  <main class="admin-content">

    <section id="section-orders" class="content-section active">
      <h2>訂單管理後台</h2>
      <div class="box">
        <table>
          <thead>
            <tr>
              <th>訂單ID</th>
	              <th>會員ID</th>
	              <th>商品明細</th>
	              <th>收件人</th>
              <th>電話</th>
              <th>地址</th>
              <th>總金額</th>
              <th>付款方式</th>
              <th>狀態</th>
              <th>時間</th>
            </tr>
          </thead>
          <tbody>
            <%
              // 🌟 核心修正：指定撈取確切有的欄位名稱，避免 SELECT * 抓到舊殘留欄位
              String orderSql = "SELECT id, member_id, name, phone, address, total, payment, status, created_at FROM orders ORDER BY id DESC";
              try (PreparedStatement psOrders = con.prepareStatement(orderSql);
                   ResultSet rsOrders = psOrders.executeQuery()) {
                   
                  boolean hasOrders = false;
                  while(rsOrders.next()){
                      hasOrders = true;
                      int memberId = rsOrders.getInt("member_id");
            %>
            <tr>
	              <td># <%= rsOrders.getInt("id") %></td>
	              <td><%= (memberId == 0) ? "訪客結帳" : memberId %></td>
	              <td>
	                <%
	                  boolean hasItems = false;
	                  String itemSql =
	                      "SELECT name, price, quantity, size FROM order_items " +
	                      "WHERE order_id = ? ORDER BY id";
	                  try (PreparedStatement psItems = con.prepareStatement(itemSql)) {
	                      psItems.setInt(1, rsOrders.getInt("id"));
	                      try (ResultSet rsItems = psItems.executeQuery()) {
	                          while (rsItems.next()) {
	                              hasItems = true;
	                              String itemSize = rsItems.getString("size");
	                %>
	                  <div style="margin-bottom:6px;">
	                    <%= adminOrderEscapeHtml(rsItems.getString("name")) %>
	                    <% if (itemSize != null && !itemSize.trim().isEmpty()) { %>
	                      （<%= adminOrderEscapeHtml(itemSize) %>）
	                    <% } %>
	                    × <%= rsItems.getInt("quantity") %>
	                    ／ NT$ <%= rsItems.getInt("price") %>
	                  </div>
	                <%
	                          }
	                      }
	                  }
	                  if (!hasItems) {
	                %>
	                  <span style="color:#888;">舊訂單：無商品明細</span>
	                <% } %>
	              </td>
	              <td><%= adminOrderEscapeHtml(rsOrders.getString("name")) %></td>
	              <td><%= adminOrderEscapeHtml(rsOrders.getString("phone")) %></td>
              <td><%= adminOrderEscapeHtml(rsOrders.getString("address")) %></td>
              <td class="price-text">NT$ <%= rsOrders.getInt("total") %></td>
              <td><%= adminOrderEscapeHtml(rsOrders.getString("payment")) %></td>
              <td><%= adminOrderEscapeHtml(rsOrders.getString("status")) %></td>
              <td><%= adminOrderEscapeHtml(rsOrders.getString("created_at")) %></td>
            </tr>
            <% 
                  }
                  if (!hasOrders) {
	                      out.print("<tr><td colspan='10' style='text-align:center; color:#888; padding:30px;'>目前還沒有任何訂單紀錄。</td></tr>");
                  }
              } 
            %>
          </tbody>
        </table>
      </div>
    </section>

  </main>

  <%
    // 💡 頁面安全關閉連線機制
    } catch(Exception e) {
        out.println("<main class='admin-content'><div class='box' style='color:red; font-weight:bold;'>資料庫發生錯誤：" + e.getMessage() + "</div></main>");
    } finally {
        if(con != null) try { con.close(); } catch(Exception e){}
    }
  %>

  <script src="cookie-consent.js" defer></script>
</body>
</html>
