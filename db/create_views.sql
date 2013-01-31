delimiter $$

DROP VIEW IF EXISTS `user_items`$$
CREATE VIEW `user_items` AS 
SELECT `items`.`IID` AS `IID`,`items`.`SID` AS `SID`,`items`.`CID` AS `CID`,
	   `items`.`Complete_by` AS `Complete_by`,`items`.`Priority` AS `Priority`,
	   `items`.`Notes` AS `Notes`,`items`.`Difficulty` AS `Difficulty` 
	FROM `items` JOIN `users`
	WHERE `items`.`SID` in 
		(SELECT `users`.`Active_SID` FROM `users`)$$


delimiter ;