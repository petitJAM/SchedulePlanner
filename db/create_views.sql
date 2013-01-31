delimiter $$

DROP VIEW IF EXISTS `user_items`$$
CREATE VIEW `user_items` AS 
SELECT U.`UID` AS UID, U.`Name` AS UserName, U.`Active_SID` AS SID,
	   I.`IID` AS IID, I.`Complete_by` AS CompleteBy, I.`Priority` AS P, 
	   I.`Notes` AS Notes, I.`Difficulty` AS D, 
	   C.`Name` AS CourseName, T.`Name` AS TeacherName
	FROM `users` U 
		 RIGHT JOIN `items` I
		 ON I.`SID` = U.`Active_SID`
		 LEFT JOIN `courses` C
		 ON I.`CID` = C.`CID`
		 LEFT JOIN
		 `teachers` T
		 ON C.`TID` = T.`TID`$$


delimiter ;