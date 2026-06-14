<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <title>後台商品管理系統</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 30px; background-color: #f4f4f4; }
    h2, h3 { color: #333; }
    .box { background: white; padding: 20px; border-radius: 8px; margin-bottom: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .form-row { margin-bottom: 12px; display: flex; align-items: center; }
    .form-row label { width: 100px; font-weight: bold; }
    .form-row input { padding: 6px; width: 300px; }
    
    /* 表格樣式 */
    table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: left; }
    th { background-color: #333; color: white; }
    tr:hover { background-color: #f9f9f9; }
    .prod-img { width: 60px; height: 60px; object-fit: cover; border-radius: 4px; }
    
    /* 按鈕樣式 */
    button { padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-right: 5px; }
    .btn-add { background-color: #28a745; color: white; padding: 8px 16px; }
    .btn-edit { background-color: #ffc107; color: #212529; }
    .btn-del { background-color: #dc3545; color: white; }
    .btn-cancel { background-color: #6c757d; color: white; }
    .btn-save { background-color: #007bff; color: white; }
  </style>
</head>
<body>

  <h2>後台管理系統 - 商品管理</h2>
  <p><a href="admin_orders.jsp">➔ 前往瀏覽訂單</a></p>

  <div class="box">
    <h3>上架新商品</h3>
    <form action="product_process.jsp" method="post">
      <input type="hidden" name="action" value="insert">
      
      <div class="form-row">
        <label>商品名稱</label>
        <input type="text" name="name" required placeholder="例如：純棉極簡老帽">
      </div>
      <div class="form-row">
        <label>商品價格</label>
        <input type="number" name="price" required placeholder="例如：450">
      </div>
      <div class="form-row">
        <label>圖片路徑</label>
        <input type="text" name="img" required placeholder="例如：images/hat.png">
      </div>
      
      <button type="submit" class="btn-add">確認上架商品</button>
    </form>
  </div>

  <div class="box">
    <h3>現有商品列表</h3>
    <table>
      <thead>
        <tr>
          <th width="10%">圖片</th>
          <th width="10%">ID</th>
          <th width="40%">商品名稱</th>
          <th width="15%">價格</th>
          <th width="25%">操作動作</th>
        </tr>
      </thead>
      <tbody>
        <%
          Connection conn = null;
          PreparedStatement ps = null;
          ResultSet rs = null;
          try {
              conn = getConnection();
              String sql = "SELECT id, name, price, img FROM products ORDER BY id DESC";
              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery();
              
              while(rs.next()) {
                  String id = rs.getString("id");
                  String name = rs.getString("name");
                  int price = rs.getInt("price");
                  String img = rs.getString("img");
        <%
        %>
                  <tr id="row-<%= id %>">
                    
                    <td><img src="<%= (img != null && !img.isEmpty()) ? img : "images/no-image.png" %>" class="prod-img"></td>
                    
                    <td><%= id %></td>
                    
                    <td>
                      <span class="view-mode-<%= id %>"><%= name %></span>
                      
                      <form action="product_process.jsp" method="post" id="form-<%= id %>" style="display:none; margin:0;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="p_id" value="<%= id %>">
                        <input type="text" name="name" value="<%= name %>" style="width:90%; padding:4px;" required>
                    </td>
                    
                    <td>
                      <span class="view-mode-<%= id %>">NT$ <%= price %></span>
                        <input type="number" name="price" value="<%= price %>" style="width:70px; padding:4px; margin-top:4px;" required>
                        <input type="text" name="img" value="<%= img %>" style="width:90%; padding:4px; margin-top:4px;" placeholder="圖片路徑" required>
                      </form> </td>
                    
                    <td>
                      <div class="view-mode-<%= id %>">
                        <button type="button" class="btn-edit" onclick="enterEditMode('<%= id %>')">修改</button>
                        <button type="button" class="btn-del" onclick="confirmDelete('<%= id %>')">刪除</button>
                      </div>
                      
                      <div class="edit-mode-<%= id %>" style="display:none;">
                        <button type="button" class="btn-save" onclick="submitEdit('<%= id %>')">儲存</button>
                        <button type="button" class="btn-cancel" onclick="cancelEditMode('<%= id %>')">取消</button>
                      </div>
                    </td>

                  </tr>
        <%
              }
          } catch(Exception e) {
              out.println("<tr><td colspan='5'>載入失敗：" + e.getMessage() + "</td></tr>");
          } finally {
              if (rs != null) try { rs.close(); } catch (Exception e) {}
              if (ps != null) try { ps.close(); } catch (Exception e) {}
              if (conn != null) try { conn.close(); } catch (Exception e) {}
          }
        %>
      </tbody>
    </table>
  </div>

  <script>
    // 進入修改模式：把這一列的純文字藏起來，把 Form 裡面的 Input 秀出來
    function enterEditMode(id) {
      document.querySelectorAll('.view-mode-' + id).forEach(el => el.style.display = 'none');
      document.querySelectorAll('.edit-mode-' + id).forEach(el => el.style.display = 'inline-block');
      document.getElementById('form-' + id).style.display = 'block';
    }

    // 取消修改模式：直接還原
    function cancelEditMode(id) {
      document.querySelectorAll('.view-mode-' + id).forEach(el => el.style.display = 'inline');
      document.querySelectorAll('.edit-mode-' + id).forEach(el => el.style.display = 'none');
      document.getElementById('form-' + id).style.display = 'none';
    }

    // 點擊儲存：去觸發內嵌在 <td> 裡面的 Form 表單送出
    function submitEdit(id) {
      document.getElementById('form-' + id).submit();
    }

    // 刪除確認
    function confirmDelete(pId) {
      if (confirm("🚨 您確定要徹底刪除這件商品嗎？\n此動作將無法還原！")) {
        // 透過 GET 傳遞 action 和 p_id 給後端處理頁
        location.href = "product_process.jsp?action=delete&p_id=" + pId;
      }
    }
  </script>
</body>
</html>