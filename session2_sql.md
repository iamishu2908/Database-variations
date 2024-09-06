# Day 2 - database variations - topic: joins and constraints
1. datatypes:
2. ![image](https://github.com/user-attachments/assets/c8a08356-2bb7-45ae-a186-fa09555d6ae5)

3. ![image](https://github.com/user-attachments/assets/9e3478f3-2569-44c9-a0a9-ffbc61a44119)
4. primary key must be bigint 0 to handle large number of values

## Joins
![image](https://github.com/user-attachments/assets/d0c5806e-c9b7-48c0-ac45-89609de14df2)

1. identity function -> identity(start of id, offset for each id)
2. sample query:
3. create table hr.student(
id int identity(100,2) primary key, -- like autoincrement
full_name varchar(30) not null,);
4.![image](https://github.com/user-attachments/assets/6aa321da-a32d-4ee2-81dc-dd092dc8e747)

- insertion through muliple column names and multiple values
- query:
insert into hr.student(full_name, address) values(
'Raj','pune'),('Sheetal','Delhi'),('Aarti','Chennai');

- inner join - matching records from both tables with their ids are displayed.

select * from hr.candidates C 
Inner join hr.employee E on C.full_name = E.full_name;

- Left join - all records on the left table -> candidates, are matched with employee table
 so if value in candidates are not present in employee, then null value is displayed.

select * from hr.candidates C 
left join hr.employee E on C.full_name = E.full_name;

- right join - all records on the right table -> employee, are matched with candidates table
- - values in right table are repeated twice in candidates table, thus when joining, all possible matches with right table are outputted

select * from hr.candidates C 
right join hr.employee E on C.full_name = E.full_name;

1. database >> schema >> table
2. schemas are used to categorise the tables
3. but **not every sql framework** follows this

> we cant join 2 different databases, but we can join 2 or more schemas
- CROSS JOIN - combines every row in first table with the second tbale
select * from sales.stores
select * from sales.orders

select o.order_id, s.store_id from sales.orders o CROSS JOIN sales.stores s order by order_id, store_id;
![image](https://github.com/user-attachments/assets/33064917-3d0a-4cab-8c9c-1e704f6f2500)

------------------------------------------------------------------------------
-- self join -> return employee with corresponding managersin the same table

select * from sales.staffs;

select e.first_name + ' ' + e.last_name as employee_name, m.first_name + ' ' + m.last_name as manager 
from sales.staffs e INNER JOIN sales.staffs m on m.staff_id = e.manager_id;

-- self join -> when columns have association with other columns in the same table
-- self join keyword doesnt exist
![image](https://github.com/user-attachments/assets/4d888483-2fcb-463f-bfd0-051a3df19aa7)

-------------------------------------------------------
-- FULL OUTER JOIN -- evne unmatched values will be returned
-- it will just join directly without using any id matches, first row in first table joined with second row directly
-- columns will be repeated
select * from sales.stores;
select * from sales.orders;

select * from sales.stores s
FULL OUTER JOIN sales.orders O 
ON s.store_id = o.order_id;

![image](https://github.com/user-attachments/assets/63e3ed71-9d46-47aa-8af8-d926b636a79c)

## Constraints

- Validation or rules imposed over the columns
- ensures accuracy, reliability and violation in data is prevented.
- -- PRIMARY KEY
-- All columns that participate in the primary key must be defined as NOT NULL.
-- SQL Server automatically sets the NOT NULL constraint for all the primary key columns if the NOT NULL constraint is not specified for these columns.
-- SQL Server also automatically creates a unique clustered index (or a non-clustered index if specified as such) when you create a primary key.

-- default schema for any table is dbo ( database object )
![image](https://github.com/user-attachments/assets/c90c9627-3979-4401-9ef0-d4372d243b03)

- -- UNIQUE constraint
-- SQL Server UNIQUE constraints allow you to ensure that the data stored in a column, or a group of columns, is unique among the rows in a table.
- ![image](https://github.com/user-attachments/assets/d1c4ec87-1958-4213-afe6-0d4aab334225)

- Check constraint:
- ![image](https://github.com/user-attachments/assets/fcfbc93a-b9fc-499f-b0e0-d3ce1a4203e7)

- To learn more about constraints: https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver16

## other
- update query updates the table and this cannot be rolledback.
- 
