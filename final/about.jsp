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
        <h4>負責商品展示功能開發，透過資料庫動態讀取商品資訊並顯示庫存數量，實作購物時庫存自動扣減機制，參與購物車加入商品功能及資料庫整合作業。</h4>
        <p>在期末要面對多份報告，雖然過程一度感到焦躁，但幸好有夥伴們的分工與配合，讓我們能順利完成專題。在兼顧多重任務的過程中，我也深刻體會到團隊協作的重要性，並從中累積了寶貴的實務經驗。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 25%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="25"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member2.jpg" alt="蕭小雯">
        <div class="student-id">11344222</div>
        <h3>蕭小雯</h3>
        <h4>主要負責整個電商網站最核心的「交易邏輯」，包含加入購物車 API、結帳流程處理、管理者訂單瀏覽功能，以及購買完成後自動扣減資料庫庫存的 SQL 事務處理。在確保商業系統核心的資料一致性上花費了許多心力 debug。</h4>
        <p>在開始期末專案前我對於 JSP 程式並不熟練，也對這個專案感到有點負擔和緊張，因為完成一個網站還需要各項技術的整合能力，但經過這一兩個禮拜以來不斷地實作和修改，我對於網站前後端的整合有了很多的學習。將課堂中認識到的功能或知識實際且順利運用真的非常不容易，因此我也十分感謝組員們互相配合與幫助，才能完成這次的專案。</p>
          <div class="work-progress">
          <div class="progress-label">工作分配 25%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="25"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member3.jpg" alt="簡嘉葳">
        <div class="student-id">11344218</div>
        <h3>簡嘉葳</h3>
        <h4>負責留言板功能（支援中文顯示、依日期排序及最新留言置頂）、會員登入控制、商品搜尋、訪客計數器、產品管理（新增、上架、修改、刪除商品）、管理者訂單瀏覽、會員優惠設計，以及網站整合測試工作；同時參與購物車結帳功能開發、CSS版面設計與背景圖製作。</h4>
        <p>這次專題讓我學習到如何將課堂上學到的 JSP 與資料庫知識實際應用在網站開發中。我負責留言板、登入系統、商品搜尋、商品管理等功能，在開發過程中遇到許多問題，但透過查資料、反覆測試及和組員討論，最終順利完成。這次經驗不僅提升了我的程式設計能力，也讓我更了解團隊合作的重要性。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 25%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="25"></div>
          </div>
        </div>
      </div>

      <div class="team-card">
        <img src="../images/member4.jpg" alt="神林俊希">
        <div class="student-id">11150214</div>
        <h3>神林俊希</h3>
        <h4>主要負責資料庫設計，網站安全與法規相關功能，包括 ERD 與資料表設計、SQL Injection 防護、個資法與 Cookie 告知等法律規範實作，並協助統一全站 API 資料結構、優化管理者系統及進行整體整合測試。</h4>
        <p>透過這次專題，我了解到網站開發需要 Java、JSP、HTML、SQL 等多方面的知識，並不是只會單一技術就能完成。尤其在建構 SQL 與資料庫功能時，不只需要後端與資料庫的知識，也需要理解前端頁面如何傳送、接收與顯示資料，才能讓整個系統正常運作。此外，在實作 SQL Injection 防護、Cookie 提示與個資法相關內容時，我也發現將課堂上學到的知識實際套用到網站中並不簡單，需要注意很多細節。這次經驗也讓我更加理解分工合作、Git 管理與系統整合在團隊開發中的重要性。</p>
        <div class="work-progress">
          <div class="progress-label">工作分配 25%</div>
          <div class="progress-bar">
            <div class="progress-fill" data-percent="25"></div>
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
