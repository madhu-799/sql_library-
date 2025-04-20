create database library_project_2;

create schema library ;

--1)
if object_id ('library.branch', 'u')  is not null 
 drop table library.branch 

create table library.branch 
(branch_id varchar(50) primary key ,
manager_id	varchar(50),
branch_address varchar(50),
contact_no varchar(50)
);
select * from library.branch

bulk insert library.branch 
from 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\branch.csv'
with (firstrow=2 ,
fieldterminator =',',
tablock )

------------------------------------
--2)
if object_id ('library.employees ', 'u')  is not null 
 drop table library.employees 

create table library.employees 
(emp_id varchar(20),
emp_name varchar(50),
emp_position varchar(20),
salary	nvarchar(20) ,
branch_id  varchar(20)
);


bulk insert library.employees 
from 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\employees.csv'
with (firstrow=2 ,
fieldterminator =',',
tablock );

select * from library.employees;

-------------------
---3)
if object_id ('library.books ', 'u')  is not null 
 drop table library.books 

create table library.books  
(
    isbn VARCHAR(50),
    book_title VARCHAR(80),
    category VARCHAR(20),
    rental_price VARCHAR(50),
    status VARCHAR(20),
    author VARCHAR(35),
    publisher VARCHAR(55)
);

BULK INSERT library.books
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\books.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

select * from library.books;

========================================
----4) 

if object_id ('library.issued_status ', 'u')  is not null 
 drop table library.issued_status 

create table library.issued_status 
(
issued_id varchar(10) primary key ,
issued_member_id varchar(10),
issued_book_name varchar(80),
issued_date	 varchar(50),
issued_book_isbn varchar(50),
issued_emp_id varchar(50)
);

BULK INSERT library.issued_status 
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\issued_status.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',

    TABLOCK
);

select * from  library.issued_status ;


------------------
------5)
if object_id ('library.members  ', 'u')  is not null 
 drop table library.members  

create table library.members 
(
member_id VARCHAR(20),
member_name VARCHAR(30),
member_address VARCHAR(30),
reg_date varchar(20),
);

BULK INSERT library.members
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\members.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	    TABLOCK
);

select * from  library. members;

-----------------
---6) 
if object_id ('library.return_status   ', 'u')  is not null 
 drop table library.return_status   

create table library.return_status    
(
return_id varchar(20),
issued_id	varchar(20),
return_book_name  varchar(20),
return_date  varchar(20),
return_book_isbn    varchar(20)

);

BULK INSERT library.return_status   
FROM 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\return_status.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ---ROWTERMINATOR = '\n',
	    TABLOCK
);

select * from  library. return_status   ;



