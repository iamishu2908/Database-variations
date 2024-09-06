-- basic
SELECT *
FROM sales.customers
where state = 'CA'
;

SELECT city,COUNT(*) AS city_count 
from sales.customers 
GROUP by city 
HAVING COUNT(*)>10 
order by city ;

--------------------------------------------------
-- sorting
SELECT city,first_name,last_name from sales.customers ORDER BY city,first_name; -- multiple sorting
SELECT first_name,last_name from sales.customers ORDER BY 1,2; -- using ordinals

---------------------------------------------------
-- batch processing

-- limit and offset is there only for mysql
-- ms sql uses offset
SELECT * FROM production.products; -- 321 rows

-- offset -> it filters and thus skips the offset number of rows
SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 10 rows; -- skips the first 10 rows, total 311 rows

SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 0 rows
FETCH FIRST 10 rows only; -- fetches first 10 rows

SELECT product_name, list_price
FROM production.products
ORDER BY list_price, product_name
OFFSET 10 rows -- we can change offset to fetch the next 10
FETCH FIRST 10 rows only; -- fetches next 10 rows

-- top 10

select top 10 product_name from production.products;

------------------------------------------
select * from sales.customers;
select distinct phone from sales.customers;
-- null is peresnt randomly in some data, lets bring it ot the top to identify it easily
select distinct phone from sales.customers order by phone;

-------------------------------------------
-- IN, Not in, between
select * from production.products 
where brand_id IN (3,5);

select * from production.products 
where brand_id NOT IN (3,5);

-------------------------------------------
-- LIKE - Wildcard operators(%) -- we dont know the exact word , but we know wt to query

select * from production.products 
where product_name like 'Trek%'; -- characters starting with trek

select * from production.products 
where product_name like '%Fuel%'; -- Fuel in between product_names


