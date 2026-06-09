-- ============================================================
--  shopdb
-- ============================================================

CREATE DATABASE IF NOT EXISTS shopdb
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE shopdb;

-- ============================================================
-- 1. 商品表
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    product_id  INT          PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    price       INT          NOT NULL,
    stock       INT          NOT NULL DEFAULT 0,
    image       VARCHAR(255),
    description TEXT
);

TRUNCATE TABLE products;

INSERT INTO products (product_id, name, price, stock, image, description) VALUES
(1,  '夢幻粉色大衣',           1280, 10, 'images/01.jpg',
 '這款夢幻粉色大衣採用柔軟羊毛混紡面料，手感細膩、保暖性絕佳。寬鬆版型修飾身形，搭配同色系或白色內搭均展現高雅氣質。雙排釦設計增添復古時髦感，是秋冬衣櫥的必備單品。'),

(2,  '百搭基礎牛仔褲',          960,  10, 'images/02.jpg',
 '經典直筒剪裁，彈性丹寧布料提供舒適彈力，久穿不易變形。百搭深藍水洗色系，無論搭配T恤、衛衣或正式上衣皆游刃有餘。標準五口袋設計，機能與時尚兼顧，男女皆適穿。'),

(3,  '時尚週限定條紋長裙',       840,  10, 'images/03.jpg',
 '靈感源自米蘭時尚週伸展台，採用流暢雪紡布料，穿起來輕盈飄逸。細膩黑白條紋排列賦予視覺延伸效果，高腰剪裁拉長比例，裙擺寬闊方便行走，搭配素色上衣即可輕鬆完成時髦造型。'),

(4,  '學院格紋顯身短裙',         550,  10, 'images/04.jpg',
 '採用英倫學院風格紋面料，A字剪裁從腰部向下自然展開，完美修飾臀部曲線。隱藏式側拉鍊穿脫方便，褲頭鬆緊設計舒適服貼。搭配Polo衫或針織毛衣，輕鬆駕馭校園甜美風格。'),

(5,  '質感牛仔夾克',            1100, 10, 'images/05.jpg',
 '精選12oz重磅純棉丹寧布料，質感厚實耐穿，水洗舊化處理呈現自然復古紋理。修身版型不顯臃腫，胸前雙口袋與側開口袋兼具實用性。四季皆宜的外搭單品，越洗越有個性風味。'),

(6,  '質感黑色牛仔夾克',         1280, 10, 'images/06.jpg',
 '以精緻黑色丹寧面料打造的進階版牛仔夾克，染色均勻、色澤飽和不易褪色。同款藍色夾克的沉穩升級版，更顯都會率性。可單穿或疊搭連帽衛衣，打造多層次街頭風格，是全年度最具造型感的外套選擇。'),

(7,  '紳士透膚襯衫',            1280, 10, 'images/07.jpg',
 '採用高透氣感雪紡梭織布料，輕薄透膚卻不失優雅。標準領口設計搭配精緻貝殼釦，呈現紳士細節品味。修身版型俐落有型，適合商務或約會場合。內搭素色背心可完美詮釋半透明的層次美感。'),

(8,  '超前衛運動上衣',            590,  10, 'images/08.jpg',
 '融合運動機能與街頭美學的前衛設計，採用速乾彈力布料，吸汗透氣效果出色。非對稱剪裁與撞色拼接細節打破傳統運動服框架，無論是健身房訓練或日常街頭穿搭皆能駕馭，展現獨特個人風格。'),

(9,  '象牙白打底上衣',            690,  10, 'images/09.jpg',
 '以優質莫代爾棉混紡布料製成，觸感極致柔軟貼膚。象牙白色系溫潤不刺眼，百搭任何顏色下裝或外套。圓領設計貼合鎖骨線條，微修身剪裁輕鬆展現身型，是四季衣櫥最不可或缺的基本款打底單品。'),

