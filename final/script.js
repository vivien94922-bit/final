document.addEventListener("DOMContentLoaded", () => {

  /* ===================== 搜尋 ===================== */
  const searchIcon = document.getElementById("searchIcon");
  const searchBox = document.getElementById("searchBox");

  if (searchIcon && searchBox) {
    searchIcon.addEventListener("click", () => {
      searchBox.classList.toggle("active");
    });
  }

  const searchInput = document.getElementById("searchInput");
  const searchResult = document.getElementById("searchResult");

  if (searchInput && searchResult && typeof products !== "undefined") {
    searchInput.addEventListener("input", () => {
      const keyword = searchInput.value.trim().toLowerCase();
      searchResult.innerHTML = "";

      if (!keyword) return;

      const results = products.filter(p =>
        p.name.toLowerCase().includes(keyword)
      );

      if (results.length === 0) {
        searchResult.innerHTML = "<div>找不到商品</div>";
        return;
      }

      results.forEach(p => {
        const a = document.createElement("a");
        a.href = `product.jsp?id=${p.id}`;
        a.textContent = p.name;
        searchResult.appendChild(a);
      });
    });
  }

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

  const images = ["images/banner1.jpg","images/banner2.jpg","images/banner3.jpg"];
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
            <img src="images/user.png">
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
    const name = p.dataset.name;
    const price = p.dataset.price;
    const img = p.dataset.img;

    let cart = JSON.parse(localStorage.getItem("cart")) || {};

    if (cart[id]) {
      cart[id].quantity++;
    } else {
      cart[id] = { id, name, price, img, quantity: 1 };
    }

    localStorage.setItem("cart", JSON.stringify(cart));

    alert(name + " 已加入購物車");
  });

  /* ===================== 收藏 ===================== */
  let fav = JSON.parse(localStorage.getItem("favorites")) || [];

  window.toggleFavorite = function (el) {
    const p = el.closest(".product");
    const id = p.dataset.id;

    const index = fav.findIndex(x => x.id === id);

    if (el.src.includes("heart.png")) {
      el.src = "images/love.png";
      if (index === -1) fav.push({
        id,
        name: p.dataset.name,
        price: p.dataset.price,
        img: p.dataset.img
      });
      toast("已加入收藏");
    } else {
      el.src = "images/heart.png";
      if (index !== -1) fav.splice(index, 1);
      toast("已移除收藏");
    }

    localStorage.setItem("favorites", JSON.stringify(fav));
  };

  document.querySelectorAll(".product").forEach(p => {
    const icon = p.querySelector(".favorite-icon");
    if (!icon) return;

    const id = p.dataset.id;

    if (fav.some(x => x.id === id)) {
      icon.src = "images/love.png";
    }

    icon.onclick = () => toggleFavorite(icon);
  });

});

/* ===================== intro ===================== */
window.addEventListener("load", () => {
  const intro = document.getElementById("intro");
  if (intro) setTimeout(() => intro.remove(), 2000);
});