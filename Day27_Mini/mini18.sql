-- 18. Flash Sales Impact Report

CREATE DATABASE CampaignAnalyticsDB;
USE CampaignAnalyticsDB;

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  item_name VARCHAR(100),
  order_date DATE,
  order_value DECIMAL(10,2)
);

CREATE TABLE flash_sale_analysis (
  sale_phase VARCHAR(50),
  revenue DECIMAL(10,2)
);

INSERT INTO Orders VALUES
(101, 'Headphones', '2024-06-01', 10000),
(102, 'Tablet', '2024-06-03', 25000),
(103, 'Camera', '2024-06-05', 30000),
(104, 'Headphones', '2024-06-06', 12000),
(105, 'Camera', '2024-06-08', 20000),
(106, 'Tablet', '2024-06-11', 35000),
(107, 'Camera', '2024-06-14', 40000),
(108, 'Tablet', '2024-06-17', 22000);

WITH TimeSlots AS (
  SELECT 
    CASE
      WHEN order_date < '2024-06-05' THEN 'Pre-Campaign'
      WHEN order_date BETWEEN '2024-06-05' AND '2024-06-10' THEN 'Active Campaign'
      ELSE 'Post-Campaign'
    END AS sale_phase,
    order_value
  FROM Orders
)
SELECT sale_phase, SUM(order_value) AS revenue
FROM TimeSlots
GROUP BY sale_phase;

INSERT INTO flash_sale_analysis
SELECT * FROM (
  WITH TimeSlots AS (
    SELECT 
      CASE
        WHEN order_date < '2024-06-05' THEN 'Pre-Campaign'
        WHEN order_date BETWEEN '2024-06-05' AND '2024-06-10' THEN 'Active Campaign'
        ELSE 'Post-Campaign'
      END AS sale_phase,
      order_value
    FROM Orders
  )
  SELECT sale_phase, SUM(order_value) AS revenue
  FROM TimeSlots
  GROUP BY sale_phase
) AS FinalInsert;

SELECT * FROM flash_sale_analysis;