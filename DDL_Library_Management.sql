Drop database CollegeLibrary
go
Create Database CollegeLibrary
on
(
	name='Library_Management_system', 
	filename='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Library_Management_system.mdf',
	size=25mb,
	maxsize=100mb,
	filegrowth=5%
)
log on
(
	name='Library_Management_system_log', 
	filename='C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Library_Management_system.ldf',
	size=25mb,
	maxsize=100mb,
	filegrowth=5%
);
go
use CollegeLibrary
go
Create Table Student(
	StudentID int primary key not null,
	StudentName Varchar(50),
	Department Varchar(50),
	Phone int,
	Email varchar(50)
);

Create Table Book(
	BookID int primary Key identity(1,1) not null,
	BookName varchar(50),
	Publisher varchar(50),
	Quantity_Pcs int
);

Create Table BookType(
	BookTypeID int Primary Key not null,
	BookTypeName varchar(50)
);

Create Table Author(
	AuthorID int Primary Key identity(1,1) not null,
	AuthorName varchar(50)
);

Create Table HandOver(
	HandOverID int Primary Key identity(1,1) not null,
	StudentID int References Student(StudentID),
	BookID int References Book(BookID),
	BookTypeID int References BookType(BookTypeID),
	AuthorID int References Author(AuthorID),
	HandOverDate date,
	HandOver_Status varchar(50)
);

------------Index--------------
Create index GetBook
on Book(BookName)

sp_helpindex Book

------------Store Procedure Insert------------
Create proc sp_insertintobook
@BookName varchar(50),
@Publisher varchar(50),
@Quatity_Pcs int
as
Begin
insert into Book(BookName,Publisher,Quantity_Pcs)
Values(@BookName,@Publisher,@Quatity_Pcs)
end;

-------------Store Procedure Update-------------
Create proc sp_updateBook
@BookID int,
@BookName varchar(50),
@Publisher varchar(50)
as
update Book set BookName=@BookName, Publisher=@Publisher
where BookID=@BookID

go
-------------Store Procedure Delete--------------
Create proc sp_deletefromBook
@BookID int
as
begin
delete from Book where BookID=@BookID
end;

---------Store Procedure with One Out Parameters-----------
Create proc sp_StudentByDept
@Department varchar(50),
@CountstudentID int output
as
begin
select StudentName,Department
from Student
where Department=@Department
select @CountstudentID=@@ROWCOUNT
end;

----------------Scalar value Function--------------
Create function fn_TopReadingBook()
returns int
begin
	Declare @c int
	select @c=count(BookID) from HandOver;
	return @c;
	end
go

---------------Table Value Function---------------
Create function fn_StudentList()
Returns table
return
(select* from Student)
go

--------------Multi Statement Function-------------
Create function fn_MultiBook()
returns @OutTable table
(BookID int,BookName varchar(50), Publisher varchar(50),Quantity_Pcs int)
begin
insert into @OutTable(BookID,BookName,Publisher,Quantity_Pcs)
select BookID,BookName,Publisher,Quantity_Pcs
from Book
return;
end;
----------Backup Table for After Trigger---------
Create Table Backup_Book(
	BookID int not null,
	BookName varchar(60),
	Publisher varchar(60),
	Quantity_Pcs int,
	UpdatedOn datetime,
	UpdatedBy varchar(50)
);

--------------After Trigger----------------
Create Trigger Trigger_Book
on Book
After Update,Insert
as
 begin
	Insert into Backup_Book(BookID,BookName,Publisher,Quantity_Pcs,UpdatedOn,UpdatedBy)
	Select i.BookID,i.BookName,i.Publisher,i.Quantity_Pcs,GETDATE(),SUSER_NAME()
	from Book B join inserted I on B.BookID=I.BookID
 End;

--------------Create Instead Trigger-------------
select* from Author

Create table AuthorLog(
LogID int primary key identity(1,1) not null,
AuthorID int null,
Action varchar(50) null
);

Create Trigger Author_Trigger
on Author
Instead Of Delete
as
Begin
			Declare @AuthorID int
			select @AuthorID=deleted.AuthorID
			from deleted
				If @AuthorID=4
			begin
				RAISERROR('AuthorID 4 Cannot be deleted',16,1)
				Rollback
				Insert into AuthorLog
				Values(@AuthorID,'Record Cannot be deleted')
			end
				else
			begin
				delete from Author
				where AuthorID=@AuthorID

				insert into AuthorLog
				values(@AuthorID,'Instead Of Deleted')
			end
end;

