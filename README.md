# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: library_project_2

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.



## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
"C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\Untitled Diagram.drawio"

- **Database Creation**: Created a database named `library_project_2`.\
- **create schema** :library 
- **Table Creation**: Created tables for library_branches, library_employees, library_members, library_books, library_issued status, and library_return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_project_2;

if object_id ('library.branch', 'u')  is not null 
 drop table library.branch 

create table library.branch 
(branch_id varchar(50) primary key ,
manager_id	varchar(50),
branch_address varchar(50),
contact_no varchar(50)
);
select * from library.branch

-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);
bulk insert library.branch 
from 'C:\Users\MADHU\OneDrive\Desktop\sql project 2 (library )\branch.csv'
with (firstrow=2 ,
fieldterminator =',',
tablock )


-- Create table "Members"
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


-- Create table "Books"
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



-- Create table "IssueStatus"
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



-- Create table "ReturnStatus"
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



```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `library_books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `library_employees` table.
- **Delete**: Removed records from the `library_members` table as needed.

**Task 1. Create a New Book Record**
-- "'972-01-5672-3842', 'to kill a mockingbad ', 'classic',6.00,'madhu)"

```sql
insert into library.books(isbn ,book_title, category ,rental_price , status ,author ,publisher )
values ('972-01-5672-3842', 'to kill a mockingbad ', 'classic',6.00,'yes','madhu munna','jackob');
;
SELECT * FROM library_books;
```
**Task 2: Update an Existing Member's Address**

```sql
update library.members
set member_address='12345 main ste'
where member_id="C101";

```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: delete the record with issued_id="IS106" from the isuued_status table 

```sql
delete from library.issued_status
where issued_id='IS106';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
select * from library.issued_status
where issued_empl_id='E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
 select * from library.issued_status

select 
issued_emp_id,
count(issued_id) as total_book_issued
from library.issued_status
group by issued_emp_id
having count(issued_id)>1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table book_counts as(
select 
bs.isbn,
bs.book_title,
count(ist.issued_id ) as no_issued
from library.books  as bs
left join library.issued_status  as ist
on bs.isbn= ist.issued_book_isbn
group by isbn,bs.book_title);

select * from book_counts 
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
select * from library.books
where category='classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
select * from library.books

select * from library.issued_status


select 
b.category ,
sum(b.rental_price),
count(*)
from library.books as b
left join library.issued_status as ist 
on b.isbn =ist.issued_book_isbn
group by b.category 

```

9. **List Members Who Registered in the Last 180 Days**:
```sql
select * from library.members

insert into library.members(member_id ,member_name ,member_address , reg_date)
values ('c100','madhu','1255 man ','2025-09-26');

select * from library.members
where reg_date>=getdate();
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
select * from library.branch
select * from library.employees

select * 
from library.branch b 
left join library.employees as e
on e.branch_id=b.branch_id

```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
select * from library.books

create table books_1 as(
select *
from library.books
where rental_price>5) ;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
select 
	ist.issued_member_id,
	m.member_name,
	b.book_title,
 ist.issued_date ,
 getdate()as todays_date,
 GETDATE()-ist.issued_date as overdue_Days,
	rst.return_date
from library.issued_status as ist 
inner join library.members as m 
on ist.issued_member_id=m.member_id
inner  join library.books b
on ist.issued_book_isbn=b.isbn
left  join library.return_status rst 
on ist.issued_id=rst.issued_id
where rst.return_date is null
and (getdate()-ist.issued_date)>30

order by ist.issued_member_id
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql


CREATE PROCEDURE dbo.ass_return_records
    @p_return_id VARCHAR(30),
    @p_issued_id VARCHAR(30),
    @p_return_date DATE,
    @p_return_book_isbn VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_isbn VARCHAR(50);

    -- Insert into return_status
    INSERT INTO library.return_status (return_id, issued_id, return_date, return_book_isbn)
    VALUES (@p_return_id, @p_issued_id, @p_return_date, @p_return_book_isbn);

    -- Get ISBN from issued_status
    SELECT @v_isbn = issued_book_isbn
    FROM library.issued_status
    WHERE issued_id = @p_issued_id;

    -- Update books table
    UPDATE library.books
    SET status = 'no'
    WHERE isbn = @v_isbn;
