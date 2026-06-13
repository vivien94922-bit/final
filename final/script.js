document.addEventListener("DOMContentLoaded", () => {

  /* ===================== 搜尋 ===================== */
  const searchIcon = document.getElementById("searchIcon");
  const searchBox = document.getElementById("searchBox");
  const searchInput = document.getElementById("searchInput");
  const searchResult = document.getElementById("searchResult");
  
  searchIcon.addEventListener("click", () => {
    searchBox.classList.toggle("active");
  });
  
  let timer;
  
  searchInput.addEventListener("input", () => {
  
    const keyword = searchInput.value.trim();
  
    clearTimeout(timer);
  
    if(keyword.length === 0){
      searchResult.innerHTML = "";
      return;
    }
  
    timer = setTimeout(() => {
  
      fetch("search.jsp?keyword=" + encodeURIComponent(keyword))
        .then(res => res.text())
        .then(data => {
          searchResult.innerHTML = data;
        });
  
    }, 200);
  
  });
  /* ===================== menu ===================== */
  const menuIcon = document.getElementById("menuIcon");
  const menuBox = document.getElementById("menuBox");

  if (menuIcon && menuBox) {
    menuIcon.addEventListener("click", () => {
      menuBox.classList.toggle("active");
    });
  }

  /* ===================== banner ===================== */
  let current = 0;

  const images = ["../images/banner1.jpg","../images/banner2.jpg","../images/banner3.jpg"];
  const titles = ["NEW ARRIVAL","SUMMER SALE","WINTER COLLECTION"];
  const descs = ["秋冬新品 8 折起","夏季促銷","冬季系列"];
  const ids = [4,14,3];

  function updateBanner() {
    const img = document.getElementById("bannerImage");
    const title = document.getElementById("bannerTitle");
    const desc = document.getElementById("bannerDesc");
    const btn = document.getElementById("bannerBuyNowBtn");
    const dots = document.getElementById("dotsContainer");

    if (!img || !title || !desc || !btn || !dots) return;

    img.src = images[current];
    title.innerText = titles[current];
    desc.innerText = descs[current];

    btn.onclick = () => {
      location.href = `product.jsp?id=${ids[current]}`;
    };

    dots.innerHTML = "";
    images.forEach((_, i) => {
      const dot = document.createElement("span");
      dot.className = i === current ? "dot active" : "dot";
      dot.onclick = () => {
        current = i;
        updateBanner();
      };
      dots.appendChild(dot);
    });
  }

  function next() {
    current = (current + 1) % images.length;
    updateBanner();
  }

  function prev() {
    current = (current - 1 + images.length) % images.length;
    updateBanner();
  }

  setInterval(next, 5000);
  updateBanner();

  document.querySelector(".next")?.addEventListener("click", next);
  document.querySelector(".prev")?.addEventListener("click", prev);

  /* ===================== toast ===================== */
  function toast(msg) {
    const t = document.createElement("div");
    t.className = "toast";
    t.innerText = msg;
    document.body.appendChild(t);

    setTimeout(() => t.classList.add("show"), 10);
    setTimeout(() => t.remove(), 2000);
  }

  /* ===================== header login UI ===================== */
  const userArea = document.getElementById("user-area");
  
  if (userArea) {
    fetch("check_login.jsp")
      .then(r => r.text())
      .then(s => {
        if (s.trim() === "OK") {
          userArea.innerHTML = `
            <a href="member.jsp">會員中心</a>
            <a href="logout.jsp">登出</a>
          `;
        } else {
          userArea.innerHTML = `
            <a href="login.jsp">
              <img src="../images/user.png">
            </a>
          `;
        }
      });
  }
  /* ===================== 回到頂部 ===================== */
  const topBtn = document.getElementById("backToTop");

  if (topBtn) {
    window.addEventListener("scroll", () => {
      topBtn.style.display = window.scrollY > 300 ? "block" : "none";
    });

    topBtn.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

  /* ===================== 加入購物車（唯一版本） ===================== */
  document.addEventListener("click", async (e) => {
    if (!e.target.classList.contains("add-cart-btn")) return;

    const res = await fetch("check_login.jsp");
    const status = await res.text();

    if (status.trim() !== "OK") {
        alert("請先登入");
        location.href = "login.jsp";
        return;
    }

    const p = e.target.closest(".product");
    if (!p) return;

    const id = p.dataset.id;

    // 👉 改成直接寫 DB
    const addRes = await fetch("addToCart.jsp", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `product_id=${id}&quantity=1`
    });

    const data = await addRes.json();

    alert(data.msg || "已加入購物車");
  });

  /* ===================== 資料庫版收藏功能 ===================== */
  window.toggleFavorite = function (el) {
      const p = el.closest(".product");
      const id = p.dataset.id;
      
      // 檢查當前是否在收藏列表頁面 (假設你的容器 ID 是 favorite-list)
      const isFavoritePage = document.getElementById("favorite-list") !== null;

      fetch("favorite_toggle.jsp", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: "product_id=" + id
      })
      .then(res => {
          // 1. 檢查 HTTP 狀態碼
          if (res.status === 401) {
              alert("請先登入");
              window.location.href = "login.jsp";
              throw new Error("Not logged in"); // 停止後續執行
          }
          return res.text();
      })
      .then(result => {
          const status = result.trim();
          
          if (status === "add") {
              el.src = "images/love.png"; // 變實心
              toast("已加入收藏");
          } else if (status === "remove") {
              // 如果在收藏列表頁，直接把卡片移除
              if (isFavoritePage) {
                  p.remove(); 
                  // 若列表空了，顯示提示訊息
                  const list = document.getElementById("favorite-list");
                  if (list && list.querySelectorAll(".product").length === 0) {
                      list.innerHTML = "<p>目前沒有收藏商品</p>";
                  }
              } else {
                  // 如果在一般商品列表，只換回空心
                  el.src = "images/heart.png";
              }
              toast("已移除收藏");
          }
      })
      .catch(err => console.error("收藏失敗:", err));
  };
  
    // 頁面載入時自動執行：同步收藏狀態
  document.addEventListener("DOMContentLoaded", () => {
      fetch("favorite_list.jsp")
          .then(res => res.json())
          .then(data => {
              // 將後端回傳的 ID 整理成陣列 (假設回傳結構是 [{id: 1}, {id: 2}])
              const favoriteIds = data.map(item => item.id);

              // 檢查頁面上每一個產品卡片
              document.querySelectorAll(".product").forEach(product => {
                  const id = parseInt(product.dataset.id);
                  const icon = product.querySelector(".favorite-icon");
                  if (icon) {
                      // 如果該 ID 在清單內，顯示實心；否則顯示空心
                      if (favoriteIds.includes(id)) {
                          icon.src = "images/love.png";
                      } else {
                          icon.src = "images/heart.png";
                      }
                  }
              });
          });
  });

});

/* ===================== intro ===================== */
window.addEventListener("load", () => {
  const intro = document.getElementById("intro");
  if (intro) setTimeout(() => intro.remove(), 2000);
});
