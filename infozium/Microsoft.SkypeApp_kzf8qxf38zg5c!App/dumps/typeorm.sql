-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: typeorm
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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `Admin_id` int NOT NULL AUTO_INCREMENT,
  `Admin_name` varchar(255) NOT NULL,
  `Admin_Role` enum('Admin','SubAdmin') NOT NULL DEFAULT 'SubAdmin',
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `Age` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`Admin_id`),
  UNIQUE KEY `IDX_a9823802f0ff1505cc3a61c108` (`Admin_name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES (1,'admin1','SubAdmin',0,0),(3,'admin127451','SubAdmin',1,0),(4,'admin1274','SubAdmin',1,0),(8,'admin','Admin',1,0),(9,'admin0498845','Admin',0,0);
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Photo`
--

DROP TABLE IF EXISTS `Photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Photo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_6ff0ce6d7dd7fb0eb868c36bf96` (`userId`),
  CONSTRAINT `FK_6ff0ce6d7dd7fb0eb868c36bf96` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Photo`
--

LOCK TABLES `Photo` WRITE;
/*!40000 ALTER TABLE `Photo` DISABLE KEYS */;
INSERT INTO `Photo` VALUES (1,'a',3),(2,'b',8),(3,'a',9),(4,'b',9),(5,'a',10),(6,'b',10),(7,'a',11),(8,'b',11),(9,'a',12),(10,'b',3),(11,'a',13),(12,'b',13),(13,'a',14),(14,'b',14),(15,'b',3),(16,'b',NULL);
/*!40000 ALTER TABLE `Photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Profile`
--

DROP TABLE IF EXISTS `Profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Profile` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gender` varchar(255) NOT NULL,
  `photo` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Profile`
--

LOCK TABLES `Profile` WRITE;
/*!40000 ALTER TABLE `Profile` DISABLE KEYS */;
INSERT INTO `Profile` VALUES (1,'male','a.jpg'),(2,'male','a.jpg'),(3,'male','a.jpg'),(4,'male','a.jpg'),(5,'male','a.jpg'),(6,'male','a.jpg'),(7,'male','a.jpg'),(8,'male','a.jpg'),(9,'male','a.jpg'),(10,'male','a.jpg'),(11,'male','a.jpg');
/*!40000 ALTER TABLE `Profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL DEFAULT '',
  `age` int NOT NULL DEFAULT '0',
  `profileId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `REL_654d8b4ea5b99b309ea9d8498a` (`profileId`),
  CONSTRAINT `FK_654d8b4ea5b99b309ea9d8498a9` FOREIGN KEY (`profileId`) REFERENCES `Profile` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (3,'adasd','b',1000,NULL),(5,'a','b',12,NULL),(6,'smith','',0,3),(7,'smith','',0,4),(8,'allen','',0,11),(9,'allen','',0,NULL),(10,'allen','',0,NULL),(11,'allen','',0,NULL),(12,'allen','',0,NULL),(13,'allen','',0,NULL),(14,'allen','',0,NULL),(15,'smith','',0,5),(16,'smith','',0,6),(17,'smith','',0,7),(18,'smith','',0,NULL),(19,'smith','',0,9),(20,'jeff','',0,NULL),(21,'jeff','',0,NULL),(22,'abx','',0,NULL),(23,'jeff','',0,NULL),(24,'abx','',0,NULL),(25,'jeff','',0,NULL),(26,'abx','',0,NULL),(27,'jeff','',0,NULL),(28,'abx','',0,NULL),(29,'jeff','',0,NULL),(30,'abx','',0,NULL),(31,'jeff','',0,NULL),(32,'abx','',0,NULL),(33,'jeff','',0,NULL),(34,'abx','',0,NULL),(35,'jeff','',0,NULL),(36,'abx','',0,NULL),(37,'jeff','',0,NULL),(38,'abx','',0,NULL),(39,'jeff','',0,NULL),(40,'abx','',0,NULL),(41,'jeff','',0,NULL),(42,'abx','',0,NULL),(43,'Mac','he;;;',1000,NULL),(44,'Mac','he;;;',1000,NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (4,1643430543618,'test1643430543618');
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-10 16:14:00
