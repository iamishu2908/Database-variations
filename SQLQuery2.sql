create database test1
-- create tables
CREATE TABLE categories (
	category_id INT IDENTITY (1, 1) PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);
-------------------------------------------
ALTER TABLE categories
ADD category_type VARCHAR (255) NOT NULL

ALTER TABLE categories
DROP column category_type;

SELECT * FROM categories

select name from master.sys.databases
------------------------------------
DROP database test1;

-- TRUNCATE preserves the data stucture and deletes only the data. no need to create again
-- DROP deletes the data and the structure of the database

