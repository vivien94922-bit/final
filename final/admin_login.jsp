<%@ page contentType="text/html; charset=UTF-8" %>
<%
String msg = "";

String username = request.getParameter("username");
String password = request.getParameter("password");

if(username != null){

    if(username.equals("admin") && password.equals("1234")){

        session.setAttribute("isAdmin", true);

        response.sendRedirect("admin_orders.jsp");
        return;

    } else {
        msg = "帳號或密碼錯誤";
    }
}
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>登入｜STANDARD DAY</title>

<link rel="stylesheet" href="style.css">

<style>
body{
    margin:0;
    font-family: Arial, sans-serif;
    background: #f6f6f6;
}

/* ===== 登入區塊置中 ===== */
.login-wrapper{
    height: calc(100vh - 120px);
    display:flex;
    justify-content:center;
    align-items:center;
}

/* ===== 登入卡片 ===== */
.login-card{
    width: 360px;
    background: #fff;
    padding: 35px 30px;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    text-align:center;
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn{
    from{opacity:0; transform: translateY(20px);}
    to{opacity:1; transform: translateY(0);}
}

.login-title{
    font-size: 22px;
    margin-bottom: 20px;
    letter-spacing: 2px;
    color:#222;
}

/* ===== input ===== */
.login-input{
    width:100%;
    padding: 12px 14px;
    margin: 8px 0;
    border:1px solid #ddd;
    border-radius: 10px;
    outline:none;
    transition: 0.3s;
}

.login-input:focus{
    border-color:#333;
    box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
}

/* ===== button ===== */
.login-btn{
    width:100%;
    padding: 12px;
    margin-top: 15px;
    border:none;
    border-radius: 10px;
    background:#222;
    color:white;
    cursor:pointer;
    font-size: 15px;
    transition: 0.3s;
}

.login-btn:hover{
    background:#444;
    transform: translateY(-2px);
}

/* ===== 註冊連結 ===== */
.register-link{
    margin-top: 15px;
    font-size: 13px;
    color:#666;
    cursor:pointer;
}

.register-link:hover{
    color:#000;
    text-decoration: underline;
}
/* ===== 管理者登入 ===== */

.admin-login-wrap{
    height: calc(100vh - 90px);
    display:flex;
    justify-content:center;
    align-items:center;
    background:
    linear-gradient(
        135deg,
        #f5f5f5,
        #e8e8e8
    );
}

.admin-panel{
    width:380px;
    background:#1f1f1f;
    color:white;
    padding:45px 35px;
    border-radius:20px;
    text-align:center;
    box-shadow:0 15px 40px rgba(0,0,0,.15);
}

.admin-icon{
    font-size:45px;
    margin-bottom:10px;
}

.admin-panel h2{
    margin:0;
    letter-spacing:3px;
    font-size:26px;
}

.sub-title{
    color:#bbbbbb;
    margin-top:8px;
    margin-bottom:30px;
    font-size:14px;
}

.admin-input{
    width:100%;
    box-sizing:border-box;
    padding:13px;
    margin-bottom:15px;
    border:none;
    border-radius:10px;
    background:#333;
    color:white;
    font-size:14px;
}

.admin-input::placeholder{
    color:#999;
}

.admin-input:focus{
    outline:none;
    background:#444;
}

.admin-btn{
    width:100%;
    padding:13px;
    border:none;
    border-radius:10px;
    background:white;
    color:#222;
    font-size:15px;
    font-weight:bold;
    cursor:pointer;
    transition:.3s;
}

.admin-btn:hover{
    transform:translateY(-2px);
    background:#dddddd;
}

.error-msg{
    margin-top:18px;
    color:#ff7b7b;
    font-size:14px;
}

</style>
</head>
<body>
      <%@ include file="header.jsp" %>
<div class="admin-login-wrap">

    <div class="admin-panel">

        <div class="admin-icon">⚙</div>

        <h2>ADMIN PANEL</h2>
        <p class="sub-title">後台管理系統登入</p>

        <form method="post">

            <input
                type="text"
                name="username"
                class="admin-input"
                placeholder="管理者帳號"
            >

            <input
                type="password"
                name="password"
                class="admin-input"
                placeholder="管理者密碼"
            >

            <button class="admin-btn">
                登 入 後 台
            </button>

        </form>

        <% if(!msg.equals("")){ %>
            <div class="error-msg">
                <%= msg %>
            </div>
        <% } %>

    </div>

</div>

<script src="cookie-consent.js" defer></script>
</body>
</html>
