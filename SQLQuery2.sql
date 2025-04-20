select * from library.books
select * from library.branch
select * from library.employees
select * from library.issued_status
select * from library.members
select * from [library].[issued_status]



----task 1 create a new record ---'972-01-5672-3842', 'to kill a mockingbad ', 'classic',6.00,'madhu munna','jackob'

insert into library.books(isbn ,book_title, category ,rental_price , status ,author ,publisher )
values ('972-01-5672-3842', 'to kill a mockingbad ', 'classic',6.00,'yes','madhu munna','jackob');

--task-2  update an existing members address 

update library.members
set member_address='12345 main ste'
where member_id="C101";

---task 3  delete a record from the issude_status table 
--delete the record with issued_id="IS106" from the isuued_status table 

delete from library.issued_status
where issued_id='IS106'


--task-4  retrive all books issued by specific employee 
--objective : select all books issued by the employee with empl_id ='e101'
select * from library.issued_status
where issued_empl_id='E101';


--task 5 list members who have issued more than one book 
--objective: use group by to find members who have issued more than one book 
 
 select * from library.issued_status

select 
issued_emp_id,
count(issued_id) as total_book_issued
from library.issued_status
group by issued_emp_id
having count(issued_id)>1


/*task 6  CTAS(create table as select statement)  :create a summary tables :
used CTAS to generate new tables based on the query results -
each book and total_book_isuued_count */

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


--task 7 -- retrive all books in a specific category 

select * from library.books
where category='classic'


--task 8-- find the total rental income by category 
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


---task 9  list members who registered in the last 100 days
select * from library.members

insert into library.members(member_id ,member_name ,member_address , reg_date)
values ('c100','madhu','1255 man ','2025-09-26');

select * from library.members
where reg_date>=getdate()


----task 10 -- list employees with their branch managers name and their branch deatils 
select * from library.branch
select * from library.employees

select * 
from library.branch b 
left join library.employees as e
on e.branch_id=b.branch_id

--task 11 - create a table of books with rental price above a certain threshold 5usd.

select * from library.books

create table books_1 as(
select *
from library.books
where rental_price>5) 

/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.*/

---issued_status =members=books=return_status 
----filter books whch is return overdue of >30 days

select * from library.books
select * from library.issued_status
select * from library.members
select * from library.return_status


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

/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned 
i,e as soon as person return the books then it should be  upadated to yes 
(based on entries in the return_status table).*/

select * from library.books
select * from library.issued_status
select * from library.return_status

select * from library.books
where isbn= '978-0-14-118776-1' ;    --in this we can see that status=yes 

update library.books
set status='no'
where isbn= '978-0-14-118776-1';  --afetr this update we see that 'no 'status 

select * from library.issued_status
where issued_book_isbn= '978-0-14-118776-1';

select * from library.return_status
where issued_id='IS107'


---here we can also do thsi in a manual format like 

insert into library.return_status(return_id,issued_id, return_date,return_id,return_book_isbn)
values ('rs125','is130','getdate()','good');
select * from library.return_status
where issued_id='is130';


----stored procedure 

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


EXEC dbo.ass_return_records 
    @p_return_id = 'RET001', 
    @p_issued_id = 'ISS123', 
    @p_return_date = '2025-04-20', 
    @p_return_book_isbn = 'ISBN0001';

----test the functions and add_return_Record 

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

--calling fucntion 
exec dbo.ass_return_records('RS138','IS135','good');
exec dbo.ass_return_records('RS188','IS148','good');



/*Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned,
and the total revenue generated from book rentals.*/

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

/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members
who have issued at least one book in the last 2 months.*/


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

select * from dbo.active_members 

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.*/

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

/*Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message 
indicating that the book is currently not available.
.*/

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

