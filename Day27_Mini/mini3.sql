-- 3. Monthly Sales Summary Report

CREATE DATABASE SalesSummaryData;
USE SalesSummaryData;

CREATE TABLE SalesOrders (
  sales_id INT PRIMARY KEY,
  client_name VARCHAR(100),
  sales_date DATE,
  sales_amount DECIMAL(10,2)
);

INSERT INTO SalesOrders VALUES
(101, 'Divya Mehra', '2024-01-10', 25000),
(102, 'Arjun Singh', '2024-01-28', 19000),
(103, 'Pooja Sinha', '2024-02-12', 30000),
(104, 'Karan Patel', '2024-02-24', 29000),
(105, 'Sonal Reddy', '2024-03-07', 27000),
(106, 'Rahul Desai', '2024-03-19', 26000);

SELECT 
  YEAR(sales_date) AS fiscal_year,
  MONTH(sales_date) AS fiscal_month,
  COUNT(*) AS order_count,
  SUM(sales_amount) AS revenue_total
FROM SalesOrders
GROUP BY fiscal_year, fiscal_month
HAVING revenue_total > 50000
ORDER BY fiscal_year, fiscal_month;