END;


-- Testing FUNCTION add_return_records

select 
issued_id='IS106'
from library.issued_status
where issued_book_isbn='978-0-330-25864-8';

select * from library.books
where isbn='978-0-330-25864-8';


select * from library.issued_status
where issued_book_isbn='978-0-330-25864-8';

select * from library.return_status
where issued_id='IS106';

-- calling function 
exec dbo.ass_return_records('RS138','IS135','good');

-- calling function 
exec dbo.ass_return_records('RS188','IS148','good');

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
select * from library.books
select * from library.branch
select * from library.employees
select * from library.issued_status
select * from library.return_status


create table  branch_reports as  (
select
	bh.branch_id,
	bh.manager_id,
	sum(b.rental_price) as total_revenue ,
	count(ist.issued_id) as no_of_books_issued ,
	count(rst.return_id) as no_of_books_returned 
from library.issued_status as ist 
inner join library.books as b
on ist.issued_book_isbn=b.isbn

inner  join library.branch as bh 
on ist.issued_emp_id=bh.manager_id

inner   join library.employees e
on ist.issued_emp_id=e.emp_id

inner join library.return_status rst 
on ist.issued_id=rst.issued_id

group by 	bh.branch_id,
	bh.manager_id );

	select 8 from branch_reports 
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql

C
select * from library.books
select * from library.branch
select * from library.issued_status

if object_id('dbo.active_members ','u' ) is not null
drop table dbo.active_mmbers 
SELECT *
INTO active_members
FROM library.members
WHERE member_id IN (
    SELECT issued_member_id
    FROM library.issued_status
    WHERE issued_date BETWEEN DATEADD(MONTH, -2, GETDATE()) AND GETDATE()
);

select * from dbo.active_members;
```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
select * from library.books
select * from library.branch
select * from library.employees
select * from library.issued_status

select  top 3
	e.emp_name,
	bh.branch_id,
	bh.manager_id,
	bh.branch_address,
	bh.contact_no ,
	count(ist.issued_id) as mo_of_books_issued
from library.issued_status ist 
inner join library.employees e 
on ist.issued_emp_id=e.emp_id
inner join library.branch bh 
on ist.issued_emp_id=bh.manager_id
group by 
e.emp_name,
bh.branch_id,
bh.manager_id,
bh.branch_address,
bh.contact_no 
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql


select * from library.books
select * from library.issued_status
-- Drop if exists (optional)
IF OBJECT_ID('dbo.issued_book', 'P') IS NOT NULL
    DROP PROCEDURE dbo.issued_book;
GO

CREATE PROCEDURE dbo.issued_book
    @p_issued_id VARCHAR(20),
    @p_issued_member_id VARCHAR(30),
    @p_issued_book_isbn VARCHAR(30),
    @p_issued_emp_id VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_status VARCHAR(10);

    -- Get current book status
    SELECT @v_status = status
    FROM library.books
    WHERE isbn = @p_issued_book_isbn;

    -- Check if book is available
    IF @v_status = 'yes'
    BEGIN
        -- Insert issued record
        INSERT INTO library.issued_status (
            issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id
        )
        VALUES (
            @p_issued_id, @p_issued_member_id, GETDATE(), @p_issued_book_isbn, @p_issued_emp_id
        );

        -- Update book status
        UPDATE library.books
        SET status = 'no'
        WHERE isbn = @p_issued_book_isbn;

        PRINT 'Notice -- Book record added successfully for book ISBN: ' + @p_issued_book_isbn;
    END
    ELSE
    BEGIN
        PRINT 'Notice -- Sorry, the book is currently unavailable. Book ISBN: ' + @p_issued_book_isbn;
    END
END;
GO


EXEC dbo.issued_book 
    @p_issued_id = 'ISS001',
    @p_issued_member_id = 'MEM123',
    @p_issued_book_isbn = 'ISBN789',
    @p_issued_emp_id = 'EMP456';



```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.



## Author - madhu 

This project showcases SQL skills essential for database management and analysis.


Thank you for your interest in this project!
