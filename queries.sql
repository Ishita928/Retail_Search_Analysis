-- SQL Retail Sales Analysis 
CREATE DATABASE sql_project_p2;
use sql_project_p2;

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
                quantity INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

select * from retail_sales;
SELECT COUNT(*) FROM retail_sales;
  
-- Data Cleaning
SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- Data Exploration
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales; 

-- Data Analysis & Business Key Problems & Answers
 -- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
Select * from retail_sales where category='clothing' 
and month(sale_date)=11 and year(sale_date)='2022' and quantity >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as totalSales from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT AVG(age) AS average_age 
FROM retail_sales 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,count(case when gender='Male' then 1 end) as male_count,
count(case when gender='Female' then 1 end) as female_count
  from retail_sales group by category  ;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH cte AS (
    SELECT 
        MONTH(sale_date) AS month,
        YEAR(sale_date) AS year,
        ROUND(AVG(total_sale), 2) AS avgsales 
    FROM retail_sales 
    GROUP BY MONTH(sale_date), YEAR(sale_date)
),
ctee as(
SELECT 
    month,
    year,
    avgsales,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY avgsales DESC) AS rn
FROM cte)
select year,month,avgsales from ctee where rn=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id ,sum(total_sale) as total_sales from retail_sales 
group by customer_id order by total_sales desc limit 5 ;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS (
  SELECT *,
    CASE
      WHEN HOUR(sale_time) < 12 THEN 'Morning'
      WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM retail_sales
)
SELECT 
  shift,
  COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- end--