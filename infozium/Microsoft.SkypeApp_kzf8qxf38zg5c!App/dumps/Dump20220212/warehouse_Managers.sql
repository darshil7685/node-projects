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
-- Table structure for table `Managers`
--

DROP TABLE IF EXISTS `Managers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Managers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `hash` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `isActive` tinyint DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Managers`
--

LOCK TABLES `Managers` WRITE;
/*!40000 ALTER TABLE `Managers` DISABLE KEYS */;
INSERT INTO `Managers` VALUES (1,'abc','xyz','abc123','$2a$10$lVUyNtTy2s8HD.a8TiM47uRhyjECp9zc3xmnM/Ays5tqmGVPKLpLG','2022-02-03 10:43:17','2022-02-03 10:43:17',NULL),(2,'Abhishek','surat','abhi@test.com','$2a$10$oSbAk9h/v16oMgRu0Zubo.c3Sxn2hoiqs2aLrGF9XFyWRe75HEQaa','2022-02-04 04:26:19','2022-02-04 12:32:26',1),(3,'abc','xyz','abc123456','$2a$10$mGQi3GKxHqc0BJfb0Oq0GuKJWPh6o2bdxNodEx8Vwb2vxc/z8tOi6','2022-02-04 10:24:52','2022-02-04 10:24:52',NULL),(4,'abc','xyz','abc123456789','$2a$10$2/R5fUvYLyqHSH6R6C5Dee2pK0cdNRzWMf4uWcyFKJNZb59M62mti','2022-02-04 10:28:58','2022-02-04 10:28:58',1),(5,'abc','xyz','abc1234567890','$2a$10$N7u9PmeG51jx8TSKqhjvG.T533IOYwuiZt3/LUCB/TYaXSo/uzgGm','2022-02-04 10:31:01','2022-02-10 04:55:46',1),(6,'brijesh','surat','brijesh@test.com','$2a$10$XQz47BK3J6pdFm.7VqY2fewlhZNcyzUXikfHBSOGIDJscyDRiiCTy','2022-02-05 06:47:15','2022-02-05 06:47:15',1),(7,'test7','test7','test7@test.com','$2a$10$zk0EfZdL6ZF2gBybiFpxteksOtQ7UKvHUa.jfT98Tc28CxTkB0Hra','2022-02-07 09:03:50','2022-02-07 09:03:50',1),(8,'test','test','test@test.com','$2a$10$Tv4.coaD5f4zRF9O6zAR8u26KlQteN23xU40/VruyM61LZS5GxyV2','2022-02-07 09:15:00','2022-02-07 09:15:00',1),(9,'test2','test2','test2@test.com','$2a$10$goi9OVZCScsFBfb7bFYJ3.nt91SnoVeG/HXL.8HgCYSOObEWh44x6','2022-02-07 09:15:18','2022-02-07 09:15:18',1),(10,'test-3','test3','test3@test.com','$2a$10$0Hgk07wWiXb59rgVPAU0K.cUluVeUtS9kRR56sYfEbbtdpKn4m0Cy','2022-02-07 09:16:00','2022-02-07 09:16:00',1),(11,'test-4','test-4','test4@test.com','$2a$10$nvUCvvb2UoDsol3fhzDJzeiJMc0HZPpFLP2ZXEOJ04qZe4CNUMSMK','2022-02-07 09:16:36','2022-02-07 09:16:36',1),(12,'ram','neemuch','ram@gmail.com','$2a$10$gEVCBo5wPzaNbC1knL5R0.bmK7PABqBHoXhUTYFX4SMM/mkjxf.Ii','2022-02-11 12:58:52','2022-02-11 12:58:52',1);
/*!40000 ALTER TABLE `Managers` ENABLE KEYS */;
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
