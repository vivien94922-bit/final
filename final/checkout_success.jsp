<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String orderId = "------";
    try {
        int parsedOrderId = Integer.parseInt(request.getParameter("order_id"));
        if (parsedOrderId > 0) orderId = String.valueOf(parsedOrderId);
    } catch (Exception ignored) {
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>STANDARD DAY | 感謝您的購買</title>
    <link rel="stylesheet" href="style.css">
    
    <style>
        /* ===== 成功頁面專屬極簡視覺 ===== */
        body {
            background-image: none !important; /* 拔除首頁滿版背景圖 */
            background-color: #fafafa !important;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .success-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }

        .success-card {
            background: #ffffff;
            max-width: 480px;
            width: 100%;
            padding: 50px 40px;
            border-radius: 8px;
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.02);
            text-align: center;
            box-sizing: border-box;
            
            /* 輕微滑入動畫 */
            animation: slideUp 0.6s ease-out forwards;
        }

        /* 成功打勾圖示動畫 */
        .success-icon {
            width: 72px;
            height: 72px;
            background-color: #000000; /* 品牌時尚黑 */
            color: #ffffff;
            font-size: 36px;
            line-height: 72px;
            border-radius: 50%;
            margin: 0 auto 30px auto;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: scaleIn 0.4s 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
        }

        .success-card h1 {
            font-size: 24px;
            font-weight: 600;
            color: #000000;
            margin: 0 0 12px 0;
            letter-spacing: 2px;
        }

        .success-card p {
            font-size: 14px;
            color: #666666;
            line-height: 1.6;
            margin: 0 0 30px 0;
        }

        /* 訂單資訊區塊 */
        .order-info-box {
            background-color: #fcfcfc;
            border: 1px solid #eeeeee;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 40px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            margin-bottom: 8px;
        }
        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            color: #888888;
        }

        .info-value {
            color: #000000;
            font-weight: 600;
            letter-spacing: 0.5px;
        }

        /* 底部按鈕按鈕群組 */
        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .btn-primary {
            background: #000000;
            color: #ffffff;
            border: 1px solid #000000;
            padding: 14px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background: #ffffff;
            color: #000000;
        }

        .btn-secondary {
            background: #ffffff;
            color: #666666;
            border: 1px solid #e5e5e5;
            padding: 14px;
            font-size: 14px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            border-color: #000000;
            color: #000000;
        }

        /* CSS 動態特效 */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
            
        }
    </style>
</head>
<script>
    localStorage.removeItem("cart");
</script>
<body>

    <%@ include file="header.jsp" %>

    <div class="success-wrapper">
        <div class="success-card">
            
            <div class="success-icon">✓</div>
            
            <h1>訂單提交成功</h1>
            <p>感謝您的購買！我們已收到您的訂單，<br>目前正全力為您安排出貨中。</p>
            
            <div class="order-info-box">
                <div class="info-row">
                    <span class="info-label">訂單編號</span>
                    <span class="info-value">#<%= orderId %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">訂單狀態</span>
                    <span class="info-value" style="color: #4caf50;">處理中</span>
                </div>
            </div>
            
            <div class="btn-group">
                <a href="index.jsp" class="btn-primary">繼續購物</a>
                <a href="member.jsp#orders" class="btn-secondary">查看訂單紀錄</a>
            </div>
            
        </div>
    </div>

    <footer>
        <p>&copy; 2026 STANDARD DAY. All Rights Reserved.</p>
    </footer>
    <script src="cookie-consent.js" defer></script>
</body>
</html>
