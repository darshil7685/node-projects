-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: warehouse
-- ------------------------------------------------------
-- Server version	8.0.28-0ubuntu0.20.04.3

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

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL DEFAULT '0',
  `be_order_id` varchar(100) NOT NULL DEFAULT '0',
  `order_type` varchar(50) NOT NULL DEFAULT '0',
  `mode` varchar(50) NOT NULL DEFAULT '0',
  `user_id` int NOT NULL DEFAULT '0',
  `amount_payable` varchar(50) NOT NULL DEFAULT '0',
  `order_status` varchar(100) NOT NULL DEFAULT '0',
  `date` varchar(100) NOT NULL DEFAULT '0',
  `vendor_id` int NOT NULL DEFAULT '0',
  `shipment_status` varchar(50) NOT NULL DEFAULT '0',
  `address_id` varchar(50) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'BEOD_1630400361BQD','Individual Order','COD',10,'770','Order Placed','July 20, 2021, 12:36 pm',79,'Processing','BESH_P5NOZ0C2RL','2022-02-09 09:16:06'),(2,'BEOD_1626765025V7L','Individual Order','COD',10,'770','Order Placed','July 20, 2021, 12:40 pm',79,'Processing','BESH_P5NOZ0C2RL','2021-07-20 07:36:26'),(0,'BEOD_1629990761KQ5','cod','0',1,'0','0','0',0,'0','0','2022-02-09 10:20:30'),(0,'OD134307898','cod','0',3,'0','0','0',0,'0','0','2022-02-09 10:21:29'),(0,'BEOD_1630163346BI8','0','0',7,'0','0','0',0,'0','0','2022-02-09 10:28:41'),(0,'OD000028465','0','0',0,'0','0','0',0,'0','0','2022-02-10 11:27:00'),(0,'OD00025897','0','0',0,'0','0','0',0,'0','0','2022-02-10 11:27:59'),(0,'OD000880950','0','0',11,'0','0','0',0,'0','0','2022-02-10 11:40:41'),(0,'OD156265429','0','0',13,'0','0','0',0,'0','0','2022-02-11 04:18:38'),(0,'OD083682139','0','0',23,'0','0','0',0,'0','0','2022-02-11 04:20:22'),(0,'OD083838586','0','0',24,'0','0','0',0,'0','0','2022-02-11 04:23:27'),(0,'OD551572213','0','0',25,'0','0','0',0,'0','0','2022-02-11 04:23:54'),(0,'OD553335929','0','0',26,'0','0','0',0,'0','0','2022-02-11 04:24:12'),(0,'OD553402364','0','0',27,'0','0','0',0,'0','0','2022-02-11 04:24:28'),(0,'OD942656460','0','0',28,'0','0','0',0,'0','0','2022-02-11 07:19:19'),(0,'OD943855490','0','0',29,'0','0','0',0,'0','0','2022-02-11 07:19:44'),(0,'OD9480651089','0','0',30,'0','0','0',0,'0','0','2022-02-11 07:20:12');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-02-12 10:59:59