(10, '復古垂感束腳工裝褲',         690,  10, 'images/10.jpg',
 '靈感取材自 90 年代工裝美學，多口袋設計機能十足，側邊立體口袋可容納手機、錢包等隨身物品。垂感面料搭配束口設計，在寬鬆輪廓中保有利落線條。搭配寬版上衣即可打造休閒街頭造型。'),

(11, '男裝天絲彈力直筒卡其褲',     730,  10, 'images/11.jpg',
 '採用 TENCEL™ 天絲纖維混紡彈力布料，兼具柔軟垂墜與舒適彈性。卡其色系百搭易穿，直筒版型從腰至褲腳比例流暢，修飾腿型效果顯著。適合商務休閒或日常通勤，洗後快乾不易起皺，打理輕鬆。'),

(12, '亮鑽百褶網紗白色長裙',       730,  10, 'images/12.jpg',
 '多層次百褶網紗設計，裙擺豐盈有層次感，行走間輕盈飄動如夢境。裙身點綴細緻亮鑽裝飾，在光線下閃爍迷人光澤。高腰設計拉長身形比例，搭配簡約上衣即可化身宴會或約會的焦點。'),

(13, '歐美紫色西裝外套',           1190, 10, 'images/13.jpg',
 '靈感源自歐美時尚街拍，以高飽和丁香紫色調打造搶眼造型。精梳羊毛混紡面料挺括有型，雙釦正式剪裁兼顧職場與宴會場合。搭配白色或黑色內搭，輕鬆呈現大膽又不失品味的歐式時尚氣場。'),

(14, '斜肩氣質荷葉邊上衣',          350,  20, 'images/14.jpg',
 '浪漫一字領斜肩設計突顯鎖骨與肩頸線條，層疊荷葉邊裝飾增添女性柔美氣息。雪紡材質輕盈垂順，穿起來透氣舒適。版型略為寬鬆，適合各種體型，搭配高腰長褲或短裙均能展現迷人的氣質韻味。'),

(15, '短版聯名渲染上衣',            440,  20, 'images/15.jpg',
 '品牌聯名企劃獨家推出，手工渲染暈染技法使每件作品色彩獨一無二。短版剪裁搭配高腰褲或裙裝展現比例美感，純棉材質親膚透氣。渲染色彩豐富多層，打造潮流感十足的街頭藝術穿搭風格。');

-- ============================================================
-- 2. 商品留言表
-- ============================================================
CREATE TABLE IF NOT EXISTS product_comment (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    product_id  INT          NOT NULL,
    user_id     INT          NOT NULL,
    username    VARCHAR(50)  NOT NULL,
    rating      INT          NOT NULL,
    content     TEXT         NOT NULL,
    create_time TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO product_comment (product_id, user_id, username, rating, content) VALUES
(1, 1, 'admin', 5, '這件大衣很好看！'),
(1, 2, 'Amy',   4, '質感不錯，穿起來很舒服'),
(2, 1, 'admin', 5, '牛仔褲版型很好');

-- ============================================================
-- 3. 購物車表
-- ============================================================
CREATE TABLE IF NOT EXISTS cart (
    cart_id     INT       PRIMARY KEY AUTO_INCREMENT,
    user_id     INT       NOT NULL,
    product_id  INT       NOT NULL,
    quantity    INT       DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. 會員表
-- ============================================================
CREATE TABLE IF NOT EXISTS members (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100),
    create_time TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 驗證
-- ============================================================
SELECT * FROM products;

USE shopdb;

CREATE TABLE orders (
    order_id    INT PRIMARY KEY AUTO_INCREMENT,
    user_id     INT NOT NULL,
    total_price INT NOT NULL,
    status      VARCHAR(20) DEFAULT '待處理',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    item_id    INT PRIMARY KEY AUTO_INCREMENT,
    order_id   INT NOT NULL,
    product_id INT NOT NULL,
    name       VARCHAR(100) NOT NULL,
    price      INT NOT NULL,
    quantity   INT NOT NULL
);