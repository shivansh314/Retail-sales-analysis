-- SQL Retailes sales analysis 
create database retail_sales_analysis ;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10

SELECT * 
FROM retail_sales 
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR gender IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;

 -- deleting the null values 
delete from retail_sales  
WHERE transaction_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR gender IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL 



-- data exploration 

-- how many sales we have ? 

select count ( transaction_id ) from retail_sales ; 

-- how many unique customer we have ?
select count( distinct customer_id ) from retail_sales ;

-- distinct / unique category 
select distinct category from retail_sales ; 


-- Data Analysis and Business Problem 

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05' ?
select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is
--more than 4 in the month of Nov-2022 ?

select * from retail_sales where 
	category = 'Clothing' AND 
	TO_CHAR(sale_date , 'YYYY-MM') = '2022-11' AND
	quantity >= 4 ;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, 
    SUM(total_sale) AS net_sale, 
    COUNT(transaction_id) AS total_order
FROM retail_sales
GROUP BY category
ORDER BY net_sale DESC;

						-- my solution 
select
	distinct category , 
	sum( total_sale ) over(partition by category ) as net_sales , 
	count( transaction_id ) over(partition by category ) as total_sales 
from retail_sales order by category desc




-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age) , 2 ) from retail_sales where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000 ; 

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender , count(transaction_id) as total_number
from retail_sales group by gender order by gender 


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year , month , sale from (
select   extract ( year from sale_date ) as year ,
		 extract ( month from sale_date ) as month , 
		 avg ( total_sale) as sale , 
		 rank() over(partition by  extract ( year from sale_date ) order by  avg ( total_sale) desc ) as rnk
from retail_sales group by 1 , 2 ) as t1 
where rnk = 1 ; 

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
     customer_id , 
	 sum ( total_sale ) as sale 
FROM retail_sales group by 1 order by 2 desc limit  5 


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from 'each category'.
select category , count ( distinct customer_id ) 
from retail_sales group by category 


-- Q.10 Write a SQL query to create each shift and number of orders 
--(Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift



-- Q.11 How many number of customer purchased an item from each category 
select count( customer_id  ) from (
SELECT DISTINCT r1.customer_id
FROM retail_sales r1
JOIN retail_sales r2 ON r1.customer_id = r2.customer_id
JOIN retail_sales r3 ON r1.customer_id = r3.customer_id
WHERE r1.category = 'Clothing'
AND r2.category = 'Electronics'
AND r3.category = 'Beauty')




   
