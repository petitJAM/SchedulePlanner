/*
 * Insert some test data
 */

# Out with the old...
DELETE FROM users WHERE UID > 0;
DELETE FROM teachers WHERE TID > 0;

# And in with the new!

insert into `teachers` (`TID`, `Name`, `Department`, `Difficulty`)
				values (1, 'Nadine Shillingford', 'CSSE', 3);
insert into `teachers` (`TID`, `Name`, `Department`, `Difficulty`)
				values (2, 'Langley', 'MA', 3);
insert into `teachers` (`TID`, `Name`, `Department`, `Difficulty`)
				values (3, 'Steve Chenoweth', 'CSSE', 2);

insert into `courses`  (`TID`, `Name`, `Start_time`, `End_time`, `Difficulty`)
				values (1, 'Databases', TIME('8:05'), TIME('9:50'), 2);
insert into `courses`  (`TID`, `Name`, `Start_time`, `End_time`, `Difficulty`)
				values (2, 'Theory of Computation', TIME('11:4'), TIME('12:35'), 4);
insert into `courses`  (`TID`, `Name`, `Start_time`, `End_time`, `Difficulty`)
				values (3, 'Software Design', TIME('9:55'), TIME('10:45'), 3);

# Vismay
CALL adduser('Vismay', 'modivr@rose-hulman.edu', 'Vismay123');

SELECT UID into @vis FROM users where name='Vismay';

SELECT CID into @dbcid FROM courses where Name='Databases';
SELECT CID into @tccid FROM courses where Name='Theory of Computation';
SELECT CID into @sdcid FROM courses where Name='Software Design';

CALL addschedule(@vis, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 77 DAY));
CALL addassignment('homework 1', @vis, @dbcid, DATE_ADD(NOW(), INTERVAL 3 DAY), 4, "", 2);

SELECT Active_SID into @asid FROM users where name='Vismay';
CALL addcoursetoschedule(@asid, @dbcid);
CALL addcoursetoschedule(@asid, @tccid);
CALL addcoursetoschedule(@asid, @sdcid);


# Alex
CALL adduser('Alex', 'petitjam@rose-hulman.edu', '123456');

SELECT UID into @alex FROM users where name='Alex';
SELECT CID into @dbcid FROM courses where Name='Databases';

CALL addschedule(@alex, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 77 DAY));
CALL addassignment('homework 3', @alex, @dbcid, DATE_ADD(NOW(), INTERVAL 3 DAY), 4, "", 2);
CALL addmeeting('Create sprocs', @alex, @dbcid, DATE_ADD(NOW(), INTERVAL 1 DAY), 5, "Makin' sprocs", 2);

SELECT Active_SID into @asid FROM users where name='Alex';
CALL addcoursetoschedule(@asid, @dbcid);

/*
insert into user (Name, Email, Password, Active_SID)
values ('Vismay', 'modivr@rose-hulman.edu', sha1('Vismay123'), Null);
insert into user (Name, Email, Password, Active_SID)
values ('Alex', 'modivr@rose-hulman.edu', sha1('Alex123'), Null);
insert into user (Name, Email, Password, Active_SID)
values ('Fang', 'huangf@rose-hulman.edu', sha1('Fang321'), Null);
*/