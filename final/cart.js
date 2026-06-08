function renderCart() {
    const cart = JSON.parse(localStorage.getItem("cart")) || {};
    const container = document.body; // cart-item 原本就直接在 body 底下
  
    
    document.querySelectorAll(".cart-item").forEach(item => item.remove());
  
    Object.values(cart).forEach(item => {
      const div = document.createElement("div");
      div.className = "cart-item";
      div.dataset.price = item.price;
  
      div.innerHTML = `
        <img src="${item.img}" alt="${item.name}">
        <div class="item-info">
          <p>${item.name}</p>
          <p>單價：NT$${item.price.toLocaleString()}</p>
          <div class="quantity-controls">
            <button class="decrease">-</button>
            <input type="number" class="quantity" value="${item.quantity}" min="0">
            <button class="increase">+</button>
            <button class="remove-btn">刪除</button>
          </div>
        </div>
      `;
  
      // 插在總計前面
      document.querySelector(".total").before(div);
    });
  
    bindCartEvents();
    updateTotal();
  }
  
  function updateTotal() {
    let total = 0;
  
    document.querySelectorAll(".cart-item").forEach(item => {
      const price = parseInt(item.dataset.price);
      const qty = parseInt(item.querySelector(".quantity").value) || 0;
      total += price * qty;
    });
  
    const hint = document.getElementById("discountHint");
  
    let discountRate = 1;
    let message = "";
  
    if (total >= 1500) {
      discountRate = 0.88;
      message = "已享 88 折優惠（最高折扣）";
    } 
    else if (total >= 1000) {
      discountRate = 0.9;
      message = "已享 9 折優惠，再買 NT$" + (1500 - total) + " 可升級 88 折";
    } 
    else {
      message = "再買 NT$" + (1000 - total) + " 享 9 折，再買 NT$" + (1500 - total) + " 享 88 折";
    }
  
    const finalTotal = Math.floor(total * discountRate);
  
    document.getElementById("totalAmount").textContent =
      finalTotal.toLocaleString();
  
    hint.textContent = message;
  }
  
  function bindCartEvents() {
    document.querySelectorAll(".increase").forEach(btn => {
      btn.onclick = () => {
        const input = btn.parentElement.querySelector(".quantity");
        input.value++;
        saveCart();
      };
    });
  
    document.querySelectorAll(".decrease").forEach(btn => {
      btn.onclick = () => {
        const input = btn.parentElement.querySelector(".quantity");
        if (input.value > 0) input.value--;
        saveCart();
      };
    });
  
    document.querySelectorAll(".remove-btn").forEach(btn => {
      btn.onclick = () => {
        btn.closest(".cart-item").remove();
        saveCart();
      };
    });
  }
  
  function saveCart() {
    const cart = {};
    document.querySelectorAll(".cart-item").forEach(item => {
      const name = item.querySelector("p").innerText;
      const price = parseInt(item.dataset.price);
      const img = item.querySelector("img").src;
      const qty = parseInt(item.querySelector(".quantity").value);
  
      if (qty > 0) {
        cart[name] = { name, price, img, quantity: qty };
      }
    });
  
    localStorage.setItem("cart", JSON.stringify(cart));
    updateTotal();
  }
  
  document.getElementById("checkoutBtn").addEventListener("click", () => {
    const total = document.getElementById("totalAmount").textContent;
    if (total === "0") {
      alert("您的購物車目前是空的喔！");
    } else {
      window.location.href = "check.html";
    }
  });
  document.addEventListener("DOMContentLoaded", renderCart);
  //新加入的折扣
  function getDiscountRate(total) {
    if (total >= 1500) return 0.88;
    if (total >= 1000) return 0.9;
    return 1;
  }
