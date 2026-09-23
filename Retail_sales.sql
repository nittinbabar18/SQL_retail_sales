CREATE DATABASE sql_project_p2;

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
WHERE transaction_id IS NULL

SELECT COUNT
(*) FROM retail_sales

--Data CLEANING--

SELECT * FROM retail_sales
WHERE
transaction_id IS NULL
 OR
 sale_date IS NULL
  OR
  sale_time IS NULL
  OR
   gender IS NULL
     OR
   age IS NULL
     OR
   category IS NULL
     OR
   quantity IS NULL
    OR
   cogs IS NULL
     OR
    total_sale IS NULL;

DELETE FROM retail_sales	
WHERE
transaction_id IS NULL
 OR
 sale_date IS NULL
  OR
  sale_time IS NULL
  OR
   gender IS NULL
     OR
   age IS NULL
     OR
   category IS NULL
     OR
   quantity IS NULL
    OR
   cogs IS NULL
     OR
    total_sale IS NULL;

--Data Exploration	
--How Many Sales we have

SELECT COUNT(*) AS total_sale FROM retail_sales

SELECT * FROM retail_sales

--HOW MANY UNIQUE CUSTOMERS WE HAVE

SELECT COUNT(DISTINCT customer_id) AS customer_id FROM retail_sales
--HOW MANY UNIQUE CATEGORY WE HAVE
SELECT COUNT(DISTINCT category) FROM retail_sales
SELECT DISTINCT category FROM retail_sales

--Data Analysis & Bussiness key problems & ansers
-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is greater than 4.

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.

-- Q4. Write a SQL query to find the average age of customers who purchased items
-- from the 'Beauty' category.

-- Q5. Write a SQL query to find all transactions where the total sale is greater than 1000.

-- Q6. Write a SQL query to find the total number of transactions (transaction_id)
-- made by each gender in each category.

-- Q7. Write a SQL query to calculate the average sale for each month.
-- Find the average sale for each month in each year.

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

-- Q9. Write a SQL query to find the number of unique customers who purchased
-- items from each category.

-- Q10. Write a SQL query to create each shift and number of orders.
-- Morning < 12, Afternoon between 12 and 17, Evening > 17.



-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is MORE than 4 IN THE MONTH OF NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
AND quantity>=4;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,SUM(total_sale) AS total_sales,COUNT(*) AS TOTAL_ORDERS
FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items
-- from the 'Beauty' category.

SELECT ROUND(AVG(age),2)as age_AVG
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Write a SQL query to find all transactions where the total sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale = '1000';

-- Q6. Write a SQL query to find the total number of transactions (transaction_id)
-- made by each gender in each category.
	  
SELECT gender,category,
COUNT(transaction_id) as total_transaction
FROM retail_sales
GROUP BY gender,category;

-- Q7. Write a SQL query to calculate the average sale for each month.
-- Find out best selling month in each year.

SELECT 
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    AVG(total_sale) AS average_sale
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;
--best seeling month in each year
SELECT * FROM 
( 
 SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS AVG_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank 
	
FROM retail_sales
GROUP BY 
    EXTRACT(YEAR FROM sale_date),
    EXTRACT(MONTH FROM sale_date)
)AS T1
WHERE rank = 1   --- best question


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,SUM(total_sale)AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased
-- items from each category.


SELECT 
    COUNT(DISTINCT CASE WHEN category = 'Clothing' THEN customer_id END) AS clothing_customers,
    COUNT(DISTINCT CASE WHEN category = 'Beauty' THEN customer_id END) AS beauty_customers,
    COUNT(DISTINCT CASE WHEN category = 'Electronics' THEN customer_id END) AS electronics_customers
FROM retail_sales;
 --OR--
SELECT COUNT(DISTINCT customer_id),category
FROM retail_sales
GROUP BY category

-- Q10. Write a SQL query to create each shift and number of orders.
-- Morning < 12, Afternoon between 12 and 17, Evening > 17.
SELECT shift,COUNT(total_sale)as noof_orsers
FROM
(
SELECT *,
    CASE 
	   WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)as t
GROUP BY shift

SELECT EXTRACT(HOUR FROM CURRENT_TIME)
	

  



