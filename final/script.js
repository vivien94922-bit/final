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

  /* ===================== 優化後的收藏功能 ===================== */
  // 1. 定義一個通用的更新函式，讓所有相同 ID 的按鈕都能同步
  window.updateAllHearts = function(productId, isFavorite) {
      const newSrc = isFavorite ? "images/love.png" : "images/heart.png";
      // 找出頁面上所有對應此 ID 的愛心圖示並更新
      document.querySelectorAll(`.product[data-id="${productId}"] .favorite-icon`)
          .forEach(icon => {
              icon.src = newSrc;
          });
  };

  window.toggleFavorite = function (el) {
      const p = el.closest(".product");
      const id = p.dataset.id;
      const isFavoritePage = document.getElementById("favorite-list") !== null;

      fetch("favorite_toggle.jsp", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: "product_id=" + id
      })
      .then(res => {
          if (res.status === 401) {
              alert("請先登入");
              window.location.href = "login.jsp";
              throw new Error("Not logged in");
          }
          return res.text();
      })
      .then(result => {
          const status = result.trim();
          const isNowFavorite = (status === "add");

          if (status === "add" || status === "remove") {
              // 【關鍵修改】：不再只改 el，而是全域更新所有對應 ID 的愛心
              window.updateAllHearts(id, isNowFavorite);

              // 處理收藏頁面特有的移除邏輯
              if (isFavoritePage && status === "remove") {
                  p.remove();
                  const list = document.getElementById("favorite-list");
                  if (list && list.querySelectorAll(".product").length === 0) {
                      list.innerHTML = "<p>目前沒有收藏商品</p>";
                  }
              }
              toast(isNowFavorite ? "已加入收藏" : "已移除收藏");
          }
      })
      .catch(err => console.error("收藏失敗:", err));
  };

});

// 在點擊愛心並確認後端更新成功後，發送事件：
const updateEvent = new CustomEvent('wishlist-updated', { 
    detail: { productId: 123, isWishlisted: true } 
});
window.dispatchEvent(updateEvent);

/* ===================== intro ===================== */
window.addEventListener("load", () => {
  const intro = document.getElementById("intro");
  if (intro) setTimeout(() => intro.remove(), 2000);
});
