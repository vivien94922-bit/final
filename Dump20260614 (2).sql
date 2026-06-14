-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: shopdb
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '5a7388a0-1152-11f1-9bcd-d8bbc172bc6a:1-1381';

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `size` varchar(10) NOT NULL DEFAULT 'M',
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `unique_cart_item` (`user_id`,`product_id`,`size`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (1,1,1,1,'2026-06-10 15:36:08','M'),(6,4,1,1,'2026-06-12 08:28:52','M');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `cart_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cart_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

USE shopdb;
ALTER TABLE cart ADD COLUMN size VARCHAR(10) NOT NULL DEFAULT 'M';

DESCRIBE shopdb.cart;

--
-- Table structure for table `counter`
--

DROP TABLE IF EXISTS `counter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counter` (
  `id` int NOT NULL,
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `counter`
--

LOCK TABLES `counter` WRITE;
/*!40000 ALTER TABLE `counter` DISABLE KEYS */;
INSERT INTO `counter` VALUES (1,246);
/*!40000 ALTER TABLE `counter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite`
--

DROP TABLE IF EXISTS `favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite`
--

LOCK TABLES `favorite` WRITE;
/*!40000 ALTER TABLE `favorite` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_member_product` (`member_id`,`product_id`),
  KEY `fk_fav_product` (`product_id`),
  CONSTRAINT `fk_fav_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fav_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(64) NOT NULL,
  `salt` varchar(64) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(10) NOT NULL DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,'admin','d74ce70c3de590d522ddc28c0e80380fd9c193fc866899a68c52215595569089','a1b2c3d4e5f60718','管理員','admin@standardday.com','0900000000','admin','2026-06-10 07:53:35'),(2,'demo','2b6eb4b86c9996febd1b89f901a9efccfdb23a63a04c8ef079d06ab21f78ddd3','1122334455667788','示範會員','demo@standardday.com','0911111111','user','2026-06-10 07:53:35'),(3,'vivien','8d76f6a1596ac79dee2ed235f4c18d15462ba96aacbbceab494214f9f87908a3','2ec974b53f0ea192838581155f670c9b','測試者1','demo@standardday.com','031254678','user','2026-06-10 08:00:10'),(4,'hello','818087703bbf36389200843bef2cacd02a57246148721a1e0929a0538ed8c924','127a641fcd877da0e700c044d0100cfb','安安','dmiejmf456418@gmail.com','0912345687','user','2026-06-12 08:27:46');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `price` int DEFAULT NULL,
  `size` varchar(10) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_item_order` (`order_id`),
  KEY `fk_item_product` (`product_id`),
  CONSTRAINT `fk_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (13,2,1,'夢幻粉色大衣',1280,NULL,1);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `member_id` int DEFAULT NULL,
  `id` int NOT NULL AUTO_INCREMENT,
  `phone` varchar(50) DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `payment` varchar(20) DEFAULT NULL,
  `total` int DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (3,1,NULL,NULL,NULL,NULL,1152,'pending','2026-06-14 02:40:01'),(3,14,'09111111111','1','1','credit',1280,'pending','2026-06-14 13:25:56');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` int NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `category` varchar(20) DEFAULT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'夢幻粉色大衣',1280,'../images/01.jpg','柔軟保暖的粉色長版大衣，剪裁俐落，秋冬穿搭首選。','tops',20,'2026-06-10 07:53:35'),(2,'百搭基礎牛仔褲',960,'../images/02.jpg','經典直筒牛仔褲，彈性布料舒適好穿，百搭不退流行。','bottoms',30,'2026-06-10 07:53:35'),(3,'時尚週限定條紋長裙',840,'../images/03.jpg','飄逸條紋長裙，垂墜感佳，展現優雅氣質。','bottoms',18,'2026-06-10 07:53:35'),(4,'學院格紋顯身短裙',590,'../images/04.jpg','學院風格紋短裙，顯瘦版型，青春有型。','bottoms',25,'2026-06-10 07:53:35'),(5,'質感牛仔夾克',1100,'../images/05.jpg','經典藍色牛仔夾克，耐穿百搭，四季皆宜。','tops',15,'2026-06-10 07:53:35'),(6,'質感黑色牛仔夾克',1280,'../images/06.jpg','黑色水洗牛仔夾克，個性剪裁，街頭風必備。','tops',15,'2026-06-10 07:53:35'),(7,'紳士透膚襯衫',1280,'../images/07.jpg','輕透材質紳士襯衫，簡約有型，正式休閒兩相宜。','tops',22,'2026-06-10 07:53:35'),(8,'超前衛運動上衣',590,'../images/08.jpg','機能排汗運動上衣，彈性十足，運動更自在。','tops',40,'2026-06-10 07:53:35'),(9,'象牙白打底上衣',690,'../images/09.jpg','象牙白基礎打底上衣，柔軟親膚，簡約耐看。','tops',35,'2026-06-10 07:53:35'),(10,'復古垂感束腳工裝褲',690,'../images/10.jpg','復古工裝束腳褲，垂墜版型，休閒有型。','bottoms',28,'2026-06-10 07:53:35'),(11,'男裝天絲彈力直筒卡其褲',730,'../images/11.jpg','天絲彈力卡其褲，透氣舒適，低調百搭。','bottoms',26,'2026-06-10 07:53:35'),(12,'亮鑽百褶網紗白色長裙',730,'../images/12.jpg','亮鑽點綴百褶網紗長裙，浪漫吸睛，宴會場合首選。','bottoms',12,'2026-06-10 07:53:35'),(13,'歐美紫色西裝外套',1190,'../images/13.jpg','歐美剪裁紫色西裝外套，氣場十足，展現專業時尚。','tops',14,'2026-06-10 07:53:35'),(14,'斜肩氣質荷葉邊上衣',350,'../images/14.jpg','斜肩荷葉邊設計上衣，甜美修飾肩線，約會穿搭推薦。','tops',33,'2026-06-10 07:53:35'),(15,'短版聯名渲染上衣',440,'../images/15.jpg','聯名渲染印花短版上衣，個性獨特，穿出時尚態度。','tops',31,'2026-06-10 07:53:35');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_comment`
--

DROP TABLE IF EXISTS `product_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `content` text,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_comment_product` (`product_id`),
  KEY `fk_comment_member` (`user_id`),
  CONSTRAINT `fk_comment_member` FOREIGN KEY (`user_id`) REFERENCES `members` (`id`),
  CONSTRAINT `fk_comment_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_comment`
--

LOCK TABLES `product_comment` WRITE;
/*!40000 ALTER TABLE `product_comment` DISABLE KEYS */;
INSERT INTO `product_comment` VALUES (1,1,2,'demo',5,'這件粉色大衣超暖又好看！','2026-06-01 02:00:00'),(2,1,2,'demo',4,'質感不錯，但尺碼偏大一點。','2026-06-03 06:30:00'),(3,1,2,'demo',5,'穿出去被朋友狂問哪裡買！','2026-06-05 01:15:00'),(4,1,1,NULL,5,'8','2026-06-10 14:37:59'),(5,1,1,'vivien',5,'2','2026-06-10 14:41:28'),(6,1,1,'vivien',5,'1','2026-06-10 14:41:38');
/*!40000 ALTER TABLE `product_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `price` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `image` varchar(255) DEFAULT NULL,
  `description` text,
  `category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'夢幻粉色大衣',1280,8,'images/01.jpg','這款夢幻粉色大衣採用柔軟羊毛混紡面料，手感細膩、保暖性絕佳。寬鬆版型修飾身形，搭配同色系或白色內搭均展現高雅氣質。雙排釦設計增添復古時髦感，是秋冬衣櫥的必備單品。','tops'),(2,'百搭基礎牛仔褲',960,10,'images/02.jpg','經典直筒剪裁，彈性丹寧布料提供舒適彈力，久穿不易變形。百搭深藍水洗色系，無論搭配T恤、衛衣或正式上衣皆游刃有餘。標準五口袋設計，機能與時尚兼顧，男女皆適穿。','bottoms'),(3,'時尚週限定條紋長裙',840,10,'images/03.jpg','靈感源自米蘭時尚週伸展台，採用流暢雪紡布料，穿起來輕盈飄逸。細膩黑白條紋排列賦予視覺延伸效果，高腰剪裁拉長比例，裙擺寬闊方便行走，搭配素色上衣即可輕鬆完成時髦造型。','bottoms'),(4,'學院格紋顯身短裙',550,10,'images/04.jpg','採用英倫學院風格紋面料，A字剪裁從腰部向下自然展開，完美修飾臀部曲線。隱藏式側拉鍊穿脫方便，褲頭鬆緊設計舒適服貼。搭配Polo衫或針織毛衣，輕鬆駕馭校園甜美風格。','bottoms'),(5,'質感牛仔夾克',1100,10,'images/05.jpg','精選12oz重磅純棉丹寧布料，質感厚實耐穿，水洗舊化處理呈現自然復古紋理。修身版型不顯臃腫，胸前雙口袋與側開口袋兼具實用性。四季皆宜的外搭單品，越洗越有個性風味。','tops'),(6,'質感黑色牛仔夾克',1280,10,'images/06.jpg','以精緻黑色丹寧面料打造的進階版牛仔夾克，染色均勻、色澤飽和不易褪色。同款藍色夾克的沉穩升級版，更顯都會率性。可單穿或疊搭連帽衛衣，打造多層次街頭風格，是全年度最具造型感的外套選擇。','tops'),(7,'紳士透膚襯衫',1280,10,'images/07.jpg','採用高透氣感雪紡梭織布料，輕薄透膚卻不失優雅。標準領口設計搭配精緻貝殼釦，呈現紳士細節品味。修身版型俐落有型，適合商務或約會場合。內搭素色背心可完美詮釋半透明的層次美感。','tops'),(8,'超前衛運動上衣',590,10,'images/08.jpg','融合運動機能與街頭美學的前衛設計，採用速乾彈力布料，吸汗透氣效果出色。非對稱剪裁與撞色拼接細節打破傳統運動服框架，無論是健身房訓練或日常街頭穿搭皆能駕馭，展現獨特個人風格。','tops'),(9,'象牙白打底上衣',690,10,'images/09.jpg','以優質莫代爾棉混紡布料製成，觸感極致柔軟貼膚。象牙白色系溫潤不刺眼，百搭任何顏色下裝或外套。圓領設計貼合鎖骨線條，微修身剪裁輕鬆展現身型，是四季衣櫥最不可或缺的基本款打底單品。','tops'),(10,'復古垂感束腳工裝褲',690,10,'images/10.jpg','靈感取材自 90 年代工裝美學，多口袋設計機能十足，側邊立體口袋可容納手機、錢包等隨身物品。垂感面料搭配束口設計，在寬鬆輪廓中保有利落線條。搭配寬版上衣即可打造休閒街頭造型。','bottoms'),(11,'男裝天絲彈力直筒卡其褲',730,10,'images/11.jpg','採用 TENCEL™ 天絲纖維混紡彈力布料，兼具柔軟垂墜與舒適彈性。卡其色系百搭易穿，直筒版型從腰至褲腳比例流暢，修飾腿型效果顯著。適合商務休閒或日常通勤，洗後快乾不易起皺，打理輕鬆。','bottoms'),(12,'亮鑽百褶網紗白色長裙',730,10,'images/12.jpg','多層次百褶網紗設計，裙擺豐盈有層次感，行走間輕盈飄動如夢境。裙身點綴細緻亮鑽裝飾，在光線下閃爍迷人光澤。高腰設計拉長身形比例，搭配簡約上衣即可化身宴會或約會的焦點。','bottoms'),(13,'歐美紫色西裝外套',1190,10,'images/13.jpg','靈感源自歐美時尚街拍，以高飽和丁香紫色調打造搶眼造型。精梳羊毛混紡面料挺括有型，雙釦正式剪裁兼顧職場與宴會場合。搭配白色或黑色內搭，輕鬆呈現大膽又不失品味的歐式時尚氣場。','tops'),(14,'斜肩氣質荷葉邊上衣',350,20,'images/14.jpg','浪漫一字領斜肩設計突顯鎖骨與肩頸線條，層疊荷葉邊裝飾增添女性柔美氣息。雪紡材質輕盈垂順，穿起來透氣舒適。版型略為寬鬆，適合各種體型，搭配高腰長褲或短裙均能展現迷人的氣質韻味。','tops'),(15,'短版聯名渲染上衣',440,20,'images/15.jpg','品牌聯名企劃獨家推出，手工渲染暈染技法使每件作品色彩獨一無二。短版剪裁搭配高腰褲或裙裝展現比例美感，純棉材質親膚透氣。渲染色彩豐富多層，打造潮流感十足的街頭藝術穿搭風格。','tops');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(10) DEFAULT 'user',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','1234','admin','2026-06-12 17:18:02');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-14 21:43:06
