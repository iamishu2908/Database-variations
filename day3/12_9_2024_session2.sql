
-- session 2 - 12/9/24
select * from production.categories;
select * from production.products;

-- no of products under each category

select c.category_name, count(*) as total
from production.categories c
join production.products p
on c.category_id = p.category_id
group by c.category_name

select c.category_name, p.model_year, count(*) as total
from production.categories c
join production.products p
on c.category_id = p.category_id
group by c.category_name, p.model_year


-- pivot:
-- useful when working with analytics
-- req: category name in row, and count in value

select c.category_name, p.product_id
from production.categories c
inner join production.products p
on c.category_id = p.category_id

-- using pivot, we make it more presentable
select * from (
	select category_name, product_id
	from production.categories c
	inner join production.products p
	on c.category_id = p.category_id
) as t
pivot (
	count(product_id)
	for category_name in ([Children Bicycles], [Comfort Bicycles], [Cruisers Bicycles], [Cyclocross Bicycles], [Electric Bikes], [Mountain Bikes], [Road Bikes] )
	) as pivot_table;


-- in general, we dont need to mention p. and c. for every table if they column names are different
-- dont need to use the alias variable.

select * from (
	select category_name, product_id, model_year
	from production.categories c
	inner join production.products p
	on c.category_id = p.category_id
) as t
pivot (
	count(product_id)
	for category_name in ([Children Bicycles], [Comfort Bicycles], [Cruisers Bicycles], [Cyclocross Bicycles], [Electric Bikes], [Mountain Bikes], [Road Bikes] )
	) as pivot_table;

--------------------------------------------------------------------

create table customers (
id INT IDENTITY (1,1) PRIMARY KEY,
subsription_plan VARCHAR(255) NOT NULL,
subscribed_customer int NOT NULL,
date date
);

insert into customers values
('premium', 2, '2024-06-01'), 
('basics', 13, '2024-06-02'), 
('ultimate', 14, '2024-06-03'),
('premium', 12, '2024-06-04'),
('premium', 23, '2024-06-05'), 
('basics', 32, '2024-06-05'), 
('ultimate', 4, '2024-06-04'),
('premium', 24, '2024-06-06'),
('premium', 28, '2024-06-21'), 
('basics', 38, '2024-06-2'), 
('ultimate', 46, '2024-07-03'),
('premium', 23, '2024-09-04'),
('premium', 22, '2024-09-01'), 
('basics', 35, '2024-06-02'), 
('ultimate', 43, '2024-06-09'),
('premium', 22, '2023-06-08'), 
('basics', 31, '2023-06-02'), 
('ultimate', 42, '2024-02-03'),
('premium', 23, '2024-05-04'),
('premium', 12, '2024-06-04')

select * from customers;
-----------------------------------------------

-- query: 
select date, count(*) as total from customers group by date

-- transform the above as analytics

select * from (
select subscribed_customer, subsription_plan, date from customers
) as t
pivot (
sum(subscribed_customer)
for date in ([2024-06-01],[2024-6-04],[2024-06-02],[2024-06-05])
)
as pivot_table

-- how to avoid typing the column names manually under IN? use @
-----------------------------------------------------------------------------
-- stored procedure
-- dynamic printing of column names using store procedure
declare 
@columns NVARCHAR(MAX) = '';

select 
@columns += QUOTENAME(category_name) + ','
from production.categories
order by category_name;

-- removing string, we use LEFT operator

set @columns = LEFT(@columns, LEN(@columns) - 1);
print(@columns)



