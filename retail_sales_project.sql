SELECT * FROM retail_sales;

-- Find null values

select * from retail_sales where 
transactions_id is null or
sale_date is null
or sale_time is null
or gender is null
or category is null
or quantity is null or
cogs is null or total_sale is null;

-- Delete null values

delete from retail_sales
where transactions_id is null or
sale_date is null
or sale_time is null
or gender is null
or category is null
or quantity is null or
cogs is null or total_sale is null;

-- Data Exploration

-- How many Sales we have?

select count(*) as total_sale from retail_sales;

-- How many unique customers we have?

select count(distinct customer_id) as total_customer from retail_sales;

select distinct category as total_category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--     and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
-- Q.10 Write a SQL query to create each shift and number of orders 
--      (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * 
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--     and the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where category = 'Clothing'
and
date_format(sale_date, '%Y-%m') = '2022-11'
and
quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

select category, sum(total_sale) as net_sales,
count(*) as total_orders
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers 
--     who purchased items from the 'Beauty' category

select category, round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where 
--     the total_sale is greater than 1000

select * from 
retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
--     made by each gender in each category

select category, gender, 
count(*) as total_no_of_transactions
from retail_sales
group by 1,2
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. 
--     Find out best selling month in each year

select year, month, 
avg_sale from
(
select year(sale_date) as year, month(sale_date) as month,
round(avg(total_sale), 2) as avg_sale,
rank() over(partition by year(sale_date) order by round(avg(total_sale), 2) desc)
as rnk 
from retail_sales
group by 1,2
) as t1
where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id, 
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers 
--     who purchased items from each category

select category, count(distinct customer_id) 
as count_unique_cust
from retail_sales
group by 1
order by count_unique_cust desc;

-- Q.10 Write a SQL query to create each shift and number of orders 
--      (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale as (
select *, 
    case
        when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
     end as shift
from retail_sales
)
select shift, 
count(*) as total_orders
from hourly_sale
group by shift;    

-- End of project         