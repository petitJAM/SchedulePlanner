-- MySQL dump 10.13  Distrib 5.5.29, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: SchedulePlanner
-- ------------------------------------------------------
-- Server version	5.5.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assignment`
--

DROP TABLE IF EXISTS `assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignment` (
  `IID` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_assignment` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course` (
  `CID` int(11) NOT NULL,
  `TID` int(11) NOT NULL,
  `Name` varchar(45) NOT NULL,
  `Start_time` time DEFAULT NULL COMMENT 'Start hour of the course. Ex: 9:55 am',
  `End_time` time DEFAULT NULL,
  `Difficulty` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`CID`,`TID`),
  KEY `TID_idx` (`TID`),
  CONSTRAINT `TID` FOREIGN KEY (`TID`) REFERENCES `teacher` (`TID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam`
--

DROP TABLE IF EXISTS `exam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exam` (
  `IID` int(11) NOT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_exam` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item` (
  `IID` int(11) NOT NULL,
  `SID` int(11) NOT NULL,
  `CID` int(11) NOT NULL,
  `Complete_by` datetime DEFAULT NULL,
  `Priority` tinyint(4) NOT NULL DEFAULT '0',
  `Notes` text,
  `Difficulty` tinyint(4) NOT NULL,
  PRIMARY KEY (`IID`,`CID`,`SID`),
  KEY `SID_idx` (`SID`),
  KEY `CID_idx` (`CID`),
  CONSTRAINT `SID` FOREIGN KEY (`SID`) REFERENCES `schedule` (`SID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `CID` FOREIGN KEY (`CID`) REFERENCES `course` (`CID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `meeting`
--

DROP TABLE IF EXISTS `meeting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `meeting` (
  `IID` int(11) NOT NULL,
  `Subject` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_meeting` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reminder`
--

DROP TABLE IF EXISTS `reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reminder` (
  `IID` int(11) NOT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_reminder` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `SID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  `Start_date` date DEFAULT NULL,
  `End_date` date DEFAULT NULL,
  PRIMARY KEY (`SID`,`UID`),
  KEY `UID_idx` (`UID`),
  CONSTRAINT `UID` FOREIGN KEY (`UID`) REFERENCES `user` (`UID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teacher` (
  `TID` int(11) NOT NULL,
  `Name` varchar(70) DEFAULT NULL,
  `Department` varchar(45) DEFAULT NULL,
  `Difficulty` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `UID` int(11) NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` char(40) NOT NULL,
  `Active_SID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `work`
--

DROP TABLE IF EXISTS `work`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `work` (
  `IID` int(11) NOT NULL,
  `Start_time` datetime DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_work` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-01-17  9:53:23
