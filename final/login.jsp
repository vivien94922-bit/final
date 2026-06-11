<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <title>會員登入 - STANDARD DAY</title>
  <style>
    /* ===== 基礎全域設定 ===== */
    body {
      margin: 0;
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      color: #333;
      display: flex;
      flex-direction: column; /* 讓 header 頂天，main-content 吃滿剩餘空間 */
      min-height: 100vh;
    }

    /* ===== 精簡版 Header 樣式 ===== */
    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 40px;
      background-color: #222;
      position: relative;
      z-index: 1000;
    }

    .logo {
      color: white;
      font-size: 24px;
      font-weight: bold;
      text-decoration: none;
      letter-spacing: 1px;
    }

    /* ===== 主內容區（將登入卡片置中） ===== */
    .main-content {
      flex: 1;
      display: flex;
      justify-content: center;
      align-items: center;
      padding: 40px 0;
    }

    /* ===== 登入外層卡片 ===== */
    .login-container {
      background-color: #fff;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
      width: 100%;
      max-width: 350px;
      box-sizing: border-box;
    }

    .login-container h2 {
      text-align: center;
      margin-top: 0;
      margin-bottom: 25px;
      font-size: 22px;
      letter-spacing: 1px;
    }

    /* ===== 表單群組 ===== */
    .form-group {
      margin-bottom: 20px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: bold;
      font-size: 14px;
    }

    .form-group input {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      box-sizing: border-box;
      font-size: 14px;
      transition: border-color 0.2s;
    }

    .form-group input:focus {
      border-color: #222;
      outline: none;
    }

    /* ===== 登入按鈕 ===== */
    .login-btn {
      width: 100%;
      padding: 12px;
      background-color: #222;
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      cursor: pointer;
      transition: background-color 0.2s;
      margin-top: 10px;
    }

    .login-btn:hover {
      background-color: #555;
    }

    /* ===== 下方引導註冊連結 ===== */
    .register-link {
      text-align: center;
      margin-top: 20px;
      font-size: 14px;
      color: #666;
      cursor: pointer;
      text-decoration: underline;
      transition: color 0.2s;
    }

    .register-link:hover {
      color: #000;
      font-weight: bold;
    }
  </style>
</head>
<body>

  <header>
    <div class="nav-left">
      <a href="index.jsp" class="logo">STANDARD DAY</a>
    </div>
  </header>

  <div class="main-content">
    <div class="login-container">
      <h2>會員登入</h2>
      
      <form action="login_process.jsp" method="post">
        <div class="form-group">
          <label>帳號</label>
          <input type="text" name="username" required placeholder="請輸入帳號">
        </div>
        
        <div class="form-group">
          <label>密碼</label>
          <input type="password" name="password" required placeholder="請輸入密碼">
        </div>
        
        <button type="submit" class="login-btn">登入</button>
      </form>

      <div class="register-link" onclick="location.href='member.jsp#register'">
        還沒註冊？立即註冊
      </div>
    </div>
  </div>

  <script src="script.js" defer></script>
  <script src="cookie-consent.js" defer></script>

</body>
</html>
