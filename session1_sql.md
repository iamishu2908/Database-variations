# Day 1 - 5.9.2024 - Database variations
## Introduction to SQL

1. database types -> Sql -> Nosql
	- earlier sql softwares have stored procedures
    	- con: cant be applied to other usecases. very minimal use case
2. postgres sql - preferred when we need more joins
3. mysql - more security
4. SQL commands
   	- why categorization of commands? - the different commands are categorized acc to frequency of use, and authorization of data
    - DDL,DML,TCL,
	- TCL:
    - ![image](https://github.com/user-attachments/assets/73a5706b-8321-45af-8aea-c1b74db71c54)
	- basic structure:
 	- ![image](https://github.com/user-attachments/assets/acd4c567-01eb-4816-82c6-d3e9873bbb6b)
5. Open MS-sql server , download data from https://www.sqlservertutorial.net/wp-content/uploads/SQL-Server-Sample-Database.zip
   create a database. open each create, load and other files from zip file into db and execute each of them.
6. basic commands:
 ![image](https://github.com/user-attachments/assets/91607188-34d1-45dc-9a23-5dbc7c02c781)
7. using hyphen - is for writing comments in sql
8. multiple sorting of columns:
9.![image](https://github.com/user-attachments/assets/daaec6b2-ade2-4c96-ba93-368b5521a7ec)
10.SELECT first_name,last_name from sales.customers ORDER BY 1,2; -- using ordinals
11. -- batch processing

-- limit and offset is there only for mysql
-- ms sql uses offset
SELECT * FROM production.products; -- 321 rows

- SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 10 rows; -- skips the first 10 rows, total 311 rows

- SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 0 rows
FETCH FIRST 10 rows only; -- fetches first 10 rows

- SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 10 rows -- we can change offset to fetch the next 10
FETCH FIRST 10 rows only; -- fetches next 10 rows

-- top 10

- select top 10 product_name from production.products;
- show all databases - command works in my sql. but diff command in MSsql
- ![image](https://github.com/user-attachments/assets/fe2ec5e8-49ed-40c8-8436-c99fffea0b57)

- add / drop the columns
  
- ALTER TABLE categories
ADD category_type VARCHAR (255) NOT NULL

-ALTER TABLE categories
DROP column category_type;


-- TRUNCATE preserves the data stucture and deletes only the data. no need to create again
-- DROP deletes the data and the structure of the database


   


