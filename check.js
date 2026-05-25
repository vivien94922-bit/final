document.getElementById('checkoutForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const formData = {
        name: document.getElementById('name').value,
        phone: document.getElementById('phone').value,
        address: document.getElementById('address').value
    };

    if (formData.name.length < 2) {
        alert("請輸入有效的收件人姓名");
        return;
    }
    console.log("訂單資料傳輸中...", formData);

    const submitBtn = document.getElementById('submitBtn');
    submitBtn.innerText = "處理中...";
    submitBtn.disabled = true;

    setTimeout(() => {
        document.getElementById('successMessage').classList.remove('hidden');
    }, 1000);
});

const nameInput = document.getElementById('name');
const phoneInput = document.getElementById('phone');
const form = document.getElementById('checkoutForm');

nameInput.oninput = () => {
    nameInput.value = nameInput.value.replace(/[^\u4e00-\u9fa5a-zA-Z]/g, '');
};

phoneInput.oninput = () => {
    phoneInput.value = phoneInput.value.replace(/\D/g, '');
};

const subtotal = parseInt(localStorage.getItem('cartSubtotal')) || 0;
const shipping = parseInt(localStorage.getItem('shippingFee')) || 0;
const total = subtotal + shipping;


function formatCurrency(num) {
    return '$' + num.toLocaleString();
}


window.addEventListener('DOMContentLoaded', () => {
    document.getElementById('subtotal-display').innerText = formatCurrency(subtotal);
    document.getElementById('shipping-fee-display').innerText = formatCurrency(shipping);
    document.getElementById('total-Amount').innerText = formatCurrency(total);
});

document.getElementById('checkoutForm').addEventListener('submit', function(event) {

});


form.onsubmit = (e) => {
    e.preventDefault();
    if (form.checkValidity()) {
        document.getElementById('successMessage').classList.remove('hidden');
    } else {
        alert("請輸入正確的資料格式");
    }
};

