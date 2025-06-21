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
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `isActive` tinyint DEFAULT '1',
  `assign_order` tinyint(1) DEFAULT '0',
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'abc','xyz','abc123','$2a$10$PXBl5z9UFna/sWafcgU7ru1ncyK/CKupM5GzW9cbnBTdRq0CaQ93i',NULL,0,'2022-02-03 09:43:29','2022-02-03 09:43:29'),(2,'xyz','xyz','xyz123','$2a$10$VY.U4725eftpUe8WTgIba.XEe.ITeA5Zkjc8Yr.LLmo.eOhgGyDli',NULL,0,'2022-02-03 09:51:20','2022-02-03 09:51:20'),(3,'abcxyz','xyz','xyz1234','$2a$10$Lmwx2VKOcZgKpkgDk/LOK.HV/hFRNLXkM017lOP28fy8wDsmC2arS',NULL,0,'2022-02-03 09:51:26','2022-02-07 09:57:07'),(4,'abc','abc','abc','$2a$10$zamxDVitGdStzdRn6FaCvO1MRudEddx45mwI1ItpXh5MF.Dh2rUQe',NULL,0,'2022-02-03 09:56:39','2022-02-03 09:56:39'),(5,'xyz1','xyz','xyz1231','$2a$10$7CUqaoMuvB8OROKWa8ebm.JzvskY/OrHGsaMri5V3ols7ZZX4e7sG',NULL,0,'2022-02-03 10:49:08','2022-02-03 10:49:08'),(6,'xyz2','xyz','xyz1232','$2a$10$IL5AhSnLj2G1HYrE7WHVueUt1cpXx2LvJqlspCGNLtCPgMSP1OFve',NULL,0,'2022-02-03 10:54:38','2022-02-03 10:54:38'),(7,'xyz3','xyz','xyz1233','$2a$10$gZ4UebOv2vlT2tL1EPTFUOf68TnaYfOKTJcmjVHaJg7Pju4MUnno.',NULL,0,'2022-02-03 10:55:05','2022-02-03 10:55:05'),(8,'xyz5','xyz','xyz1235','$2a$10$vQm0cTGgV2Azb0cyjZAV0OtBCeKNyVqMWDVIiG/maN7bzdtMZF6uy',NULL,0,'2022-02-03 10:56:26','2022-02-03 10:56:26'),(9,'xyz6','xyz','xyz1236','$2a$10$H7JaOl.3mbmVUhHlOe2Uruh3zO2U4il4KAcCg6rWelQUQP/jmmzfG',NULL,0,'2022-02-03 10:56:59','2022-02-03 10:56:59'),(10,'sanjay','surat','sanjay@gmail.com','$2a$10$78K9iYs5YP.A4zq6GvDTuusy62knNEjL9JIH2wXM9POQSSt42uFKu',NULL,0,'2022-02-03 10:58:25','2022-02-03 10:58:25'),(11,'xyz8','xyz','xyz1238','$2a$10$lrnGncPI4Me8XdWxi533H.xgxIy14bN09POhG2I1bwrtWHvdbm6N6',NULL,0,'2022-02-03 11:04:46','2022-02-03 11:04:46'),(12,'xyz9','xyz','xyz1239','$2a$10$uhYHr2yp7mfMXTZLRdD8YuByBEu93SIiNtudSLkHGV9T1Zu3UImIq',NULL,0,'2022-02-03 11:06:06','2022-02-03 11:06:06'),(13,'xyz','xyz','xyz12310','$2a$10$9T03lLOvymyyJhkD2HBEguPgqFwBTYRzxWBTU0zNPT//XOe8v/.fW',NULL,0,'2022-02-03 11:06:25','2022-02-03 11:06:25'),(14,'xyz','xyz','xyz12311','$2a$10$tSTjspcZLK8aPhvYrBYkGO2QeVkh/Y5HA2PwyR7xZ8nPxnTwJ1imq',NULL,0,'2022-02-03 11:09:17','2022-02-03 11:09:17'),(15,'xyz','xyz','xyz12312','$2a$10$masGmoeeQV7pAKxkh9108.DdZm0fDLK5DR0wNpvvrtd34UbZtkS3W',NULL,0,'2022-02-03 11:34:07','2022-02-03 11:34:07'),(16,'sasad','asdasd','sadasd','$2a$10$iSic5bi4S1UbmhaBSWhiRuRV5K.yLfXnX/cAs/QEemHRv69Y90JoO',NULL,0,'2022-02-03 11:39:16','2022-02-03 11:39:16'),(17,'rtytrty','tryrtyrty','rtyrty','$2a$10$852EdCItLZbcIXIyAydHveklb/zw/.1aFpJWrNvfoNfqq3Rk4pNK6',NULL,0,'2022-02-03 12:06:33','2022-02-03 12:06:33'),(18,'xyz','asdasd','xyz','$2a$10$RprHWPfuIOkFFi5Mu1KJ7u79QAgbO7Z8PjMdBR4BLyOGo6s0xbVhe',NULL,0,'2022-02-03 12:07:07','2022-02-03 12:07:07'),(19,'abc','xyz','abc123456789','$2a$10$mqIF5zbOMh2NMxpzT53zbeaseHqpTo05mXnfiwpsnztD7WgaECQ2u',NULL,0,'2022-02-04 05:55:45','2022-02-04 05:55:45'),(20,'abc','xyz','a9','$2a$10$E5k/pTYV/oQ/WjPZX5o5Xu4KdVG91qMgaMb10JmC263GOMHUXV/Hu',1,0,'2022-02-04 10:16:54','2022-02-04 10:16:54'),(21,'abc','xyz','a9,j.','$2a$10$FMP3UBNqUJ9vTcEfFOgAz..wCr.P8gfkIrktLCZZg4axN/wpttcsW',1,0,'2022-02-04 10:18:01','2022-02-04 10:18:01'),(22,'abc','xyz','a9,jx.','$2a$10$Psf9QsMTDCtNC2bC7FS.WeGR.1G6CW3Aikye3GdK.81DKcDaibsWe',0,0,'2022-02-04 10:32:06','2022-02-09 11:07:09'),(23,'test-11','test-11','test-11','$2a$10$5orvuldUSqI3HWZ4WOsr/.FPr4HXsogLjIAXHeknz55DBsUwIO/.S',1,0,'2022-02-07 10:55:10','2022-02-07 10:55:10');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
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
