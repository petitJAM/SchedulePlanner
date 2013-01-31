/*
 * Insert some test data
 */

insert into `teachers` (`TID`, `Name`, `Department`, `Difficulty`)
				values (1, 'Nadine Shillingford', 'CSSE', 3);
insert into `courses`  (`TID`, `Name`, `Start_time`, `End_time`, `Difficulty`)
				values (1, 'Databases', TIME('8:05'), TIME('9:50'), 2);

# Vismay
CALL adduser('Vismay', 'modivr@rose-hulman.edu', 'Vismay123');

SELECT UID into @vis FROM users where name='Vismay';
SELECT CID into @dbcid FROM courses where Name='Databases';

CALL addschedule(@vis, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 77 DAY));
CALL addassignment('homework 1', @vis, @dbcid, DATE_ADD(NOW(), INTERVAL 3 DAY), 4, "", 2);

/*
insert into user (Name, Email, Password, Active_SID)
values ('Vismay', 'modivr@rose-hulman.edu', sha1('Vismay123'), Null);
insert into user (Name, Email, Password, Active_SID)
values ('Alex', 'modivr@rose-hulman.edu', sha1('Alex123'), Null);
insert into user (Name, Email, Password, Active_SID)
values ('Fang', 'huangf@rose-hulman.edu', sha1('Fang321'), Null);
*/