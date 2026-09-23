# Retail Sales SQL Analysis

## Project Overview

This project analyzes a retail sales dataset using PostgreSQL SQL.

The project covers:

-   Database and table creation
-   Data cleaning
-   Data exploration
-   Customer and category analysis
-   Sales analysis
-   Transaction analysis
-   Monthly sales analysis
-   Top customers
-   Unique customers by category
-   Order shifts based on sale time

------------------------------------------------------------------------

## Dataset Structure

The `retail_sales` table contains the following columns:

  Column             Data Type     Description
  ------------------ ------------- -------------------------------
  `transaction_id`   INT           Unique transaction identifier
  `sale_date`        DATE          Date of the sale
  `sale_time`        TIME          Time of the sale
  `customer_id`      INT           Customer identifier
  `gender`           VARCHAR(15)   Customer gender
  `age`              INT           Customer age
  `category`         VARCHAR(15)   Product category
  `quantity`         INT           Quantity purchased
  `price_per_unit`   FLOAT         Price per unit
  `cogs`             FLOAT         Cost of goods sold
  `total_sale`       FLOAT         Total sale amount

------------------------------------------------------------------------

# 1. Database and Table Creation

``` sql
CREATE DATABASE sql_project_p2;

DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

------------------------------------------------------------------------

# 2. Data Cleaning

The project checks for missing values in important columns.

``` sql
SELECT *
FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

Rows containing these missing values are deleted:

``` sql
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

------------------------------------------------------------------------

# 3. Data Exploration

## Total Number of Sales

``` sql
SELECT COUNT(*) AS total_sale
FROM retail_sales;
```

## Number of Unique Customers

``` sql
SELECT COUNT(DISTINCT customer_id) AS customer_id
FROM retail_sales;
```

## Number of Unique Categories

``` sql
SELECT COUNT(DISTINCT category)
FROM retail_sales;
```

## List of Categories

``` sql
SELECT DISTINCT category
FROM retail_sales;
```

------------------------------------------------------------------------

# 4. Business Questions and SQL Analysis

## Q1. Sales Made on a Specific Date

**Question:** Retrieve all columns for sales made on `2022-11-05`.

``` sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### Concept Used

-   `SELECT *`
-   `WHERE`
-   Date filtering

------------------------------------------------------------------------

## Q2. Clothing Transactions

**Question:** Retrieve Clothing transactions with quantity at least 4 in
November 2022.

``` sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

### Concept Used

-   Multiple `WHERE` conditions
-   `AND`
-   `TO_CHAR()` for year-month filtering

------------------------------------------------------------------------

## Q3. Total Sales for Each Category

``` sql
SELECT
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### Concept Used

-   `SUM()`
-   `COUNT()`
-   `GROUP BY`

This calculates the total sales and number of orders separately for each
category.

------------------------------------------------------------------------

## Q4. Average Age of Customers Purchasing Beauty Products

``` sql
SELECT ROUND(AVG(age), 2) AS age_avg
FROM retail_sales
WHERE category = 'Beauty';
```

### Concept Used

-   `AVG()`
-   `ROUND()`
-   `WHERE`

------------------------------------------------------------------------

## Q5. Transactions Where Total Sale Is 1000

The query used in the project is:

``` sql
SELECT *
FROM retail_sales
WHERE total_sale = '1000';
```

### Concept Used

-   `WHERE`
-   Filtering by `total_sale`

------------------------------------------------------------------------

## Q6. Number of Transactions by Gender and Category

``` sql
SELECT
    gender,
    category,
    COUNT(transaction_id) AS total_transaction
FROM retail_sales
GROUP BY gender, category;
```

### Concept Used

-   `COUNT()`
-   Multiple-column `GROUP BY`

This groups transactions by both gender and product category.

------------------------------------------------------------------------

## Q7. Average Sale for Each Month

``` sql
SELECT
    TO_CHAR(sale_date, 'YYYY-MM') AS month,
    AVG(total_sale) AS average_sale
FROM retail_sales
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month;
```

### Concept Used

-   `TO_CHAR()`
-   `AVG()`
-   `GROUP BY`
-   `ORDER BY`

------------------------------------------------------------------------

## Q7. Best-Selling Month in Each Year

The project uses a window function to rank months within each year:

``` sql
SELECT *
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sales,
        RANK() OVER(
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE rank = 1;
```

### Concept Used

