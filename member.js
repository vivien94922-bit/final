// 切換右側內容
function showSection(sectionId) {
    document.querySelectorAll('.content-section').forEach(section => section.classList.remove('active'));
    document.getElementById(sectionId).classList.add('active');
}

// 登出function logout() {localStorage.removeItem("isLogin");localStorage.removeItem("userProfile");alert("已登出");window.location.href = "index.html";}

// DOM 加載完畢
document.addEventListener("DOMContentLoaded", () => {
    const isLogin = localStorage.getItem("isLogin") === "true";

    // 載入會員資料
    const profile = JSON.parse(localStorage.getItem("userProfile")) || {};
    if (profile.name) document.getElementById("name").value = profile.name;
    if (profile.email) document.getElementById("email").value = profile.email;
    if (profile.phone) document.getElementById("phone").value = profile.phone;

    // 表單送出
    const profileForm = document.getElementById('profileForm');
    profileForm.addEventListener('submit', e => {
        e.preventDefault();

        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();

        if (!name || !email || !phone) {
            alert("請填寫完整會員資料！");
            return;
        }

        const profileData = { name, email, phone };
        localStorage.setItem("userProfile", JSON.stringify(profileData));
        localStorage.setItem("isLogin", "true");
        localStorage.setItem("user", name);

        alert("登入成功！");

        // 回到先前頁面
        const redirect = localStorage.getItem("redirectAfterLogin") || "index.html";
        localStorage.removeItem("redirectAfterLogin");
        window.location.href = redirect;
    });
});

