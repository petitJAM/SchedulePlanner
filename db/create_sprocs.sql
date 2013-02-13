exams/*
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
CREATE PROCEDURE addcoursetoschedule (schedID INT, courseID INT, difficulty TINYINT)
BEGIN
	insert into `coursesinschedules` (`SID`, `CID`, `Difficulty`) values (schedID, courseID, difficulty);
END$$

# Remove All Courses from Schedule
DROP PROCEDURE IF EXISTS removeallcoursesfromuserschedule$$
CREATE PROCEDURE removeallcoursesfromuserschedule (schedID INT, cID INT)
BEGIN
	delete from `coursesinschedules` where `SID`=schedID AND `CID`=cID;
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


# Add Teachers
DROP PROCEDURE IF EXISTS addteacher$$
CREATE PROCEDURE addteacher (name varchar(45), Department varchar(45))
BEGIN
	insert into `teachers` (`Name`, `Department`)
				 values (name, department);
END$$


# Get Schedule   user_items
DROP PROCEDURE IF EXISTS getuseritems$$
CREATE PROCEDURE getuseritems (username varchar(20))
BEGIN
	SELECT * FROM `user_items` UI WHERE UI.`UserName` = username;
END$$


DROP PROCEDURE IF EXISTS getuserassignments$$
CREATE PROCEDURE getuserassignments (username varchar(20))
BEGIN
	SELECT 
		a.`Name` AS `AssignmentName`,
		a.`IID` AS `AssignmentID`,
		`items`.`Complete_by` AS `Complete_by`,
		`items`.`Priority` AS `P`,
		`items`.`Notes` AS `Notes`,
		`items`.`Difficulty` AS `D`,
		`courses`.`Name` AS `CourseName`,
		`courses`.`CID` AS `CourseID`
	FROM 
		((((
		`assignments` a 
		left join `items` on a.`IID` = `items`.`IID`)
		left join `schedules` on `items`.`SID` = `schedules`.`SID`)
		left join `courses` on `items`.`CID` = `courses`.`CID`)
		left join `users` on `schedules`.`SID` = `users`.`Active_SID`)
		WHERE `users`.`Name` = username;
END$$


DROP PROCEDURE IF EXISTS getuserexams$$
CREATE PROCEDURE getuserexams (username varchar(20))
BEGIN
	SELECT 
		e.`IID` AS `ExamID`,
		`items`.`Complete_by` AS `Date`,
		`items`.`Priority` AS `P`,
		`items`.`Notes` AS `Notes`,
		`items`.`Difficulty` AS `D`,
		`courses`.`Name` AS `CourseName`,
		`courses`.`CID` AS `CourseID`
	FROM 
		((((
		`exams` e 
		left join `items` on e.`IID` = `items`.`IID`)
		left join `schedules` on `items`.`IID` = `schedules`.`SID`)
		left join `courses` on `items`.`CID` = `courses`.`CID`)
		left join `users` on `schedules`.`SID` = `users`.`Active_SID`)
		WHERE `users`.`Name` = username;
END$$


DROP PROCEDURE IF EXISTS getuserwork$$
CREATE PROCEDURE getuserwork (username varchar(20))
BEGIN
	SELECT 
		w.`IID` AS `WorkID`,
		`items`.`Notes` AS `WorkName`,
		w.`Start_time` AS `Start_time`,
		`items`.`Complete_by` AS `End_time`,
		DATE(`items`.`Complete_by`) AS `Date`,
		`items`.`Priority` AS `P`,
		`items`.`Difficulty` AS `D`
	FROM 
		(((
		`works` w
		left join `items` on w.`IID` = `items`.`IID`)
		left join `schedules` on `items`.`IID` = `schedules`.`SID`)
		left join `users` on `schedules`.`SID` = `users`.`Active_SID`)
		WHERE `users`.`Name` = username;
END$$


DROP PROCEDURE IF EXISTS getuserreminders$$
CREATE PROCEDURE getuserreminders (username varchar(20))
BEGIN
	SELECT
		r.`IID` AS `ReminderID`,
		`items`.`Complete_by` AS `Complete_by`,
		`items`.`Priority` AS `P`,
		`items`.`Notes` AS `Notes`,
		`items`.`Difficulty` AS `D`
	FROM 
		(((
		`reminders` r 
		left join `items` on r.`IID` = `items`.`IID`)
		left join `schedules` on `items`.`IID` = `schedules`.`SID`)
		left join `users` on `schedules`.`SID` = `users`.`Active_SID`)
		WHERE `users`.`Name` = username;
END$$


DROP PROCEDURE IF EXISTS getusermeetings$$
CREATE PROCEDURE getusermeetings (username varchar(20))
BEGIN
	SELECT
		m.`IID` AS `MeetingID`,
		m.`Subject` AS `Subject`,
		TIME(`items`.`Complete_by`) AS `Time`,
		DATE(`items`.`Complete_by`) AS `Date`,
		`items`.`Priority` AS `P`,
		`items`.`Notes` AS `Notes`,
		`items`.`Difficulty` AS `D`
	FROM 
		((((
		`meetings` m 
		left join `items` on m.`IID` = `items`.`IID`)
		left join `schedules` on `items`.`IID` = `schedules`.`SID`)
		left join `courses` on `items`.`CID` = `courses`.`CID`)
		left join `users` on `schedules`.`SID` = `users`.`Active_SID`)
		WHERE `users`.`Name` = username;
END$$


DROP PROCEDURE IF EXISTS getusercourses$$
CREATE PROCEDURE getusercourses (username varchar(20))
BEGIN
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT
		username AS `UserName`,
		c.`CID` AS `CourseID`,
		c.`Name` AS `CourseName`,
		t.`TID` AS `TeacherID`,
		t.`Name`AS `TeacherName`,
		cis.`Difficulty` AS `Difficulty`

	FROM 
		`coursesinschedules` cis
		left join `courses` c on cis.`CID` = c.`CID`
		left join `teachers` t on c.`TID` = t.`TID`
	WHERE cis.`SID` = @SID;
	#GROUP BY `CourseName`;
END$$


# (username, assignmentID, assignmentName, CID, Prio, Diff, Duedate)
DROP PROCEDURE IF EXISTS storeuserassignments$$
CREATE PROCEDURE storeuserassignments (username varchar(20), aid int(11), aname varchar(45), 
	acid varchar(45), aprio tinyint(4), adiff tinyint(4), aduedate varchar(25))
BEGIN
	
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT `UID` INTO @UID FROM `users` WHERE `Name` = username;

	SET @alreadythere = (EXISTS (SELECT * FROM `assignments` WHERE `IID` = aid));
	#SELECT @alreadythere;
	
	IF @alreadythere THEN
		SELECT `items`.`Complete_by`,  `courses`.`Name`,`items`.`Difficulty`, `items`.`CID` 
				INTO @duedate, @course, @diff, @cid
			FROM `items`, `courses` WHERE `SID` = @SID AND `IID` = aid GROUP BY `items`.`IID`;

		UPDATE `assignments` SET `Name` = aname WHERE `IID` = aid;
		commit;

		IF (adiff != @diff)THEN
			UPDATE `items` SET `Difficulty` = adiff WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;

		IF (aduedate != @duedate) THEN
			UPDATE `items` SET `Complete_by` = DATE(aduedate) WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;

		IF (acid != @cid) THEN
			UPDATE `items` SET `CID` = acid WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;
	ELSE
		insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Difficulty`)
					 values (@SID, acid, DATE(aduedate), aprio, adiff);
		commit;
		
		select LAST_INSERT_ID() INTO @liid;
		insert into `assignments` (`IID`, `Name`)
						values (@liid, aname);
		commit;
	END IF;
END$$


/*
DROP PROCEDURE IF EXISTS storeuserassignments$$
CREATE PROCEDURE storeuserassignments (username varchar(20), aid int(11),
 aname varchar(45), acid varchar(45), adiff tinyint(4), aduedate varchar(25))
BEGIN

	IF (EXISTS (SELECT * FROM `assignments` WHERE `IID` = aid)) THEN
		SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
		
		SELECT `items`.`Complete_by`,  `courses`.`Name`,`items`.`Difficulty`, `items`.`CID` 
				INTO @duedate, @course, @diff, @cid
			FROM `items`, `courses` WHERE `SID` = @SID AND `IID` = aid GROUP BY `items`.`IID`;
		
		UPDATE `assignments` SET `Name` = aname WHERE `IID` = aid;
		commit;

		IF (adiff != @diff)THEN
			UPDATE `items` SET `Difficulty` = adiff WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;

		IF (aduedate != @duedate) THEN
			UPDATE `items` SET `Complete_by` = aduedate WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;

		IF (acid != @cid) THEN
			UPDATE `items` SET `CID` = acid WHERE `SID` = @SID AND `IID` = aid;
			commit;
		END IF;
	ELSE
		# new
		INSERT INTO `assignments` (`Name`) VALUES (aname);
		commit;
		INSERT INTO `items` (`SID`, `CID`, `Difficulty`, `Complete_by`)
					 VALUES (@SID, acid, adiff, DATE(aduedate));
		commit;
	END IF;
	

END$$
	

delimiter ;

/*
DROP PROCEDURE IF EXISTS sproc_name$$
CREATE PROCEDURE sproc_name ()
BEGIN
	#queries
END$$
*/