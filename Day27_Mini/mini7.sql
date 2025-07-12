-- 7. Time-Based Revenue Analysis

CREATE DATABASE RevenueTrendsDB;
USE RevenueTrendsDB;

CREATE TABLE Sales (
  sale_id INT PRIMARY KEY,
  sale_date DATE,
  sale_value DECIMAL(10,2)
);

INSERT INTO Sales VALUES
(101, '2024-01-05', 10000),
(102, '2024-01-25', 13000),
(103, '2024-02-10', 22000),
(104, '2024-03-14', 28000),
(105, '2024-03-30', 17000),
(106, '2024-04-18', 24000),
(107, '2024-05-12', 30000),
(108, '2024-06-08', 21000),
(109, '2024-07-21', 33000),
(110, '2024-08-29', 27000);

SELECT 
  EXTRACT(DAY FROM sale_date) AS sale_day,
  EXTRACT(WEEK FROM sale_date) AS sale_week,
  EXTRACT(MONTH FROM sale_date) AS sale_month,
  EXTRACT(QUARTER FROM sale_date) AS sale_quarter,
  EXTRACT(YEAR FROM sale_date) AS sale_year,
  SUM(sale_value) AS total_sales
FROM Sales
GROUP BY sale_year, sale_quarter, sale_month, sale_week, sale_day
ORDER BY sale_year, sale_quarter, sale_month, sale_week, sale_day;

SELECT 
  EXTRACT(QUARTER FROM sale_date) AS qtr,
  SUM(sale_value) AS quarter_sales
FROM Sales
GROUP BY qtr
ORDER BY qtr;

SELECT 
  EXTRACT(MONTH FROM sale_date) AS peak_month,
  SUM(sale_value) AS total_monthly_sales
FROM Sales
GROUP BY peak_month
ORDER BY total_monthly_sales DESC
LIMIT 1;
