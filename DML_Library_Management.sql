use CollegeLibrary
go
Insert Into Student(StudentID,StudentName,Department,Phone,Email)
Values(101,'Jackson','CSE',148445787,'jacksoninfo@gmail.com'),
(102,'Daniel','EEE',148447311,'danielinfo@gmail.com'),
(103,'Emma','Civil',148445787,'emmainfo@gmail.com'),
(104,'William','Mechanical',148452110,'williaminfo@gmail.com'),
(105,'James','Civil',148452118,'jamesinfo@gmail.com'),
(106,'Sofia','CSE',148444585,'sofiainfo@gmail.com'),
(107,'Henry','EEE',148447319,'henryinfo@gmail.com'),
(108,'Ellie','Mechanical',161024580,'ellieinfo@gmail.com'),
(109,'Jack','CSE',181435194,'jackinfo@gmail.com'),
(110,'Layla','EEE',161024584,'laylainfo@gmail.com');

Insert Into Book(BookName,Publisher,Quantity_Pcs)
Values('Structures','HarperCollins',15),
('The Gecko’s Foot','HarperCollins',10),
('Success Through Failure','Macmillan',20),
('Brave New World','Macmillan',22),
('One Hundred Years Of Solitude','Kensington',25),
('The Grapes Of Wrath','Scholastic',16),
('Lord Of The Flies','Kensington',18),
('Charlottes Web','Macmillan',28),
('This Side of Paradise','Kensington',20),
('Norwegian Wood','Scholastic',13),
('The Great Gatsby','Sterling',35),
('Lolita ','HarperCollins',32),
('A Farewell to Arms ','Sterling',23),
('The Master and Margarita','Scholastic',22),
('Uncle Tom’s Cabin','Workman',14),
('The Stranger','Workman',31);

Insert Into BookType(BookTypeID,BookTypeName)
values(1101,'Fantasy'),
(1102,'Thriller'),
(1103,'Motivational'),
(1104,'History');

Insert Into Author(AuthorName)
Values('Walt Whitman'),('Mark Twain'),('William Faulkne'),('John Steinbeck');

Insert Into HandOver(StudentID,BookID,BooktypeID,AuthorID,HandOverDate,HandOver_Status)
Values(101,1,1101,1,'2022-01-01','Borrow'),
(102,2,1102,2,'2022-01-02','Borrow'),
(103,3,1103,3,'2022-01-03','Borrow'),
(104,4,1104,4,'2022-01-04','Borrow'),
(101,1,1101,1,'2022-01-05','Return'),
(105,7,1102,3,'2022-01-05','Borrow'),
(106,10,1102,1,'2022-01-06','Borrow'),
(102,2,1102,2,'2022-01-07','Return'),
(108,11,1104,3,'2022-01-08','Borrow'),
(110,15,1101,2,'2022-01-09','Borrow'),
(103,3,1103,3,'2022-01-09','Return'),
(104,4,1104,4,'2022-01-10','Return'),
(107,7,1103,1,'2022-01-10','Borrow'),
(108,12,1102,3,'2022-01-11','Borrow'),
(105,9,1101,2,'2022-01-12','Borrow'),
(109,14,1103,3,'2022-01-13','Borrow'),
(108,11,1104,3,'2022-01-14','Return'),
(106,10,1102,1,'2022-01-14','Return'),
(102,3,1102,2,'2022-01-15','Borrow'),
(105,11,1101,1,'2022-01-16','Borrow'),
(107,7,1103,1,'2022-01-16','Return'),
(108,12,1102,3,'2022-01-17','Return'),
(110,15,1104,4,'2022-01-17','Borrow');

----------------Show Table---------------
Select* from Student
Select* from Book
Select* from BookType
Select* from Author
Select* from HandOver

-----Join Query Find out Student and BookType wise Booklist. Use having clause in this Query-----

select ST.StudentName,B.BookName,BookTypeName
from HandOver H
Join Student ST on H.StudentID=ST.StudentID
Join Book B on H.BookID=B.BookID
join BookType BT on H.BookTypeID=BT.BookTypeID
group by StudentName,BookName,BookTypeName
Having BookTypeName='Fantasy'

-----Sub Query to find out StudentName and BookName which has Miminum HandOver-----

select ST.StudentName,B.BookName, count(StudentName) NoOfStudent
from HandOver H
join Student ST on H.StudentID=ST.StudentID
join Book B on H.BookID=B.BookID 
Group by ST.StudentName,B.BookName
having count(StudentName)=(select top 1 count(StudentID) from HandOver
Group by StudentID order by 1)

-------------Case------------------
select ST.StudentName,BT.BookTypeName,
Case
	when BookTypeName='Motivational' then 'Motivational Reader'
	when BookTypeName='Thriller' then 'Thriller Type Reader'
	else 'Reader'
end as Commnets
from HandOver H
join Student ST on H.StudentID=ST.StudentID
join BookType BT on H.BookTypeID=BT.BookTypeID

------CTE to find out Student list and BookName which has Total Handover--------
with CTE_CollegeLibrary(StudentName,BookName, NoOfBook)
as(
select StudentName,BookName,count(BookName)
from HandOver H
	join Student ST on H.StudentID=ST.StudentID
	join Book B on H.BookID=B.BookID
group by StudentName,BookName)
select* from CTE_CollegeLibrary

-------------Convert-----------------
select convert(varchar(20),Student.StudentID)as ConvertedStudentID from Student

----------COUNT--------
select COUNT(StudentID) as [NumberOfStudent] from Student

----------AVG---------
select AVG(Quantity_Pcs) as [Number] from Book

----------MAX---------
select MAX(Quantity_Pcs) as [Number] from Book

----------MIN---------
select MIN(Quantity_Pcs) as [Number] from Book

----------ROLLUP---------
select COUNT(BookID) AS ID, Quantity_Pcs from Book 
GROUP BY ROLLUP(Quantity_Pcs)

--------Merge -Update Existing, Add Missing--------
select* into AuthorCopy from Author;

Merge AuthorCopy as AC
using Author as A on AC.AuthorID=A.AuthorID
when matched then
update set AC.AuthorName=A.AuthorName
when not matched then
insert (AuthorName)
values(A.AuthorName);
select*from Author

select*from AuthorCopy

insert into Author values('Truman Capote')

update Author
set AuthorName='Ray Bradbury'
where AuthorName='Truman Capote'

------------Value 'Insert' Store Procedure---------
exec sp_insertintobook 'Jurassic Park','Scholastic',12

------------Value 'Update' Store Procedure---------
exec sp_updateBook 16,'The Stand','Sterling'

------------Value 'Delete' Store Procedure---------
exec sp_deletefromBook 17

-------------Showing Store Procedure One Out Parameters--------
declare @Count int
execute sp_StudentByDept 
@Department='CSE',
@CountstudentID=@Count output
select @Count as 'NoOfStudent'
-----------Showing Scalar Value Function-----------
select dbo.fn_TopReadingBook();

-----------Showing Table Value Function------------
select* from fn_StudentList();

-----------Showing Multi Statement Function------------
select* from fn_MultiBook();

-----------After Trigger Insert,Update & Show Table---------
Insert into Book Values('Lolita','Harper',10)

Update Book
set BookName='Watchers'
where BookID=16

select* from Book
select* from Backup_Book

-----------Instead Trigger RAISERROR(When Delete) & Show Table-------
delete from Author
where AuthorID=4

select* from Author
select* from AuthorLog

