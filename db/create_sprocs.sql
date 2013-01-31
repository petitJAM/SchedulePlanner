/*
 * Create stored procedures
 *
 */

delimiter $$
USE `scheduleplanner`$$


# Test proc
DROP PROCEDURE IF EXISTS countusers$$
#CREATE PROCEDURE countusers (OUT param1 INT)
#BEGIN
#	SELECT COUNT(*) INTO param1 FROM `users`;
#END$$
 

# Add user
DROP PROCEDURE IF EXISTS adduser$$
CREATE PROCEDURE adduser (name varchar(45), email varchar(255), password varchar(255))
BEGIN
	insert into `users` (`Name`, `Email`, `Password`, `Active_SID`)
				 values (name, email, sha1(password), Null);
END$$


# Add Schedule
DROP PROCEDURE IF EXISTS addschedule$$
CREATE PROCEDURE addschedule (userID INT, sdate DATE, edate DATE)
BEGIN
	insert into `schedules` (`UID`, `Start_date`, `End_date`)
					 values (userID, sdate, edate);
	select LAST_INSERT_ID() into @liid;
	update `users` set `Active_SID` = @liid where `UID` = userID;
END$$


# Add Course to Schedule
DROP PROCEDURE IF EXISTS addcoursetoschedule$$
CREATE PROCEDURE addcoursetoschedule (schedID INT, courseID INT)
BEGIN
	insert into `coursesinschedules` (`SID`, `CID`) values (schedID, courseID);
END$$


# Add Item
DROP PROCEDURE IF EXISTS additem$$
CREATE PROCEDURE additem (schedID INT, courseID INT, completeby varchar(20), 
						  priority INT, notes TEXT, diff INT)
BEGIN
	insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Notes`, `Difficulty`)
				 values (schedID, courseID, completeby, priority, notes, diff);
END$$


# Add Assignment
DROP PROCEDURE IF EXISTS addassignment$$
CREATE PROCEDURE addassignment (name varchar(45), userID INT, courseID INT, 
								completeby varchar(20), priority INT, notes TEXT, diff INT)
BEGIN
	SELECT `Active_SID` into @schedID FROM `users` WHERE `UID`=userID;
	CALL additem (@schedID, courseID, completeby, priority, notes, diff);

	SELECT LAST_INSERT_ID() INTO @liid;
	insert into `assignments` (`IID`, `Name`) values (@liid, name);
END$$


# Delete Assignment
DROP PROCEDURE IF EXISTS delassignment$$
CREATE PROCEDURE delassignment (assignID INT)
BEGIN
	DELETE FROM `assignments` WHERE `IID` = assignID;
END$$


# Add Exam
DROP PROCEDURE IF EXISTS addexam$$
CREATE PROCEDURE addexam (userID INT, courseID INT, completeby varchar(20), 
						  priority INT, notes TEXT, diff INT)
BEGIN
	SELECT `Active_SID` into @schedID FROM `users` WHERE `UID`=userID;
	CALL additem (@schedID, courseID, completeby, priority, notes, diff);

	SELECT LAST_INSERT_ID() INTO @liid;
	insert into `exams` (`IID`) values (@liid);
END$$


# Delete 
DROP PROCEDURE IF EXISTS delexam$$
CREATE PROCEDURE delexam (examID INT)
BEGIN
	DELETE FROM `exams` WHERE `IID` = examID;
END$$


# Add Meeting
DROP PROCEDURE IF EXISTS addmeeting$$
CREATE PROCEDURE addmeeting (subj varchar(45), userID INT, courseID INT, 
							 completeby varchar(20), priority INT, notes TEXT, diff INT)
BEGIN
	SELECT `Active_SID` into @schedID FROM `users` WHERE `UID`=userID;
	CALL additem (@schedID, courseID, completeby, priority, notes, diff);

	SELECT LAST_INSERT_ID() INTO @liid;
	insert into `meetings` (`IID`, `Subject`) values (@liid, subj);
END$$


# Delete Meeting
DROP PROCEDURE IF EXISTS delmeeting$$
CREATE PROCEDURE delmeeting (meetingID INT)
BEGIN
	DELETE FROM `meetings` WHERE `IID` = meetingID;
END$$


# Add Reminder
DROP PROCEDURE IF EXISTS addreminder$$
CREATE PROCEDURE addreminder (userID INT, courseID INT, completeby varchar(20), 
							  priority INT, notes TEXT, diff INT)
BEGIN
	SELECT `Active_SID` into @schedID FROM `users` WHERE `UID`=userID;
	CALL additem (@schedID, courseID, completeby, priority, notes, diff);

	SELECT LAST_INSERT_ID() INTO @liid;
	insert into `reminders` (`IID`) values (@liid);
END$$


# Delete Reminder
DROP PROCEDURE IF EXISTS delreminder$$
CREATE PROCEDURE delreminder (reminID INT)
BEGIN
	DELETE FROM `reminders` WHERE `IID` = reminID;
END$$


# Add Work
DROP PROCEDURE IF EXISTS addwork$$
CREATE PROCEDURE addwork (stime varchar(45), userID INT, courseID INT, 
						  completeby varchar(20), priority INT, notes TEXT, diff INT)
BEGIN
	SELECT `Active_SID` into @schedID FROM `users` WHERE `UID`=userID;
	CALL additem (@schedID, courseID, completeby, priority, notes, diff);

	SELECT LAST_INSERT_ID() INTO @liid;
	insert into `works` (`IID`, `Start_time`) values (@liid, TIME(subj));
END$$


# Delete Work
DROP PROCEDURE IF EXISTS delwork$$
CREATE PROCEDURE delwork (workID INT)
BEGIN
	DELETE FROM `works` WHERE `IID` = workID;
END$$


# New Active Schedule
DROP PROCEDURE IF EXISTS activateschedule$$
CREATE PROCEDURE activateschedule (schedID INT)
BEGIN
	SELECT `UID` INTO @uid FROM `schedules` WHERE `SID` = schedID;
	UPDATE `users` SET `Active_SID` = schedID WHERE `UID` = @uid;
END$$


# verify username/password
# example: SELECT verifyusernamepassword('Vismay', sha1('Vismay123'));
# could modify to return integer representing success/failure type
# for example, 0 - valid, 1 - wrong password, 2 - invalid username
DROP FUNCTION IF EXISTS verifyusernamepassword$$
CREATE FUNCTION verifyusernamepassword (username varchar(20), hpasswd varchar(40))
RETURNS BOOL
BEGIN
	SELECT `Password` INTO @hpwd FROM `users` WHERE `Name` = username;

	IF @hpwd = hpasswd
	THEN RETURN TRUE;
	ELSE RETURN FALSE;
	END IF;
END$$


# 


delimiter ;

/*
DROP PROCEDURE IF EXISTS sproc_name$$
CREATE PROCEDURE sproc_name ()
BEGIN
	#queries
END$$
*/