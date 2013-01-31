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
CREATE PROCEDURE adduser (@name varchar(45), email varchar(255), password varchar(255))
BEGIN
	insert into `users` (`Name`, `Email`, `Password`, `Active_SID`)
				 values (@name, email, sha1(password), Null);
END$$


delimiter ;