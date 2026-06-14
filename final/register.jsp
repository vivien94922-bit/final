<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>註冊｜STANDARD DAY</title>

<link rel="stylesheet" href="style.css">

<style>
body{
    margin:0;
    font-family: Arial, sans-serif;
    background: #f6f6f6;
}

/* ===== 註冊區塊置中 ===== */
.register-wrapper{
    min-height: calc(100vh - 120px);
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 40px 0; /* 留點上下間距，避免手機版塞滿 */
}

/* ===== 註冊卡片 ===== */
.register-card{
    width: 360px;
    background: #fff;
    padding: 35px 30px;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    text-align: center;
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn{
    from{opacity:0; transform: translateY(20px);}
    to{opacity:1; transform: translateY(0);}
}

.register-title{
    font-size: 22px;
    margin-bottom: 20px;
    letter-spacing: 2px;
    color: #222;
}

/* ===== input ===== */
.register-input{
    width: 100%;
    padding: 12px 14px;
    margin: 8px 0;
    border: 1px solid #ddd;
    border-radius: 10px;
    outline: none;
    box-sizing: border-box; /* 防止 input 超出卡片寬度 */
    transition: 0.3s;
}

.register-input:focus{
    border-color: #333;
    box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
}

/* ===== button ===== */
.register-btn{
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    border: none;
    border-radius: 10px;
    background: #222;
    color: white;
    cursor: pointer;
    font-size: 15px;
    transition: 0.3s;
}

.register-btn:hover{
    background: #444;
    transform: translateY(-2px);
}

/* ===== 返回登入連結 ===== */
.login-link{
    margin-top: 15px;
    font-size: 13px;
    color: #666;
    cursor: pointer;
}

.login-link:hover{
    color: #000;
    text-decoration: underline;
}
</style>
</head>

<body>
<div class="register-wrapper">

  <div class="register-card">
    <div class="register-title">新會員註冊</div>

    <form action="register_process.jsp" method="post">
      
      <input class="register-input" type="text" name="username" placeholder="請設定帳號" required>
      <input class="register-input" type="password" name="password" placeholder="請設定密碼" required>
      <input class="register-input" type="text" name="name" placeholder="真實姓名" required>
      <input class="register-input" type="email" name="email" placeholder="電子信箱" required>
      <input class="register-input" type="text" name="phone" placeholder="行動電話" required>

      <button class="register-btn" type="submit">確認註冊</button>
    </form>

    <div class="login-link" onclick="location.href='login.jsp'">
      已有帳號？返回登入
    </div>
  </div>

</div>

<script src="cookie-consent.js" defer></script>

</body>
</html>