<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
    // 1. 【安全性檢查】確認使用者是否真的有登入
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        // 如果沒有登入的 Session，直接踢回首頁
        out.println("<script>alert('請先登入！'); location.href='index.jsp';</script>");
        return; // 結束執行
    }

    // 2. 【防亂碼】設定請求編碼，確保接收到的中文姓名不會變成表意不明的符號
    request.setCharacterEncoding("UTF-8");

    // 3. 【接收參數】從 member.jsp 的表單（Form）依據 input 的 name 屬性抓取資料
    String updatedName = request.getParameter("name");
    String updatedEmail = request.getParameter("email");
    String updatedPhone = request.getParameter("phone");

    // 宣告資料庫必要物件
    Connection conn = null;
    PreparedStatement ps = null;

    try {
        // 4. 【連線】調用組員 D 寫好的連線方法
        conn = getConnection();

        // 5. 【SQL 語法】使用 UPDATE 指令，並用 WHERE id = ? 鎖定當前登入的會員
        String sql = "UPDATE members SET name = ?, email = ?, phone = ? WHERE id = ?";
        ps = conn.prepareStatement(sql);
        
        // 6. 【安全綁定】依序將參數填入問號中，防止 SQL 注入攻擊
        ps.setString(1, updatedName);
        ps.setString(2, updatedEmail);
        ps.setString(3, updatedPhone);
        ps.setInt(4, userId);

        // 7. 【執行】執行資料庫更新，Rows 會回傳被影響的資料筆數
        int rows = ps.executeUpdate();

        if (rows > 0) {
            // 更新成功：彈出通知，並「重導向」回會員中心，加上 #profile 讓前端錨點自動切換到會員資料頁
            out.println("<script>");
            out.println("  alert('已成功修改資料');");
            out.println("  location.href = 'member.jsp#profile';");
            out.println("</script>");
        } else {
            out.println("<script>alert('修改失敗，找不到對應的會員帳號！'); history.back();</script>");
        }

    } catch (Exception e) {
        // 萬一資料庫爆掉（例如 Email 欄位長度超出限制），拋出異常提示
        out.println("<script>alert('系統錯誤：" + e.getMessage() + "'); history.back();</script>");
    } finally {
        // 8. 【釋放資源】不管成功或失敗，一定要關閉資料庫連線，才不會佔用記憶體
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>