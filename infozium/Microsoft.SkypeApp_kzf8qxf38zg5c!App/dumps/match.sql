-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: match
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
-- Table structure for table `batsmen`
--

DROP TABLE IF EXISTS `batsmen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `batsmen` (
  `name` varchar(50) DEFAULT NULL,
  `batsman_id` int DEFAULT NULL,
  `runs` int DEFAULT NULL,
  `balls_faced` int DEFAULT NULL,
  `iid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `batsmen`
--

LOCK TABLES `batsmen` WRITE;
/*!40000 ALTER TABLE `batsmen` DISABLE KEYS */;
INSERT INTO `batsmen` VALUES ('Lokesh Rahul',661,22,20,40899),('Mandeep Singh',650,4,6,40899),('Ambati Rayudu',603,20,26,40899),('Manish Pandey',597,0,1,40899),('Kedar Jadhav',621,58,42,40899),('MS Dhoni',123,9,13,40899),('Axar Patel',634,20,11,40899),('Dhawal Kulkarni',643,1,1,40899),('Chamu Chibhabha',181,5,10,40900),('Hamilton Masakadza',185,15,21,40900),('Vusi Sibanda',1804,28,23,40900),('Peter Moor',44121,26,21,40900),('Malcolm Waller',1808,10,17,40900),('Elton Chigumbura',193,16,16,40900),('Timycen Maruma',44156,23,13,40900);
/*!40000 ALTER TABLE `batsmen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bowlers`
--

DROP TABLE IF EXISTS `bowlers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bowlers` (
  `name` varchar(55) DEFAULT NULL,
  `bowler_id` int DEFAULT NULL,
  `overs` int DEFAULT NULL,
  `maidens` int DEFAULT NULL,
  `iid` bigint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bowlers`
--

LOCK TABLES `bowlers` WRITE;
/*!40000 ALTER TABLE `bowlers` DISABLE KEYS */;
INSERT INTO `bowlers` VALUES ('Tendai Chatara',199,4,1,40899),('Donald Tiripano',1810,4,0,40899),('Neville Madziva',44130,4,0,40899),('Chamu Chibhabha',181,4,0,40899),('Graeme Cremer',44132,4,0,40899),('Barinder Sran',785,4,1,40900),('Dhawal Kulkarni',643,4,0,40900),('Jasprit Bumrah',607,4,0,40900),('Axar Patel',634,4,0,40900),('Yuzvendra Chahal',654,4,0,40900);
/*!40000 ALTER TABLE `bowlers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `extra_runs`
--

DROP TABLE IF EXISTS `extra_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `extra_runs` (
  `byes` int DEFAULT NULL,
  `legbyes` int DEFAULT NULL,
  `wides` int DEFAULT NULL,
  `noballs` int DEFAULT NULL,
  `penalty` varchar(10) DEFAULT NULL,
  `total` int DEFAULT NULL,
  `iid` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `extra_runs`
--

LOCK TABLES `extra_runs` WRITE;
/*!40000 ALTER TABLE `extra_runs` DISABLE KEYS */;
INSERT INTO `extra_runs` VALUES (0,1,3,0,'',4,40899),(0,8,3,1,'',12,40900);
/*!40000 ALTER TABLE `extra_runs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fielders`
--

DROP TABLE IF EXISTS `fielders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fielders` (
  `fielder_name` varchar(25) DEFAULT NULL,
  `fielder_id` int DEFAULT NULL,
  `catches` int DEFAULT NULL,
  `stumping` int DEFAULT NULL,
  `iid` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fielders`
--

LOCK TABLES `fielders` WRITE;
/*!40000 ALTER TABLE `fielders` DISABLE KEYS */;
INSERT INTO `fielders` VALUES ('Timycen Maruma',44156,1,0,'40899'),('Elton Chigumbura',193,2,0,'40899'),('Yuzvendra Chahal',654,2,0,'40900'),('Mandeep Singh',650,1,0,'40900'),('Jasprit Bumrah',607,1,0,'40900');
/*!40000 ALTER TABLE `fielders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-10 16:13:45
