# day 3 - session 1
1. -- comparsion between using inner join and nested subqeuries for the same problem
2.
- SELECT 
	o.order_id, o.order_date, max(i.list_price) AS max_price
FROM
	sales.orders o
INNER JOIN
	sales.order_items i
ON
	o.order_id = i.order_id
GROUP BY
	o.order_id, o.order_date;
- SELECT
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
> Subqueries can be in select statements itself just lke how we write a column name
3. IN query:
- select * from sales.orders
where customer_id in
(select customer_id from sales.customers
where state = 'CA');

4. CTE -> temparary view/table
- https://learn.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver16
- - 'WITH' command is used
 
5. group by order by - sample query
- q1: select staffid,total sales, year from orders from staffs,order_items and get the yearly sales for each staff

select o.staff_id,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.orders o
join sales.order_items oi
on o.order_id = oi.order_id
group by year(o.order_date), o.staff_id
order by o.staff_id,year(o.order_date)

- q2: select staffid, staff_name, total sales, year and get the yearly sales for each staff
 
select o.staff_id, s.first_name + ' ' + s.last_name as staff_name,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.staffs s
join sales.orders o
on s.staff_id = o.staff_id
join sales.order_items oi
on o.order_id = oi.order_id
group by year(o.order_date), o.staff_id, s.first_name,s.last_name
order by o.staff_id,year(o.order_date)

-- we cant access the first and last names from staff table without grouping them - NOTE

even if we change the order isnide the query, while maintaining the link between the tables(joins)
we will still get the same result :

- select o.staff_id, s.first_name + ' ' + s.last_name as staff_name,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.order_items oi
join sales.orders o
on oi.order_id = o.order_id
join sales.staffs s
on s.staff_id = o.staff_id
group by year(o.order_date), o.staff_id, s.first_name,s.last_name
order by o.staff_id,year(o.order_date)

6. CTE is a common table where we can orderby, and use more functions on top of it
- its like a simple fucntion created in a commonplace
   
- with cte_sales_amount(staff, sale, year)
as
(select s.first_name + ' ' + s.last_name as staff_name,SUM(oi.list_price*oi.quantity) as total_sales, year(o.order_date) as year
from sales.order_items oi
join sales.orders o
on oi.order_id = o.order_id
join sales.staffs s
on s.staff_id = o.staff_id
group by year(o.order_date), o.staff_id, s.first_name,s.last_name
)
select staff, year, sale from cte_sales_amount 

----------
- we cant access the first and last names from staff table without grouping them - NOTE
- multiple cte queries example

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

In Microsoft SQL Server, a **Common Table Expression (CTE)** is a temporary result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement. It's a powerful tool for simplifying complex queries and making your code more readable.

### Key Features of a CTE:
1. **Temporary Result Set**: A CTE exists only for the duration of the query.
2. **Readable**: It makes complex queries easier to understand by breaking them down into logical components.
3. **Recursive Queries**: CTEs can be used for recursive queries, such as hierarchical data retrieval (e.g., organizational charts).
4. **Multiple Usage**: You can define multiple CTEs and reference them in a single query.

### Syntax of a CTE:
A CTE is defined using the `WITH` keyword. Here's the basic syntax:

```sql
WITH cte_name (column1, column2, ...)
AS (
    -- SQL query for the CTE
    SELECT ...
)
-- Main query using the CTE
SELECT column1, column2
FROM cte_name;
```

### Example:
Suppose you want to retrieve the total sales for each employee in a company:

```sql
WITH SalesCTE AS (
    SELECT s.first_name + ' ' + s.last_name AS employee_name,
           SUM(oi.list_price * oi.quantity) AS total_sales
    FROM sales.order_items oi
    JOIN sales.orders o ON oi.order_id = o.order_id
    JOIN sales.staffs s ON o.staff_id = s.staff_id
    GROUP BY s.first_name, s.last_name
)
SELECT employee_name, total_sales
FROM SalesCTE;
```

### Benefits:
- **Clarity**: The query becomes more readable because you've separated the logic into a named result set (`SalesCTE`).
- **Reusability**: The CTE can be used multiple times within the main query if needed.

### Recursive CTE:
Recursive CTEs are used to deal with hierarchical data (e.g., employee-manager relationships). They call themselves repeatedly until a termination condition is met.

Example of a recursive CTE to retrieve hierarchical data:

```sql
WITH EmployeeHierarchy AS (
    -- Anchor member: retrieves the top-level employees (e.g., managers)
    SELECT employee_id, manager_id, first_name + ' ' + last_name AS employee_name, 0 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive member: retrieves employees who report to the previous level
    SELECT e.employee_id, e.manager_id, e.first_name + ' ' + e.last_name, eh.level + 1
    FROM employees e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT employee_name, level
FROM EmployeeHierarchy
ORDER BY level;
```

In this example:
- **Anchor Member**: Retrieves the top-level managers.
- **Recursive Member**: Finds employees reporting to each manager.

### Multiple CTEs:
You can define more than one CTE by separating them with commas:

```sql
WITH CTE1 AS (
    SELECT ...
),
CTE2 AS (
    SELECT ...
)
SELECT ...
FROM CTE1
JOIN CTE2 ON ...;
```

This is useful when you need to break down complex logic into manageable pieces.

### CTE vs. Subqueries:
- **Readability**: CTEs are generally more readable than subqueries, especially in complex queries.
- **Reusability**: A CTE can be referenced multiple times within a query, while subqueries cannot.
- **Performance**: SQL Server may optimize both CTEs and subqueries in the same way. However, when used incorrectly, CTEs might not always perform better than subqueries.

### Limitations:
- CTEs cannot be indexed or have constraints.
- They are not stored in memory; each time they are used, the query inside the CTE runs again.

