document.addEventListener("DOMContentLoaded", () => {
  // 取得商品 ID
  const params = new URLSearchParams(window.location.search);
  const productId = Number(params.get("id")) || 1;

  // 找到對應商品
  const productData = products.find(p => p.id === productId);
  if (!productData) {
    alert("找不到商品");
    return;
  }

  const productEl = document.querySelector(".product-container");

  // ===== 設定 dataset =====
  productEl.dataset.id = productData.id;
  productEl.dataset.name = productData.name;
  productEl.dataset.price = productData.price;
  productEl.dataset.img = productData.images[0]; // dataset 只能存字串

  // ===== 填充商品資訊 =====
  document.getElementById("productName").innerText = productData.name;
  document.getElementById("productDesc").innerText = productData.desc;
  document.getElementById("productPrice").innerText = `NT$ ${productData.price}`;
  document.getElementById("detail").innerHTML = productData.detail;
  document.getElementById("mainImage").src = productData.images[0];
  document.getElementById("mainImage").alt = productData.name;

  // ===== 填充尺寸選單 =====
  const sizeSelect = document.getElementById("sizeSelect");
  sizeSelect.innerHTML = "";
  productData.sizes.forEach(size => {
    const option = document.createElement("option");
    option.value = size;
    option.textContent = size;
    sizeSelect.appendChild(option);
  });

   // ===== 登入檢查 =====
function requireLogin(redirectTo) {
  if (localStorage.getItem("isLogin") !== "true") {
    localStorage.setItem("redirectAfterLogin", redirectTo);

    alert("請先登入會員");

    setTimeout(() => {
      window.location.href = "login.jsp?redirect=" + encodeURIComponent(redirectTo);
    }, 500);

    return false;
  }
  return true;
}
  
  // ===== 加入購物車 =====
  async function addToCart(productId) {
  const qty = document.getElementById('qtyInput').value;

  const res = await fetch('addToCart.jsp', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    body: `product_id=${productId}&quantity=${qty}`
  });

  // 沒登入
  if (res.status === 401) {
    alert("請先登入");
    location.href = "login.jsp";
    return;
  }

  const data = await res.json();

  if (data.success) {
    if (confirm(data.msg + "\n\n要去購物車嗎？")) {
      location.href = "cart.jsp";
    }
  } else {
    alert(data.msg);
  }
}
  // ===== Tab 切換 =====
  document.querySelectorAll(".tab").forEach(tab => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
      document.querySelectorAll(".content").forEach(c => c.classList.remove("active"));
      tab.classList.add("active");
      document.getElementById(tab.dataset.tab).classList.add("active");
    });
  });

  // ===== 顧客回饋 =====
  const feedbackContainer = document.getElementById("feedback-list");
  const noFeedbacksText = document.getElementById("no-feedbacks");
  const submitFeedbackButton = document.getElementById("submit-feedback");

  

  // ===== 送貨及付款方式 =====
  const shippingContainer = document.getElementById("shipping");
  shippingContainer.innerHTML = `
    <h3>配送方式</h3>
    <p>宅配 / 7-11 / 全家</p>
    <h3>付款方式</h3>
    <p>Apple Pay / LINE Pay / 銀行轉帳 / 信用卡 / 超商取貨付款</p>
  `;
});
;