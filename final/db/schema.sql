-- =============================================================
-- STANDARD DAY 電商網站　統一資料庫結構（組員D：資料庫設計）
-- -------------------------------------------------------------
-- 整合重點：
--   原本 DB 分散在 clothing_shop / counter / shopdb 三個資料庫，
--   現全部統一到單一資料庫「shopdb」（utf8mb4，支援中文與 emoji）。
--
-- 使用方式：
--   mysql -u root -p < schema.sql
-- =============================================================

CREATE DATABASE IF NOT EXISTS shopdb
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE shopdb;

-- 因含外鍵，重建時依相依順序先刪除
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS product_comment;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS counter;

-- -------------------------------------------------------------
-- 會員（登入 / 註冊 / 會員中心）
--   password：以加鹽 SHA-256 儲存（不存明文，加分項）
--   salt    ：每位會員獨立鹽值
--   role    ：user / admin（供管理者功能使用）
-- -------------------------------------------------------------
CREATE TABLE members (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(64)  NOT NULL,            -- SHA-256 → 64 字 16 進位
  salt       VARCHAR(64)  NOT NULL,
  name       VARCHAR(50),
  email      VARCHAR(100),
  phone      VARCHAR(20),
  role       VARCHAR(10)  NOT NULL DEFAULT 'user',
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 商品（商品陳列 / 商品詳細頁）
--   stock   ：庫存數量（供組員B「購買後庫存減少」使用）
--   category：tops / bottoms（供分類頁與搜尋使用）
-- -------------------------------------------------------------
CREATE TABLE product (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  price       INT          NOT NULL,
  image       VARCHAR(255),
  description TEXT,
  category    VARCHAR(20),
  stock       INT          NOT NULL DEFAULT 0,
  created_at  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 商品留言 / 評價（留言板：中文 + 依日期排序，最新在最上）
--   user_id 允許為 NULL（目前 add.jsp 未寫入；保留供登入會員綁定）
-- -------------------------------------------------------------
CREATE TABLE product_comment (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  product_id  INT NOT NULL,
  user_id     INT NULL,
  username    VARCHAR(50),
  rating      INT,
  content     TEXT,
  create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comment_product FOREIGN KEY (product_id) REFERENCES product(id),
  CONSTRAINT fk_comment_member  FOREIGN KEY (user_id)    REFERENCES members(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 購物車（加入購物車 / 結帳）
-- -------------------------------------------------------------
CREATE TABLE cart (
  cart_id    INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  product_id INT NOT NULL,
  quantity   INT NOT NULL DEFAULT 1,
  CONSTRAINT fk_cart_member  FOREIGN KEY (user_id)    REFERENCES members(id),
  CONSTRAINT fk_cart_product FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 訪客計數器（單列）
-- -------------------------------------------------------------
CREATE TABLE counter (
  id    INT PRIMARY KEY,
  count INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -------------------------------------------------------------
-- 訂單 / 訂單明細（供組員B：購物車結帳、管理者訂單瀏覽）
--   結構先行設計，邏輯由組員B實作
-- -------------------------------------------------------------
CREATE TABLE orders (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  member_id  INT,
  name       VARCHAR(50),
  phone      VARCHAR(20),
  address    VARCHAR(255),
  payment    VARCHAR(20),
  total      INT,
  status     VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_member FOREIGN KEY (member_id) REFERENCES members(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE order_items (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  order_id   INT,
  product_id INT,
  name       VARCHAR(100),
  price      INT,
  size       VARCHAR(10),
  quantity   INT,
  CONSTRAINT fk_item_order   FOREIGN KEY (order_id)   REFERENCES orders(id),
  CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================
-- 種子資料（Seed Data）
-- =============================================================

-- 訪客計數器初始化
INSERT INTO counter (id, count) VALUES (1, 0);

-- 會員（密碼皆已雜湊，請用下列「明文」登入測試）
--   admin / 1234        （角色 admin，與管理者登入頁一致）
--   demo  / demo1234    （角色 user）
INSERT INTO members (username, password, salt, name, email, phone, role) VALUES
('admin',
 '417e41bcaeea95de21c78932c6e390b530dc13fb5e99d1ceee28eac2e024f817',
 'a1b2c3d4e5f60718',
 '管理員', 'admin@standardday.com', '0900000000', 'admin'),
('demo',
 '2b6eb4b86c9996febd1b89f901a9efccfdb23a63a04c8ef079d06ab21f78ddd3',
 '1122334455667788',
 '示範會員', 'demo@standardday.com', '0911111111', 'user');

-- 商品（對應原本 index.jsp / tops.jsp / bottoms.jsp 的 15 件商品）
-- 圖片路徑採全站統一的相對路徑 ../images/（與各頁面一致）
INSERT INTO product (id, name, price, image, description, category, stock) VALUES
(1,  '夢幻粉色大衣',           1280, '../images/01.jpg', '柔軟保暖的粉色長版大衣，剪裁俐落，秋冬穿搭首選。', 'tops',    20),
(2,  '百搭基礎牛仔褲',         960,  '../images/02.jpg', '經典直筒牛仔褲，彈性布料舒適好穿，百搭不退流行。', 'bottoms', 30),
(3,  '時尚週限定條紋長裙',     840,  '../images/03.jpg', '飄逸條紋長裙，垂墜感佳，展現優雅氣質。',           'bottoms', 18),
(4,  '學院格紋顯身短裙',       590,  '../images/04.jpg', '學院風格紋短裙，顯瘦版型，青春有型。',             'bottoms', 25),
(5,  '質感牛仔夾克',           1100, '../images/05.jpg', '經典藍色牛仔夾克，耐穿百搭，四季皆宜。',           'tops',    15),
(6,  '質感黑色牛仔夾克',       1280, '../images/06.jpg', '黑色水洗牛仔夾克，個性剪裁，街頭風必備。',         'tops',    15),
(7,  '紳士透膚襯衫',           1280, '../images/07.jpg', '輕透材質紳士襯衫，簡約有型，正式休閒兩相宜。',     'tops',    22),
(8,  '超前衛運動上衣',         590,  '../images/08.jpg', '機能排汗運動上衣，彈性十足，運動更自在。',         'tops',    40),
(9,  '象牙白打底上衣',         690,  '../images/09.jpg', '象牙白基礎打底上衣，柔軟親膚，簡約耐看。',         'tops',    35),
(10, '復古垂感束腳工裝褲',     690,  '../images/10.jpg', '復古工裝束腳褲，垂墜版型，休閒有型。',             'bottoms', 28),
(11, '男裝天絲彈力直筒卡其褲', 730,  '../images/11.jpg', '天絲彈力卡其褲，透氣舒適，低調百搭。',             'bottoms', 26),
(12, '亮鑽百褶網紗白色長裙',   730,  '../images/12.jpg', '亮鑽點綴百褶網紗長裙，浪漫吸睛，宴會場合首選。',   'bottoms', 12),
(13, '歐美紫色西裝外套',       1190, '../images/13.jpg', '歐美剪裁紫色西裝外套，氣場十足，展現專業時尚。',   'tops',    14),
(14, '斜肩氣質荷葉邊上衣',     350,  '../images/14.jpg', '斜肩荷葉邊設計上衣，甜美修飾肩線，約會穿搭推薦。', 'tops',    33),
(15, '短版聯名渲染上衣',       440,  '../images/15.jpg', '聯名渲染印花短版上衣，個性獨特，穿出時尚態度。',   'tops',    31);

-- 商品留言（示範：依 create_time 由新到舊排序，最新在最上）
INSERT INTO product_comment (product_id, user_id, username, rating, content, create_time) VALUES
(1, 2, 'demo', 5, '這件粉色大衣超暖又好看！', '2026-06-01 10:00:00'),
(1, 2, 'demo', 4, '質感不錯，但尺碼偏大一點。',  '2026-06-03 14:30:00'),
(1, 2, 'demo', 5, '穿出去被朋友狂問哪裡買！',   '2026-06-05 09:15:00');

-- -------------------------------------------------------------
-- 會員收藏清單
-- -------------------------------------------------------------
CREATE TABLE favorites (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  member_id   INT NOT NULL,
  product_id  INT NOT NULL,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  -- 確保一個會員不會重複收藏同一個商品
  UNIQUE KEY unique_member_product (member_id, product_id),
  -- 外鍵關聯
  CONSTRAINT fk_fav_member  FOREIGN KEY (member_id)  REFERENCES members(id) ON DELETE CASCADE,
  CONSTRAINT fk_fav_product  FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO favorites (member_id, product_id) VALUES (2, 1);
DELETE FROM favorites WHERE member_id = 2 AND product_id = 1;

SELECT * FROM favorites WHERE member_id = 2;
