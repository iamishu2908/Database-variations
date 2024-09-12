
select * from sales.customers;
select * from sales.order_items;
select * from sales.orders;

select * from sales.orders
where customer_id in
(select customer_id from sales.customers
where state = 'CA');
--------------------------------------------------

select max(list_price) 
from sales.order_items
group by order_id
----------------------------------------------------

-- comparision between using inner join and nested subqeuries for the same problem

SELECT 
	o.order_id, max(i.list_price) AS max_price
FROM
	sales.orders o
INNER JOIN
	sales.order_items i
ON
	o.order_id = i.order_id
GROUP BY
	o.order_id

--vs 

SELECT
    order_id,
    order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
FROM
    sales.orders o
order by order_id desc;

-- subqeuries can be in select statements too
-- 
select * from sales.order_items
select * from sales.staffs
select * from sales.orders

-- q1: select staffid,total sales, year from orders from staffs,order_items and get the yearly sales for each staff

select o.staff_id,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.orders o
join sales.order_items oi
on o.order_id = oi.order_id
group by year(o.order_date), o.staff_id
order by o.staff_id,year(o.order_date)

-- q2: select staffid, staff_name, total sales, year and get the yearly sales for each staff
 
select o.staff_id, s.first_name + ' ' + s.last_name as staff_name,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.staffs s
join sales.orders o
on s.staff_id = o.staff_id
join sales.order_items oi
on o.order_id = oi.order_id
group by year(o.order_date), o.staff_id, s.first_name,s.last_name
order by o.staff_id,year(o.order_date)

select o.staff_id, s.first_name + ' ' + s.last_name as staff_name,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.order_items oi
join sales.orders o
on oi.order_id = o.order_id
join sales.staffs s
on s.staff_id = o.staff_id
group by year(o.order_date), o.staff_id, s.first_name,s.last_name
order by o.staff_id,year(o.order_date)

-- we cant access the first and last names from staff table without grouping them - NOTE
-- multiple cte queries

WITH cte_sales_amount AS (
    SELECT s.first_name + ' ' + s.last_name AS staff_name,
           SUM(oi.list_price * oi.quantity) AS total_sales,
           YEAR(o.order_date) AS year
    FROM sales.order_items oi
    JOIN sales.orders o ON oi.order_id = o.order_id
    JOIN sales.staffs s ON s.staff_id = o.staff_id
    GROUP BY YEAR(o.order_date), o.staff_id, s.first_name, s.last_name
),
cte_filtered_sales AS (
    SELECT staff_name, year, total_sales
    FROM cte_sales_amount
    WHERE total_sales > 5000  -- Example condition for filtering
)
SELECT staff_name, year, total_sales
FROM cte_filtered_sales;

-------------------------------------------------------------
-- using CASE statements

select distinct order_status from sales.orders;

select order_status,count(order_id) from sales.orders group by order_status;
-- instead of this, we assign names for the statuses
-- 1 -> pending
-- 2 -> processing
-- 3 -> rejected
-- 4 -> completed

select case order_status
when 1 then 'pending'
when 2 then 'processing'
when 3 then 'rejected'
when 4 then 'completed'
END as order_status,
count(order_id)
from sales.orders
group by order_status

----------------------------------------------------------------
-- query on case\

--  <500->very low
--  >500 and  < 1000	-> low
--  1000 and 5000	- medium
--- >5000	- very high

-- select order_id, order_value(qty*amount), order_tag
-- for aggregation, we cant directly use total_value variable 
select order_id, sum(quantity*list_price) as total_value,
case 
when sum(quantity*list_price) < 500 then 'very low'
when sum(quantity*list_price) >= 500 and sum(quantity*list_price) < 1000 then 'low'
when sum(quantity*list_price) >= 1000 and sum(quantity*list_price) < 5000 then 'medium'
when sum(quantity*list_price) >= 5000 then 'very high'
end as order_tag
from sales.order_items
group by ordeR_id

-- default value

select order_id, sum(quantity*list_price) as total_value,
case total_value
when sum(quantity*list_price) < 500 then 'very low'
when sum(quantity*list_price) >= 500 and sum(quantity*list_price) < 1000 then 'low'
when sum(quantity*list_price) >= 1000 and sum(quantity*list_price) < 5000 then 'medium'
when sum(quantity*list_price) >= 5000 then 'very high'
else 
	'not found!'
end as order_tag
from sales.order_items
group by ordeR_id

-- we can also use this as we execute in order:

SELECT order_id, 
       SUM(quantity * list_price) AS total_value,
       CASE 
           WHEN SUM(quantity * list_price) < 500 THEN 'very low'
           WHEN SUM(quantity * list_price) < 1000 THEN 'low'
           WHEN SUM(quantity * list_price) < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM sales.order_items
GROUP BY order_id;

-- we can simplify and eliminate redundant queries by using cte/subquery

-- in this case, we cant give q query like this
SELECT order_id, 
       SUM(quantity * list_price) AS total_value,
       CASE total_value 
           WHEN total_value < 500 THEN 'very low'
           WHEN total_value  < 1000 THEN 'low'
           WHEN total_value  < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM sales.order_items
GROUP BY order_id;

-- The reason this query doesn't work is because in SQL,
-- you cannot use an alias (like total_value) directly inside a CASE statement
-- within the same SELECT clause. SQL processes the SELECT clause in a specific order,
-- and total_value is only available after the SUM(quantity * list_price) has been computed,
-- not when the CASE expression is being evaluated.

-- So we use CTE/Subqueries

-- 1.cte
WITH OrderValues AS (
    SELECT order_id, 
           SUM(quantity * list_price) AS total_value
    FROM sales.order_items
    GROUP BY order_id
)
SELECT order_id, 
       total_value,
       CASE 
           WHEN total_value < 500 THEN 'very low'
           WHEN total_value < 1000 THEN 'low'
           WHEN total_value < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM OrderValues;

-- 2.subquery
SELECT order_id, 
       total_value,
       CASE 
           WHEN total_value < 500 THEN 'very low'
           WHEN total_value < 1000 THEN 'low'
           WHEN total_value < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM (
    SELECT order_id, 
           SUM(quantity * list_price) AS total_value
    FROM sales.order_items
    GROUP BY order_id
) AS sub;


------------------------------------------------------------
-- NULL

-- nullif will be used whend coding in stored procdures
-- when we intentionally want to gie a nullvalue when two cells matches

select nullif(10,10) result --> null if matches

select nullif(8,10) result -->

-- replaces some value with null
	select *, nullif(manager,104) manager from SalesReps
-------------------------------------------------------------------

-- replaces null with null
select *, COALESCE(manager,104) manager from SalesReps
