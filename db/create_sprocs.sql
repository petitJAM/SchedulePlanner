/*
 * Create stored procedures
 *
 */

delimiter $$
USE `scheduleplanner`$$


# Test proc
DROP PROCEDURE IF EXISTS countusers$$
CREATE PROCEDURE countusers (OUT param1 INT)
BEGIN
	SELECT COUNT(*) INTO param1 FROM `users`;
END$$
 

# Add user
DROP PROCEDURE IF EXISTS adduser$$
CREATE PROCEDURE adduser (name varchar(45), email varchar(255), password varchar(255))
BEGIN
	insert into `users` (`Name`, `Email`, `Password`, `Active_SID`)
				 values (name, email, sha1(password), Null);
END$$


# Add schedule
DROP PROCEDURE IF EXISTS addschedule$$
CREATE PROCEDURE addschedule (userID INT, sdate DATE, edate DATE)
BEGIN
	insert into `schedules` (`UID`, `Start_date`, `End_date`)
					 values (userID, sdate, edate);
END$$


# Add Item
DROP PROCEDURE IF EXISTS additem$$
CREATE PROCEDURE additem (schedID INT, courseID INT, completeby DATETIME, priority INT, notes TEXT, diff INT)
BEGIN
	insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Notes`, `Difficulty`)
				 values (schedID, courseID, completeby, priority, notes, diff);
END$$




delimiter ;

/*
DROP PROCEDURE IF EXISTS sproc_name$$
CREATE PROCEDURE sproc_name ()
BEGIN
	#queries
END$$
*/