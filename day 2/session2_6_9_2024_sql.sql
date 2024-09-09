-- schema creation
create schema hr;

-- identity function -> identity(start, offset)

create table hr.candidates(
id int identity(1,1) primary key, -- like autoincrement
full_name varchar(30) not null,
);

create table hr.employee(
id int identity(1,1) primary key,
full_name varchar(30) not null,
);

-- changing identity values


create table hr.student(
id int identity(100,2) primary key, -- like autoincrement
full_name varchar(30) not null,
);

alter table hr.student
add address varchar(20);

-- insertion through muliple column names and multiple values
insert into hr.student(full_name, address) values(
'Raj','pune'),('Sheetal','Delhi'),('Aarti','Chennai');

select * from hr.student;

---------------------------insertion-----------
insert into hr.candidates values('Ishwarya Devanathan');

insert into hr.candidates values('Joe biden'),('Viraj sethi'),('Akshu Dev');

select * from hr.candidates;

-- insertion by column_name
insert into hr.candidates (full_name) values('Joe biden'),('Viraj sethi'),('Akshu Dev');
select * from hr.candidates;

insert into hr.employee (full_name) values('Joe biden'),('Viraj sethi'),('Akshu Dev');

select * from hr.candidates;
select * from hr.employee;

-- inner join - matching records from both tables with their ids are displayed.

select * from hr.candidates C 
Inner join hr.employee E on C.full_name = E.full_name;

-- Left join - all records on the left table -> candidates, are matched with employee table
-- so if value in candidates are not present in employee, then null value is displayed
select * from hr.candidates C 
left join hr.employee E on C.full_name = E.full_name;

-- right join - all records on the right table -> employee, are matched with candidates table
-- values in right table are repeated twice in candidates table, thus when joining, all possible matches with right table are outputted
select * from hr.candidates C 
right join hr.employee E on C.full_name = E.full_name;

----------------------------------------------------------------------------

select * from production.products;

-- query : select productname, brandname  (INNERJOIN)

select p.product_name, b.brand_name
from production.products p
inner join production.brands b
On p.brand_id = b.brand_id;
----------------------------------------------------------------------------

select * from sales.orders;
select * from sales.order_items;

-- left join

select p.product_name, s.order_id from sales.order_items s
LEFT JOIN production.products p
ON p.product_id = s.product_id;

-- right join

select * from sales.order_items s
RIGHT JOIN production.products p
ON p.product_id = s.product_id
where p.brand_id = 9;

---------------------------------------------
-- CROSS JOIN - combines every row in first table with the second table

select * from sales.stores
select * from sales.orders

select o.order_id, s.store_id from sales.orders o CROSS JOIN sales.stores s order by order_id, store_id;

-------------------------------------------------
-- self join -> return employee with corresponding managersin the same table

select * from sales.staffs;

select e.first_name + ' ' + e.last_name as employee_name, m.first_name + ' ' + m.last_name as manager 
from sales.staffs e INNER JOIN sales.staffs m on m.staff_id = e.manager_id;

-- self join -> when columns have association with other columns in the same table
-- self join keyword doesnt exist

-------------------------------------------------------
-- FULL OUTER JOIN -- evne unmatched values will be returned
-- it will just join directly without using any id matches, first row in first table joined with second row directly
-- columns will be repeated
select * from sales.stores;
select * from sales.orders;

select * from sales.stores s
FULL OUTER JOIN sales.orders O 
ON s.store_id = o.order_id;

-- CONSTRAINTS:-

-- 1. PRIMARY KEY
-- column that uniquely identifies every row in a table
-- it can be 
-- All columns that participate in the primary key must be defined as NOT NULL.
-- SQL Server automatically sets the NOT NULL constraint for all the primary key columns if the NOT NULL constraint is not specified for these columns.
-- SQL Server also automatically creates a unique clustered index (or a non-clustered index if specified as such) when you create a primary key.

-- default schema for any table is dbo ( database object )
CREATE TABLE Users(
	id int,
	name varchar(20)
);
ALTER TABLE Users 
ALTER column id int not null;

ALTER TABLE Users 
add primary key(id);