-   `EXTRACT()`
-   `AVG()`
-   `RANK()`
-   `PARTITION BY`
-   `ORDER BY`
-   Subquery

`RANK()` ranks the months separately for each year.

------------------------------------------------------------------------

## Q8. Top 5 Customers Based on Total Sales

``` sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Concept Used

-   `SUM()`
-   `GROUP BY`
-   `ORDER BY DESC`
-   `LIMIT`

The important part is:

``` sql
SUM(total_sale)
```

If one customer made multiple purchases, all of those sales are added
together before ranking the customer.

------------------------------------------------------------------------

## Q9. Unique Customers by Category

### Method 1: Using CASE

``` sql
SELECT
    COUNT(DISTINCT CASE
        WHEN category = 'Clothing' THEN customer_id
    END) AS clothing_customers,

    COUNT(DISTINCT CASE
        WHEN category = 'Beauty' THEN customer_id
    END) AS beauty_customers,

    COUNT(DISTINCT CASE
        WHEN category = 'Electronics' THEN customer_id
    END) AS electronics_customers
FROM retail_sales;
```

### Method 2: Using GROUP BY

``` sql
SELECT
    COUNT(DISTINCT customer_id),
    category
FROM retail_sales
GROUP BY category;
```

### Concept Used

`DISTINCT` is important because the same customer can purchase from the
same category multiple times.

For example, if customer `101` purchases Clothing 10 times:

``` text
101
101
101
101
101
101
101
101
101
101
```

`COUNT(customer_id)` counts 10 records, while:

``` sql
COUNT(DISTINCT customer_id)
```

counts customer `101` only once.

------------------------------------------------------------------------

## Q10. Create Sales Shifts and Count Orders

The project divides sales into three shifts:

-   Morning: before 12
-   Afternoon: 12 through 17
-   Evening: after 17

``` sql
SELECT
    shift,
    COUNT(total_sale) AS noof_orders
FROM
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12
                THEN 'Morning'

            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
                THEN 'Afternoon'

            ELSE 'Evening'
        END AS shift
    FROM retail_sales
) AS t
GROUP BY shift;
```

### Concept Used

-   `EXTRACT(HOUR FROM sale_time)`
-   `CASE`
-   Subquery
-   `GROUP BY`
-   `COUNT()`

### Shift Logic

``` text
Hour < 12       → Morning
Hour 12–17      → Afternoon
Hour > 17       → Evening
```

------------------------------------------------------------------------

# 5. SQL Concepts Practiced

This project demonstrates the following SQL concepts:

-   `SELECT`
-   `WHERE`
-   `AND`
-   `GROUP BY`
-   `ORDER BY`
-   `LIMIT`
-   `COUNT()`
-   `COUNT(DISTINCT ...)`
-   `SUM()`
-   `AVG()`
-   `ROUND()`
-   `DISTINCT`
-   `CASE`
-   `EXTRACT()`
-   `TO_CHAR()`
-   Subqueries
-   CTE-style analysis concepts
-   Window functions
-   `RANK()`
-   `PARTITION BY`

------------------------------------------------------------------------

# 6. Key Learning Points

### Aggregation

Use aggregation functions to summarize data:

``` sql
SUM(total_sale)
COUNT(transaction_id)
AVG(total_sale)
```

### Grouping

Use `GROUP BY` when you want calculations separately for groups:

``` sql
GROUP BY category
```

or:

``` sql
GROUP BY gender, category
```

### Unique Customers

Use:

``` sql
COUNT(DISTINCT customer_id)
```

when the question asks for the number of different customers rather than
the number of transactions.

### Conditional Logic

Use `CASE` when you need to create categories based on conditions:

``` sql
CASE
    WHEN condition THEN 'value'
    ELSE 'value'
END
```

### Date and Time Extraction

Use:

``` sql
EXTRACT(HOUR FROM sale_time)
```

to extract the hour from a time value.

Use:

``` sql
EXTRACT(YEAR FROM sale_date)
EXTRACT(MONTH FROM sale_date)
```

to extract year and month from a date.

------------------------------------------------------------------------

# 7. Project Summary

This Retail Sales SQL Analysis project uses SQL to clean, explore, and
analyze retail transaction data. The analysis focuses on sales by
category, customer behavior, transaction patterns, monthly sales, top
customers, unique customers, and order distribution across different
time shifts.

The project demonstrates practical SQL skills including filtering,
aggregation, grouping, conditional logic, subqueries, and window
functions.
