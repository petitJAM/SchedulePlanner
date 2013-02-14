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


# (username, examID, CID, Prio, Diff, Date)
DROP PROCEDURE IF EXISTS storeuserexams$$
CREATE PROCEDURE storeuserexams (username varchar(20), eid int(11),	ecid varchar(45), prio tinyint(4), diff tinyint(4), examdate varchar(25))
BEGIN
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT `UID` INTO @UID FROM `users` WHERE `Name` = username;

	SET @alreadythere = (EXISTS (SELECT * FROM `exams` WHERE `IID` = eid));
	#SELECT @alreadythere;
	
	IF @alreadythere THEN
		SELECT `items`.`Complete_by`,  `courses`.`Name`,`items`.`Difficulty`, `items`.`CID` 
				INTO @duedate, @course, @diff, @cid
			FROM `items`, `courses` WHERE `SID` = @SID AND `IID` = eid GROUP BY `items`.`IID`;

		UPDATE `exams` SET `Name` = aname WHERE `IID` = eid;
		commit;

		IF (diff != @diff)THEN
			UPDATE `items` SET `Difficulty` = diff WHERE `SID` = @SID AND `IID` = eid;
			commit;
		END IF;

		IF (examdate != @duedate) THEN
			UPDATE `items` SET `Complete_by` = DATE(examdate) WHERE `SID` = @SID AND `IID` = eid;
			commit;
		END IF;

		IF (ecid != @cid) THEN
			UPDATE `items` SET `CID` = ecid WHERE `SID` = @SID AND `IID` = eid;
			commit;
		END IF;
	ELSE
		insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Difficulty`)
					 values (@SID, ecid, DATE(examdate), prio, diff);
		commit;
		
		select LAST_INSERT_ID() INTO @liid;
		insert into `exams` (`IID`)
						values (@liid);
		commit;
	END IF;
END$$


# (username, workID, job, prio, startdate, enddate)
DROP PROCEDURE IF EXISTS storeuserwork$$
CREATE PROCEDURE storeuserwork (username varchar(20), wid int(11), job varchar(25), prio tinyint(4), startdate varchar(25), enddate varchar(25))
BEGIN
	
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT `UID` INTO @UID FROM `users` WHERE `Name` = username;

	SET @alreadythere = (EXISTS (SELECT * FROM `works` WHERE `IID` = wid));
	#SELECT @alreadythere;
	
	IF @alreadythere THEN
		SELECT `items`.`Complete_by`, `items`.`Priority`, `items`.`Notes`
				INTO @enddate, @prio, @job
			FROM `items` WHERE `IID` = wid GROUP BY `items`.`IID`;
		SELECT `works`.`start_time`
				INTO @startdate
			FROM `works` WHERE `IID` = wid GROUP BY `works`.`IID`;

		IF (job != @job) THEN
			UPDATE `items` SET `Notes` = job WHERE `IID` = wid AND `SID` = @SID;
			commit;
		END IF;

		IF (prio != @prio) THEN
			UPDATE `items` SET `Priority` = prio WHERE `IID` = wid AND `SID` = @SID;
			commit;
		END IF;

		IF (startdate != @startdate) THEN
			UPDATE `works` SET `Start_time` = startdate WHERE `IID` = wid;
			commit;
		END IF;

		IF (enddate != @enddate) THEN
			UPDATE `items` SET `Complete_by` = DATE(enddate) WHERE `IID` = wid AND `SID` = @SID;
			commit;
		END IF;
	ELSE
		# hack
		select `CID` into @hackcid from `courses` limit 1;
	
		insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Difficulty`, `Notes`)
					 values (@SID, @hackcid, DATE(enddate), prio, 0, job);
		commit;
		
		select LAST_INSERT_ID() INTO @liid;
		insert into `works` (`IID`, `Start_time`)
						values (@liid, startdate);
		commit;
	END IF;
END$$


# (username, reminderID, remindertext, prio, rduedate)
DROP PROCEDURE IF EXISTS storeuserreminder$$
CREATE PROCEDURE storeuserreminder (username varchar(20), rid int(11), remindertext text, prio tinyint(4), rduedate varchar(25))
BEGIN
	
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT `UID` INTO @UID FROM `users` WHERE `Name` = username;

	SET @alreadythere = (EXISTS (SELECT * FROM `reminders` WHERE `IID` = rid));
	#SELECT @alreadythere;
	
	IF @alreadythere THEN
		SELECT `items`.`Complete_by`, `items`.`Priority`, `items`.`Notes`
				INTO @rduedate, @prio, @remindertext
			FROM `items` WHERE `IID` = rid GROUP BY `items`.`IID`;

		IF (remindertext != @remindertext) THEN
			UPDATE `items` SET `Notes` = remindertext WHERE `IID` = rid AND `SID` = @SID;
			commit;
		END IF;

		IF (prio != @prio) THEN
			UPDATE `items` SET `Priority` = prio WHERE `IID` = rid AND `SID` = @SID;
			commit;
		END IF;

		IF (rduedate != @rduedate) THEN
			UPDATE `items` SET `Complete_by` = DATE(rduedate) WHERE `IID` = rid AND `SID` = @SID;
			commit;
		END IF;
	ELSE
		# hack
		select `CID` into @hackcid from `courses` limit 1;
	
		insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Difficulty`, `Notes`)
					 values (@SID, @hackcid, DATE(rduedate), prio, 0, remindertext);
		commit;
		
		select LAST_INSERT_ID() INTO @liid;
		insert into `reminders` (`IID`)
						values (@liid);
		commit;
	END IF;
END$$


# (username, meetingID, subject, prio, mduedate)
DROP PROCEDURE IF EXISTS storeusermeetings$$
CREATE PROCEDURE storeusermeetings (username varchar(20), mid int(11), mcid int(11), subject varchar(45), prio tinyint(4), mduedate varchar(25))
BEGIN
	
	SELECT `Active_SID` INTO @SID FROM `users` WHERE `Name` = username;
	SELECT `UID` INTO @UID FROM `users` WHERE `Name` = username;

	SET @alreadythere = (EXISTS (SELECT * FROM `meetings` WHERE `IID` = mid));
	#SELECT @alreadythere;
	
	IF @alreadythere THEN
		SELECT `items`.`Complete_by`, `items`.`Priority`, `items`.`CID`
				INTO @mduedate, @prio, @mcid
			FROM `items` WHERE `IID` = mid GROUP BY `items`.`IID`;

		SELECT `meetings`.`Subject`
				INTO @subject
			FROM `meetings` WHERE `IID` = mid GROUP BY `meetings`.`IID`;

		IF (subject != @subject) THEN
			UPDATE `meetings` SET `Subject` = subject WHERE `IID` = mid AND `SID` = @SID;
			commit;
		END IF;

		IF (mcid != @mcid) THEN
			UPDATE `items` SET `CID` = mcid WHERE `IID` = mid AND `SID`;
			commit;
		END IF;

		IF (prio != @prio) THEN
			UPDATE `items` SET `Priority` = prio WHERE `IID` = mid AND `SID` = @SID;
			commit;
		END IF;

		IF (mduedate != @mduedate) THEN
			UPDATE `items` SET `Complete_by` = DATE(mduedate) WHERE `IID` = mid AND `SID` = @SID;
			commit;
		END IF;
	ELSE
		insert into `items` (`SID`, `CID`, `Complete_by`, `Priority`, `Difficulty`, `Notes`)
					 values (@SID, mcid, DATE(mduedate), prio, 0, subject);
		commit;
		
		select LAST_INSERT_ID() INTO @liid;
		insert into `meetings` (`IID`)
						values (@liid);
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