### When to Use CTEs:
1. **Improving readability** of complex queries.
2. **Breaking down logic** into smaller, manageable steps.
3. **Handling recursive data** for hierarchical structures.
4. When the result set of a CTE is needed multiple times in a query.

CTEs are ideal for simplifying queries and working with hierarchical or recursive data.


## Using case statements:
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

- for aggregation, we cant directly use total_value variable 
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
case 
when sum(quantity*list_price) < 500 then 'very low'
when sum(quantity*list_price) >= 500 and sum(quantity*list_price) < 1000 then 'low'
when sum(quantity*list_price) >= 1000 and sum(quantity*list_price) < 5000 then 'medium'
when sum(quantity*list_price) >= 5000 then 'very high'
else 
	'not found!'
end as order_tag
from sales.order_items
group by ordeR_id

- we can also use this as we execute in order:

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

- we can simplify and eliminate redundant queries by using cte/subquery

-- in this case, we cant give q query like this
- SELECT order_id, 
       SUM(quantity * list_price) AS total_value,
       CASE total_value 
           WHEN total_value < 500 THEN 'very low'
           WHEN total_value  < 1000 THEN 'low'
           WHEN total_value  < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM sales.order_items
GROUP BY order_id;

> The reason your query doesn't work is because in SQL, you cannot use an alias (like total_value) directly inside a CASE statement within the same SELECT clause. SQL processes the SELECT clause in a specific order, and total_value is only available after the SUM(quantity * list_price) has been computed, not when the CASE expression is being evaluated.
> so we use cte/subqueries
- cte
- -- 1.cte
WITH OrderValues AS (
    SELECT order_id, 
           SUM(quantity * list_price) AS total_value
    FROM sales.order_items
    GROUP BY order_id
)
- SELECT order_id, 
       total_value,
       CASE 
           WHEN total_value < 500 THEN 'very low'
           WHEN total_value < 1000 THEN 'low'
           WHEN total_value < 5000 THEN 'medium'
           ELSE 'very high'
       END AS order_tag
FROM OrderValues;

- 2.subquery
- SELECT order_id, 
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
- NULL

- - nullif will be used whend coding in stored procdures
- - when we intentionally want to gie a nullvalue when two cells matches

> The NULLIF function in SQL returns NULL if two expressions are equal; otherwise, it returns the first expression. It is often used to avoid division by zero or to handle specific cases where you want to replace certain values with NULL.
- select nullif(10,10) result --> null if matches

- select nullif(8,10) result --
The `NULLIF` function in SQL returns `NULL` if two expressions are equal; otherwise, it returns the first expression. It is often used to avoid division by zero or to handle specific cases where you want to replace certain values with `NULL`.

### Syntax:
```sql
NULLIF(expression1, expression2)
```
If `expression1` equals `expression2`, `NULLIF` returns `NULL`. If they are not equal, it returns `expression1`.

### 1. **Avoid Division by Zero**:
When you are dividing numbers and want to avoid a division by zero error, `NULLIF` can help by returning `NULL` if the denominator is zero.

```sql
SELECT order_id, 
       quantity, 
       list_price, 
       quantity / NULLIF(list_price, 0) AS price_per_item
FROM sales.order_items;
```
In this example:
- If `list_price` is `0`, `NULLIF(list_price, 0)` returns `NULL`, preventing a division by zero error.
- If `list_price` is not `0`, the division proceeds as usual.

### 2. **Replace Zero with NULL**:
You can use `NULLIF` to treat zero as `NULL` in certain calculations or results.

```sql
SELECT product_id, 
       NULLIF(stock_quantity, 0) AS stock_available
FROM inventory;
```
In this example, if `stock_quantity` is `0`, it will be returned as `NULL` instead of `0`. This can help differentiate between zero stock and unknown stock.

### 3. **Avoid Returning Repetitive Data**:
Sometimes, you might want to return `NULL` if two columns have the same value to highlight cases where the data is different.

```sql
SELECT customer_id, 
       phone_number, 
       NULLIF(phone_number, alternate_phone_number) AS alternate_phone_number
FROM customers;
```
Here:
- If the `phone_number` and `alternate_phone_number` are the same, it returns `NULL` for the `alternate_phone_number`.
- If they are different, the actual `alternate_phone_number` is returned.

### 4. **Compare Dates and Return NULL**:
You can use `NULLIF` to check if two dates are the same and return `NULL` if they are.

```sql
SELECT employee_id, 
       hire_date, 
       NULLIF(termination_date, hire_date) AS actual_termination_date
FROM employees;
```
If an employee's `termination_date` is the same as the `hire_date`, this query returns `NULL` instead of the `termination_date`, assuming it could be a data entry mistake or an irrelevant value.

### 5. **Use with Aggregations**:
`NULLIF` can be used in aggregations to exclude certain values from calculations.

```sql
SELECT AVG(NULLIF(salary, 0)) AS avg_salary
FROM employees;
```
This excludes `0` from the average salary calculation by converting it to `NULL`.

### 6. **Conditional Checks for Equality**:
Use `NULLIF` when you want to treat equal values as `NULL` in your results.

```sql
SELECT product_id, 
       price, 
       NULLIF(price, discounted_price) AS effective_price
FROM products;
```
If `price` is the same as `discounted_price`, it returns `NULL` (indicating no discount), otherwise, it returns the `price`.

## null
-- replaces some value with null
	select *, nullif(manager,104) manager from SalesReps
![image](https://github.com/user-attachments/assets/03b093dd-f431-4ae3-a68d-042780a47d3b)
## coalesce
![image](https://github.com/user-attachments/assets/bf7f86e0-d76c-4fcc-8991-4072c1f9e2a2)
