delimiter $$

DROP VIEW IF EXISTS `user_items`$$
CREATE VIEW `user_items` AS
SELECT `u`.`UID` AS `UID`,
	   `u`.`Name` AS `UserName`,
	   `u`.`Active_SID` AS `SID`,
	   `i`.`IID` AS `IID`,
	   `i`.`Complete_by` AS `CompleteBy`
	   ,`i`.`Priority` AS `P`,
	   `i`.`Notes` AS `Notes`,
	   `i`.`Difficulty` AS `D`,
	   `c`.`Name` AS `CourseName`,
	   `t`.`Name` AS `TeacherName`,
	   `a`.`Name` AS `AssignmentName`,
	   `m`.`Subject` AS `MeetingSubject`,
	   `w`.`Start_time` AS `WorkStartTime`,
	   `a`.`IID` AS `Assignment`,
	   `e`.`IID` AS `Exam`,
	   `m`.`IID` AS `Meeting`,
	   `r`.`IID` AS `Reminder`,
	   `w`.`IID` AS `Work`
 FROM
	`items` `i`
	left join `users` `u` on `i`.`SID` = `u`.`Active_SID`
	left join `courses` `c` on `i`.`CID` = `c`.`CID`
	left join `teachers` `t` on `c`.`TID` = `t`.`TID`
	left join `assignments` `a` on `i`.`IID` = `a`.`IID`
	left join `exams` `e` on `i`.`IID` = `e`.`IID`
	left join `meetings` `m` on `i`.`IID` = `m`.`IID`
	left join `reminders` `r` on `i`.`IID` = `r`.`IID`
	left join `works` `w` on `i`.`IID` = `w`.`IID`$$