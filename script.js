document.addEventListener("DOMContentLoaded", () => {
  //searchIcon
  const searchIcon = document.getElementById("searchIcon");
  const searchBox = document.getElementById("searchBox");

  // 檢查 searchIcon 和 searchBox 是否存在，並綁定點擊事件
  if (searchIcon && searchBox) {
    searchIcon.addEventListener("click", () => {
      // 切換 searchBox 顯示與隱藏
      searchBox.classList.toggle("active");
    });
  }

  //menuIcon
  const menuIcon = document.getElementById("menuIcon");
  const menuBox = document.getElementById("menuBox");

  if (menuIcon && menuBox) {
    menuIcon.addEventListener("click", () => {
      menuBox.classList.toggle("active"); // 切換 active 類名來顯示/隱藏菜單
    });
  }
  
  // ===== banner =====
  let currentBannerIndex = 0; // 用來追踪當前顯示的 Banner 圖片
  
  const bannerImages = [
    "images/banner1.jpg",
    "images/banner2.jpg",
    "images/banner3.jpg"
  ]; // 所有 Banner 圖片的路徑
  
  const bannerTitles = [
    "NEW ARRIVAL", 
    "SUMMER SALE", 
    "WINTER COLLECTION"
  ]; // 各個 Banner 圖片對應的標題
  
  const bannerDescriptions = [
    "秋冬新品 8 折起",
    "夏季促銷，快來選購！",
    "冬季系列，暖心上新！"
  ]; // 各個 Banner 圖片的描述
  
  const bannerProductIds = [4, 14, 3]; // 每個 Banner 對應的商品 ID
  
  // 更新 Banner 顯示的函數
  function updateBanner() {
    const bannerImage = document.getElementById("bannerImage");
    const bannerTitle = document.getElementById("bannerTitle");
    const bannerDesc = document.getElementById("bannerDesc");
    const bannerBuyNowBtn = document.getElementById("bannerBuyNowBtn");

    if (!bannerImage || !bannerTitle || !bannerDesc || !bannerBuyNowBtn) {
    console.error("Banner elements are missing!");
    return;
  }
    
    // 更新 Banner 的內容
    bannerImage.src = bannerImages[currentBannerIndex];
    bannerTitle.innerText = bannerTitles[currentBannerIndex];
    bannerDesc.innerText = bannerDescriptions[currentBannerIndex];
    
    // 更新立即選購按鈕的行為
    bannerBuyNowBtn.onclick = () => {
      const productId = bannerProductIds[currentBannerIndex];
      window.location.href = `product.html?id=${productId}`; // 重定向到相應的商品頁面
    };

    // 更新圓點顯示
    const dotsContainer = document.getElementById("dotsContainer");
    dotsContainer.innerHTML = ""; // 清空現有圓點
    bannerImages.forEach((_, index) => {
      const dot = document.createElement("span");
      dot.classList.add("dot");
      dot.addEventListener("click", () => {
        currentBannerIndex = index;
        updateBanner();
      });
  
      if (index === currentBannerIndex) dot.classList.add("active");
      dotsContainer.appendChild(dot);
    });
  }
  
  // 顯示上一張圖片
  function prevBanner() {
    currentBannerIndex = (currentBannerIndex - 1 + bannerImages.length) % bannerImages.length;
    updateBanner();
  }
  
  // 顯示下一張圖片
  function nextBanner() {
    currentBannerIndex = (currentBannerIndex + 1) % bannerImages.length;
    updateBanner();
  }
  
  // 自動輪播
  let autoSlideInterval = setInterval(nextBanner, 5000); // 每5秒切換一次 Banner 圖片
  
  // 停止自動輪播，並在手動切換後重新啟動
  function stopAutoSlide() {
    clearInterval(autoSlideInterval);
    autoSlideInterval = setInterval(nextBanner, 5000);
  }
  
  // 初始化時更新 Banner 顯示
  updateBanner();
  
  // 綁定手動切換按鈕
  const prevBtn = document.querySelector(".prev");
  const nextBtn = document.querySelector(".next");

  if (prevBtn && nextBtn) {
    prevBtn.addEventListener("click", () => {
      prevBanner();
      stopAutoSlide(); // 停止自動輪播並重新啟動
    });

    nextBtn.addEventListener("click", () => {
      nextBanner();
      stopAutoSlide(); // 停止自動輪播並重新啟動
    });
  }
  
  // ===== 搜尋功能 =====
  const searchInput = document.getElementById("searchInput");
  const searchResult = document.getElementById("searchResult");

  if (searchInput && searchResult && typeof products !== "undefined") {
    searchInput.addEventListener("input", () => {
      const keyword = searchInput.value.trim().toLowerCase();
      searchResult.innerHTML = "";

      if (keyword === "") return;

      const results = products.filter(p =>
        p.name.toLowerCase().includes(keyword)
      );

      if (results.length === 0) {
        searchResult.innerHTML = "<div class='search-item'>找不到商品</div>";
        return;
      }

      results.forEach(p => {
        const a = document.createElement("a");
        a.href = `product.html?id=${p.id}`;
        a.className = "search-item";
        a.textContent = p.name;
        searchResult.appendChild(a);
      });
    });
  }

  // ===== Toast 彈出訊息 =====
  function showToast(msg) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerText = msg;
    document.body.appendChild(toast);
    setTimeout(() => toast.classList.add('show'), 10);
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => document.body.removeChild(toast), 300);
    }, 2000);
  }

  // ===== 登入檢查 =====
  function requireLogin(redirectTo) {
    if (localStorage.getItem("isLogin") !== "true") {
      localStorage.setItem("redirectAfterLogin", redirectTo);
      showToast("請先登入會員");
      setTimeout(() => window.location.href = "member.html", 800);
      return false;
    }
    return true;
  }

  // ===== header 會員顯示 =====
  function renderUserArea() {
    const userArea = document.getElementById("user-area");
    if (!userArea) return;

    const isLogin = localStorage.getItem("isLogin") === "true";
    const user = localStorage.getItem("user");

    if (isLogin && user) {
      userArea.innerHTML = `
        <div class="user-menu">
          <img src="images/user.png" alt="Member">
          <span class="user-name">Hi, ${user}</span>
          <div class="dropdown">
            <a href="member.html">會員中心</a>
            <a href="#" id="logoutBtn">登出</a>
          </div>
        </div>
      `;
      document.getElementById("logoutBtn").addEventListener("click", e => {
        e.preventDefault();
        localStorage.removeItem("isLogin");
        localStorage.removeItem("user");
        showToast("已登出");
        setTimeout(() => window.location.href = "index.html", 800);
      });
    } else {
      userArea.innerHTML = `
        <a href="member.html">
          <img src="images/user.png" title="註冊 / 登入">
        </a>
      `;
    }
  }
  renderUserArea();

  // ===== 回到頂部 =====
  const backToTopBtn = document.getElementById("backToTop");
  if (backToTopBtn) {
    window.addEventListener("scroll", () => {
      backToTopBtn.style.display = window.scrollY > 300 ? "block" : "none";
    });
    backToTopBtn.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

  // ===== 加入購物車 =====
  document.addEventListener("click", (e) => {
    if (e.target.classList.contains("add-cart-btn")) {
      const btn = e.target;
      const product = btn.closest(".product");
      if (!product) return;

      if (!requireLogin(window.location.href)) return;

      const id = product.dataset.id;
      const name = product.dataset.name;
      const price = parseInt(product.dataset.price);
      const img = product.dataset.img;
      if (!id || !name || !price || !img) return;

      let cart = JSON.parse(localStorage.getItem("cart")) || {};
      const key = id;

      if (cart[key]) {
        cart[key].quantity += 1;
      } else {
        cart[key] = { id, name, price, img, quantity: 1 };
      }

      localStorage.setItem("cart", JSON.stringify(cart));
      showToast(`${name} 已加入購物車！`);
    }
  });

  // ===================== 收藏功能 =====================
  let favorites = JSON.parse(localStorage.getItem("favorites")) || [];
  favorites = favorites.filter(item => item && item.id);

  window.toggleFavorite = function(el) {
    if (!el) return;
    const product = el.closest(".product");
    if (!product) return;

    const id = String(product.dataset.id);
    const name = product.dataset.name;
    const price = product.dataset.price;
    const img = product.dataset.img;
    if (!id || !name || !price || !img) return;

    const index = favorites.findIndex(item => String(item.id) === id);

    if (el.src.includes("heart.png")) {
      el.src = "images/love.png";
      if (index === -1) favorites.push({ id, name, price, img });
      showToast("已加入收藏");
    } else {
      el.src = "images/heart.png";
      if (index !== -1) favorites.splice(index, 1);
      showToast("已移除收藏");
    }

    localStorage.setItem("favorites", JSON.stringify(favorites));
  };

  // 初始化收藏 icon
  document.querySelectorAll(".product").forEach(product => {
    const id = String(product.dataset.id);
    const icon = product.querySelector(".favorite-icon");
    if (!icon) return;
    icon.addEventListener("click", () => toggleFavorite(icon));
    if (favorites.some(item => String(item.id) === id)) icon.src = "images/love.png";
    else icon.src = "images/heart.png";
  });

});

window.addEventListener("load", () => {
  const intro = document.getElementById("intro");

  if (!intro) return;

  setTimeout(() => {
    intro.remove(); 
  }, 2000);
});