-- 2.foreign key
-- A foreign key is a column or a group of columns in one table that uniquely identifies a row of another table 
-- try doing it yourself, adding updating and deleting foreign key

-- 3. UNIQUE constraint
-- SQL Server UNIQUE constraints allow you to ensure that the data stored in a column, or a group of columns, is unique among the rows in a table.
-- unique keys can be null. its job is to ensure uniqueness in column specified
alter table Users add address varchar(30);

alter table Users
add constraint address_of_user UNIQUE(address); -- constraint name

select * from Users;

-- CHECK Constraint
-- used for imposing 'if' condition on columns

alter table Users add price dec(10,2);

alter table Users
add constraint checking_price CHECK(price > 10);

Insert into USERS values(1,'ish','hello',1);

select * from Users;
----------------------------------------------------------------
-- DML operations

-- 1. INSERT

select * from sales.customers;

create table address(
	address_id int identity primary key,
	street varchar(20) NOT NULL,
	city varchar(10) NOT NULL,
	state varchar(2) NOT NULL,
	zip_code varchar(5) NOT NULL,
);


-- command to modify a column width
alter table address
alter column city varchar(100);
alter table address
alter column street varchar(100);

-- to write a combination of insert AND select command
-- to directly insert rows from another table
insert into dbo.address(street, city,state,zip_code) select street, city,state,zip_code from sales.customers

select * from dbo.address;



-------------------------------------------------------------------
-- 2. Update
UPDATE hr.employee set full_name = 'Akshaya D' where full_name = 'Akshu Dev'
-------------------------------------------------------------------------
-- Delete
select * from hr.employee;

delete from hr.employee where full_name = 'Viraj sethi';

------------------------------------------------------------------------

CREATE TABLE sales.category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
)
INSERT INTO sales.category(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000)
CREATE TABLE sales.category_staging (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);
INSERT INTO sales.category_staging(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',20000),
    (5,'Electric Bikes',10000),
    (6,'Mountain Bikes',10000);

INSERT INTO sales.category(category_id, category_name, amount)
VALUES
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);

select * from sales.category
select * from sales.category_staging

-- Merge -------------------
-- this function does insert, update  and delete together

merge sales.category cat -- target
using sales.category_staging stg -- source
ON cat.category_id = stg.category_id
when matched
then update set cat.category_name = stg.category_name, cat.amount = stg.amount
when not matched by target
then insert (category_id, category_name, amount) values (stg.category_id, category_name, stg.amount)
when not matched by source
then delete;

select * from sales.category
select * from sales.category_staging

---- transactions-------------------

-- example tables:
CREATE TABLE invoices (
  id int IDENTITY PRIMARY KEY,
  customer_id int NOT NULL,
  total decimal(10, 2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);

CREATE TABLE invoice_items (
  id int,
  invoice_id int NOT NULL,
  item_name varchar(100) NOT NULL,
  amount decimal(10, 2) NOT NULL CHECK (amount >= 0),
  tax decimal(4, 2) NOT NULL CHECK (tax >= 0),
  PRIMARY KEY (id, invoice_id),
  FOREIGN KEY (invoice_id) REFERENCES invoices (id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


BEGIN TRANSACTION;

INSERT INTO invoices (customer_id, total)
values(1,750), (2,500), (3,1000);

INSERT INTO invoice_items (id,invoice_id, item_name, amount,tax)
values(1,1,'sugar',300,2),(2,2,'banana',80,3)

UPDATE invoices
SET total = (SELECT
  SUM(amount * (1 + tax))
FROM invoice_items
WHERE invoice_id = 1);

COMMIT;

select * from dbo.invoices
select * from dbo.invoice_items

-- always use rollback - leanr more on this in docs
begin transaction;
	begin try
		insert into invoices(customer_id, total)
		values(4, 800), (5, 1000), (6, 1500);
		UPDATE invoices set total = -50 where customer_id = 3;
	commit;
end try
begin catch
	rollback transaction;
end catch

-----------------------------------------------------------------

-- grouping statements

SELECT * from sales.orders

select customer_id, year(order_date) as order_yr from sales.orders
group by customer_id, year(order_date)
order by customer_id

select * from sales.customers;

select city,count(*) from sales.customers group by city;



