<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>關於我們｜STANDARD DAY</title>

<link rel="stylesheet" href="style.css">
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
    }
    
    footer {
        background-color: #222;
        color: white;
        text-align: center;
        padding: 20px;
        margin-top: 40px;
    }
    
    .about-header {
        background-color: #f2f2f2;
        padding: 20px;
        text-align: center;
    }
    
    .animated-title {
        font-size: 28px;
        opacity: 0;
        transform: translateX(-50px);
        animation: slideFadeIn 1s forwards;
    }
    
    @keyframes slideFadeIn {
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }
    
    .about-container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 0 30px;
    }
    
    .team-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin-top: 20px;
    }
    
    .team-card {
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 12px;
        text-align: center;
        padding: 20px;
        transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .team-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    
    .team-card img {
        width: 180px;
        height: 180px;
        object-fit: cover;
        border-radius: 50%;
    }
    
    .student-id {
        font-size: 13px;
        color: #888;
        margin: 10px 0 2px 0;
    }

    .team-card h3 {
        margin: 0 0 5px 0;
        font-size: 20px;
    }
    
    .team-card h4 {
        font-size: 14px;
        color: #565254;
        background: #eee;
        display: inline-block;
        padding: 3px 10px;
        border-radius: 20px;
        margin: 5px 0;
    }

    .team-card p {
        font-family: "Noto Sans TC", "PingFang TC", "Microsoft JhengHei", sans-serif;
        font-size: 14px;
        line-height: 1.7;
        color: #444;
        text-align: justify;        
        margin-top: 12px;
        border-top: 1px dashed #eee;
        padding-top: 10px;
    }
    
    /* ===== 工作分配進度條 ===== */
    .work-progress {
        margin-top: 15px;
        text-align: left;
    }
    
    .progress-label {
        font-size: 13px;
        margin-bottom: 6px;
        color: #444;
    }
    
    .progress-bar {
        width: 100%;
        height: 10px;
        background-color: #eee;
        border-radius: 10px;
        overflow: hidden;
    }
    
    .progress-fill {
        height: 100%;
        width: 0;
        background: linear-gradient(90deg, #222, #555);
        border-radius: 10px;
        transition: width 1.5s ease;
    }

    #backToTop {
        position: fixed;
        bottom: 40px;
        right: 40px;
        z-index: 1000;
        background-color: #333;
        color: #fff;
        border: none;
        padding: 12px 16px;
        border-radius: 50%;
        cursor: pointer;
        font-size: 20px;
        display: none;
        transition: background 0.3s, transform 0.2s;
    }

    #backToTop:hover {
        background-color: #555;
        transform: scale(1.1);
    }

    /* RWD 響應式優化：手機版自動變單欄，卡片才不會被擠扁 */
    @media (max-width: 768px) {
        .team-grid {
            grid-template-columns: repeat(1, 1fr);
        }
    }
</style>
</head>

<body>

<section class="about-header">
  <h1 class="animated-title">關於我們</h1>
</section>

<main class="about-container">
  <section class="about-section">
    <h2>品牌故事</h2>
    <p>
      STANDARD DAY 成立於 2025 年，致力於打造簡約、舒適又實穿的服裝。我們相信每一天都是新的開始，因此希望提供能陪伴你日常的服飾。
    </p>
  </section>

  <section class="about-section">
    <h2>我們的理念</h2>
    <p>
      我們堅持高品質、環保素材，並注重每一件商品的細節。穿上 STANDARD DAY，不只是穿衣服，而是一種生活態度。
    </p>
  </section>

  <section class="about-section team-section">
    <h2>團隊介紹</h2>

    <div class="team-grid">

      <div class="team-card">
        <img src="../images/member1.jpg" alt="翁逸岑">
        <div class="student-id">11344231</div>
        <h3>翁逸岑</h3>
        <h4>前端整合與商品展示</h4>
        <p>修改檔名、換關於我們照片</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 10%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="10"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member2.jpg" alt="蕭小雯">
        <div class="student-id">11344222</div>
        <h3>蕭小雯</h3>
        <h4>後端核心 / 交易邏輯 </h4>
        <p>主要負責整個電商網站最核心的「交易邏輯」，包含加入購物車 API、結帳流程處理、管理者訂單瀏覽功能，以及購買完成後自動扣減資料庫庫存的 SQL 事務處理。在確保商業系統核心的資料一致性上花費了許多心力 debug。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 30%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="30"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member3.jpg" alt="簡嘉葳">
        <div class="student-id">11344218</div>
        <h3>簡嘉葳</h3>
        <h4>會員系統與互動功能 </h4>
        <p>負責編寫網站的使用者互動功能，包含 Login / Logout 的 Session 與 Cookie 狀態控管、支援中文且依最新日期排序的留言板功能，以及訪客計數器的實作。在串聯不同頁面的使用者登入狀態時，挑戰了許多 JavaScript 與後端狀態機制的整合。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 30%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="30"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member4.jpg" alt="神林俊希">
        <div class="student-id">11150214</div>
        <h3>神林俊希</h3>
        <h4>資料庫與全站安全 (組員D)</h4>
        <p>負責底層資料庫的規劃（ERD與資料表設計）、全站 API 資料結構的統一，並主導資安防護。包含利用 Prepared Statement 防止資料隱碼注入（SQL Injection）、密碼的 Hash 加密處理，以及符合個資法規的 Cookie 同意提示提示機制，確保網站安全穩固。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 30%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="30"></div>
          </div>
        </div>
      </div>

    </div>
  </section>
</main>

<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop" title="回到頂部">↑</button>

<script>
    document.addEventListener("DOMContentLoaded", () => {
      document.querySelectorAll(".progress-fill").forEach(bar => {
        const percent = bar.dataset.percent;
        setTimeout(() => {
          bar.style.width = percent + "%";
        }, 300);
      });
    });

    const backToTopBtn = document.getElementById("backToTop");
    
    window.onscroll = function() {
      if (document.body.scrollTop > 200 || document.documentElement.scrollTop > 200) {
        backToTopBtn.style.display = "block";
      } else {
        backToTopBtn.style.display = "none";
      }
    };
    
    backToTopBtn.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
</script>

<script src="script.js"></script>

<!-- Cookie 同意提示（組員D：個資法/Cookie） -->
<script src="cookie-consent.js" defer></script>

</body>
</html>
