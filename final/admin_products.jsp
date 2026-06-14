<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>
<%
Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
if (isAdmin == null || !isAdmin) {
    response.sendRedirect("admin_login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>後台商品管理系統</title>
<style>
body{font-family:Arial,sans-serif;margin:30px;background:#f4f4f4}
.box{background:#fff;padding:20px;border-radius:8px;margin-bottom:30px;box-shadow:0 2px 5px rgba(0,0,0,.1)}
.form-grid{display:grid;grid-template-columns:120px minmax(240px,1fr);gap:10px;align-items:center;max-width:720px}
.form-grid label{font-weight:bold}
.form-grid input,.form-grid select,.form-grid textarea,.edit-fields input,.edit-fields select,.edit-fields textarea{padding:7px;box-sizing:border-box;width:100%}
table{width:100%;border-collapse:collapse;background:#fff}
th,td{padding:10px;border-bottom:1px solid #ddd;text-align:left;vertical-align:top}
th{background:#333;color:#fff}.prod-img{width:60px;height:60px;object-fit:cover;border-radius:4px}
button{padding:7px 12px;border:0;border-radius:4px;cursor:pointer;font-weight:bold;margin:3px}
.btn-add{background:#28a745;color:#fff;margin-top:15px}.btn-edit{background:#ffc107}.btn-del{background:#dc3545;color:#fff}
.btn-save{background:#007bff;color:#fff}.btn-cancel{background:#6c757d;color:#fff}
.edit-fields{display:grid;gap:6px;min-width:280px}
</style>
</head>
<body>
<h2>後台管理系統 - 商品管理</h2>
<p><a href="admin_orders.jsp">前往瀏覽訂單</a></p>
<div class="box">
  <h3>上架新商品</h3>
  <form action="product_process.jsp" method="post">
    <input type="hidden" name="action" value="insert">
    <div class="form-grid">
      <label>商品名稱</label><input type="text" name="name" maxlength="100" required>
      <label>商品價格</label><input type="number" name="price" min="0" required>
      <label>庫存數量</label><input type="number" name="stock" min="0" required>
      <label>商品分類</label>
      <select name="category" required><option value="tops">上裝</option><option value="bottoms">下裝</option></select>
      <label>圖片路徑</label><input type="text" name="img" maxlength="255" required placeholder="../images/example.jpg">
      <label>商品描述</label><textarea name="description" rows="4" maxlength="5000"></textarea>
    </div>
    <button type="submit" class="btn-add">確認上架商品</button>
  </form>
</div>
<div class="box">
<h3>現有商品列表</h3>
<table>
<thead><tr><th>圖片</th><th>ID</th><th>商品資料 / 編輯欄位</th><th>價格 / 庫存</th><th>操作</th></tr></thead>
<tbody>
<%
try (Connection conn = getConnection();
     PreparedStatement ps = conn.prepareStatement(
         "SELECT id,name,price,image,description,category,stock FROM product ORDER BY id DESC");
     ResultSet rs = ps.executeQuery()) {
    while (rs.next()) {
        int id = rs.getInt("id");
        String name = rs.getString("name");
        String image = rs.getString("image");
        String description = rs.getString("description");
        String category = rs.getString("category");
%>
<tr>
  <td><img src="<%=escapeHtml(image)%>" alt="" class="prod-img"></td>
  <td><%=id%></td>
  <td>
    <div class="view-mode-<%=id%>">
      <b><%=escapeHtml(name)%></b><br>
      <span><%="tops".equals(category) ? "上裝" : "下裝"%></span><br>
      <small><%=escapeHtml(description)%></small>
    </div>
    <form action="product_process.jsp" method="post" id="form-<%=id%>" class="edit-fields" style="display:none;">
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="p_id" value="<%=id%>">
      <input type="text" name="name" value="<%=escapeHtml(name)%>" maxlength="100" required>
      <select name="category" required>
        <option value="tops" <%if("tops".equals(category)){%>selected<%}%>>上裝</option>
        <option value="bottoms" <%if("bottoms".equals(category)){%>selected<%}%>>下裝</option>
      </select>
      <input type="text" name="img" value="<%=escapeHtml(image)%>" maxlength="255" required>
      <textarea name="description" rows="4" maxlength="5000"><%=escapeHtml(description)%></textarea>
      <input type="number" name="price" value="<%=rs.getInt("price")%>" min="0" required>
      <input type="number" name="stock" value="<%=rs.getInt("stock")%>" min="0" required>
    </form>
  </td>
  <td><div class="view-mode-<%=id%>">NT$ <%=rs.getInt("price")%><br>庫存：<%=rs.getInt("stock")%></div></td>
  <td>
    <div class="view-mode-<%=id%>">
      <button type="button" class="btn-edit" onclick="enterEditMode(<%=id%>)">修改</button>
      <form action="product_process.jsp" method="post" style="display:inline;" onsubmit="return confirmDelete();">
        <input type="hidden" name="action" value="delete"><input type="hidden" name="p_id" value="<%=id%>">
        <button type="submit" class="btn-del">刪除</button>
      </form>
    </div>
    <div class="edit-mode-<%=id%>" style="display:none;">
      <button type="button" class="btn-save" onclick="submitEdit(<%=id%>)">儲存</button>
      <button type="button" class="btn-cancel" onclick="cancelEditMode(<%=id%>)">取消</button>
    </div>
  </td>
</tr>
<%
    }
} catch (Exception e) {
    out.println("<tr><td colspan='5'>載入失敗：" + e.getMessage() + "</td></tr>");
}
%>
</tbody>
</table>
</div>
<script>
function enterEditMode(id){document.querySelectorAll('.view-mode-'+id).forEach(el=>el.style.display='none');document.querySelectorAll('.edit-mode-'+id).forEach(el=>el.style.display='block');document.getElementById('form-'+id).style.display='grid'}
function cancelEditMode(id){document.querySelectorAll('.view-mode-'+id).forEach(el=>el.style.display='block');document.querySelectorAll('.edit-mode-'+id).forEach(el=>el.style.display='none');document.getElementById('form-'+id).style.display='none'}
function submitEdit(id){document.getElementById('form-'+id).submit()}
function confirmDelete(){return confirm("確定刪除這件商品嗎？訂單明細會保留，其餘關聯資料會一併刪除。")}
</script>
<script src="cookie-consent.js" defer></script>
</body>
</html>
