select * from production.brands;
select * from production.products;

-- prod_name, brand, list_price

select p.product_name, b.brand_name, p.list_price
from production.brands b
join production.products p
on b.brand_id = p.brand_id

-------------------------------------------
--view creation

--A view is a virtual table whose contents are defined by a query. 
--Like a table, a view consists of a set of named columns and rows of data.

-- when we have a huge query and need to view that particular querys output frequently, we can store it as a view, which will not use extra memory 
-- and we dont need to execute the complete query everytime. 

--Views are generally used to focus, simplify, and customize the perception each user has of the database.
--Views can be used as security mechanisms by letting users access data through the view, without granting users permissions to directly access the underlying tables of the query. 

create view view_brands as select p.product_name, b.brand_name, p.list_price
from production.brands b
join production.products p
on b.brand_id = p.brand_id

select * from dbo.view_brands

--rename the view name

exec sp_rename @objname = 'dbo.view_brands', @newname = 'brands_view';

select * from dbo.brands_view

-- to see all views
select OBJECT_SCHEMA_NAME (b.object_id) schema_name, b.name from sys.views b;
-- to view all table names
select OBJECT_SCHEMA_NAME (b.object_id) schema_name, b.name from sys.tables b;

-- indexing
-- technique used to improve the performance of database queries by reducing the amount of data that needs to be scanned. Indexes allow the database to quickly locate rows in a table without having to scan the entire table.
-- indexes are used only if necessary, for efficient access/searching of data in a table

-- 1. clustered indexes
-- focuses on the physical structure of the data
-- rearranges the physical order of the data in the table
-- By default, the primary key constraint creates a clustered index

CREATE TABLE  part_prices(
    part_id int,
    valid_from date,
    price decimal(18,4) not null,
    PRIMARY KEY(part_id, valid_from) 
); -- with pk

CREATE TABLE production.parts(
    part_id   INT NOT NULL, 
    part_name VARCHAR(100)
); -- without pk

-- creating index

create clustered index idx_part_id on dbo.part_prices(part_id); -- default already, still created

create clustered index idx_part_id on production.parts(part_id); -- created index pk

-- 2. non clustered indexes
-- balanced tree ds is used here bcoz it internally contains sorted data that allows search in a sequential access
select customer_id, city from sales.customers where city ='Campbell';

-- in this case, its fast. But for retriveal in larger databases like amiilion records,
-- searching for a single city is time consuming

create index idx_city on sales.customers(city);

-- a default non clustered index is formed
-- Each level of the tree consists of pages, and the index entries are distributed across these pages. The root page serves as the entry point to the index, and subsequent levels branch out until the leaf pages are reached, containing the actual index entries along with pointers to the corresponding table rows.
-- Balanced Structure: B-trees are balanced trees, which means that the depth of the tree is minimized, leading to efficient search operations. The number of levels in the tree remains relatively small, allowing for fast traversal and retrieval of data.

-- other concepts in indexes:
-- 1. rename, label, drop

--------------------------------------------------------------
-- why do we use stored procedures?
-- before the advent of advnced web technologies, sql was very powerful exp plsql
-- only with sql as a backend, ppl used to build applications

-- stored procedures dont follow solid principels and not scalable

-- example 1: [FROM GPT]
CREATE PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT * FROM Sales.customers;
END;

-- calling the sp
EXEC GetAllCustomers;

-- example 2:
-- they can accpet paramters too
CREATE PROCEDURE GetCustomerByID
    @CustomerID INT
AS
BEGIN
    SELECT * FROM Sales.customers WHERE customer_id = @CustomerID;
END;

-- calling
EXEC GetCustomerByID @CustomerID = 1;

-- exmaple 3:
CREATE PROCEDURE GetTotalOrders
    @CustomerID INT,
    @TotalOrders INT OUTPUT
AS
BEGIN
    SELECT @TotalOrders = COUNT(*) 
    FROM Sales.orders
    WHERE customer_id = @CustomerID;
END;

--call
DECLARE @Orders INT;
EXEC GetTotalOrders @CustomerID = 1, @TotalOrders = @Orders OUTPUT;
SELECT @Orders AS TotalOrders;

-- example 4 - try and catch
CREATE PROCEDURE InsertOrder
    @CustomerID INT,
    @OrderDate DATE
AS
BEGIN
    BEGIN TRY
        INSERT INTO Sales.orders(customer_id, order_date) VALUES (@CustomerID, @OrderDate);
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;

--This procedure attempts to insert a new order and catches any errors that occur during the process.

-- example 5 - transactions and rollbacks
/*
CREATE PROCEDURE TransferFunds
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(10, 2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;
        
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;
*/

--This procedure transfers funds between two accounts and rolls back the transaction if an error occurs.

------------------------------------------------------------

select * from sales.customers;

select first_name + ' ' + last_name as full_name from sales.customers;

create procedure proc_address
as
begin 
select first_name + ' ' + last_name as full_name from sales.customers;
end;

-- 2 ways to call
exec proc_address;
execute proc_address

------------------------------------------------------------------
-- finding duplicates in table

select * from sales.orders;

-- find duplicated customer id

select customer_id, count(*)
from sales.orders
group by customer_id
having count(*) > 1

------------------------------------
-- template for finding duplicates
SELECT 
    a, 
    b, 
    COUNT(*) occurrences
FROM t1
GROUP BY
    a, 
    b
HAVING 
    COUNT(*) > 1;

---------------------------------------------
-- some other deafult time, date functions
select CURRENT_TIMESTAMP
select GETDATE();
-- getting date from timestamps
select CONVERT(date, GETDATE());
select CONVERT(time, GETDATE());

select SYSDATETIMEOFFSET();

-- TODO: how cast is used. tryconvert etc

---- version tracking in SQL------------------------------------
-- wht happens if some changes the data??
-- history table inmaintained / vcs are used geenrally
-- bt in sql, triggers are used.
-- all these oeprations are ASyncrhornous and thus doesnt wait for any other parrallel processes.
-- calling a function will call a trigger and update the logs.
-- we will know who did wt to a data

