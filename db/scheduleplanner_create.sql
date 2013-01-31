/*
 * Create the scheduleplanner schema along with all of our tables.
 * 
 * @author Alex Petitjean
 */


delimiter $$

DROP DATABASE IF EXISTS `scheduleplanner`$$

CREATE DATABASE `scheduleplanner` /*!40100 DEFAULT CHARACTER SET latin1 */$$

USE `scheduleplanner`$$

CREATE TABLE `teacher` (
  `TID` int(11) NOT NULL,
  `Name` varchar(70) DEFAULT NULL,
  `Department` varchar(45) DEFAULT NULL,
  `Difficulty` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


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
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `user` (
  `UID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Password` char(40) NOT NULL,
  `Active_SID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UID`),
  KEY `Active_SID_fk_idx` (`Active_SID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1$$


CREATE TABLE `schedule` (
  `SID` int(11) NOT NULL,
  `UID` int(11) NOT NULL,
  `Start_date` date DEFAULT NULL,
  `End_date` date DEFAULT NULL,
  PRIMARY KEY (`SID`,`UID`),
  KEY `UID_idx` (`UID`),
  CONSTRAINT `UID` FOREIGN KEY (`UID`) REFERENCES `user` (`UID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$

ALTER TABLE `user` 
	ADD CONSTRAINT `Active_SID_fk` 
	FOREIGN KEY (`Active_SID`) 
	REFERENCES `schedule` (`SID`) 
	ON DELETE CASCADE 
	ON UPDATE CASCADE$$


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
  CONSTRAINT `CID` FOREIGN KEY (`CID`) REFERENCES `course` (`CID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `SID` FOREIGN KEY (`SID`) REFERENCES `schedule` (`SID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `assignment` (
  `IID` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_assignment` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `meeting` (
  `IID` int(11) NOT NULL,
  `Subject` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_meeting` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `reminder` (
  `IID` int(11) NOT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_reminder` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `exam` (
  `IID` int(11) NOT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_exam` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `work` (
  `IID` int(11) NOT NULL,
  `Start_time` datetime DEFAULT NULL,
  PRIMARY KEY (`IID`),
  CONSTRAINT `IID_work` FOREIGN KEY (`IID`) REFERENCES `item` (`IID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


CREATE TABLE `coursesinschedule` (
  `SID` int(11) NOT NULL,
  `CID` int(11) NOT NULL,
  PRIMARY KEY (`SID`,`CID`),
  KEY `SID_fk_idx` (`SID`),
  KEY `CID_fk_idx` (`CID`),
  CONSTRAINT `SID_fk` FOREIGN KEY (`SID`) REFERENCES `schedule` (`SID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `CID_fk` FOREIGN KEY (`CID`) REFERENCES `course` (`CID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


