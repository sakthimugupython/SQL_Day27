-- 13. Category-wise Profit Margin Report

CREATE DATABASE MarginAnalysisDB;
USE MarginAnalysisDB;

CREATE TABLE Items (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(100),
  item_group VARCHAR(50),
  item_cost DECIMAL(10,2)
);

CREATE TABLE Sales (
  sale_id INT PRIMARY KEY,
  item_id INT,
  qty INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

CREATE TABLE profit_summary (
  item_group VARCHAR(50),
  gross_revenue DECIMAL(10,2),
  gross_cost DECIMAL(10,2),
  net_profit DECIMAL(10,2)
);

INSERT INTO Items VALUES
(10, 'Tablet', 'Electronics', 15000),
(11, 'Keyboard', 'Electronics', 1200),
(12, 'Marker', 'Stationery', 8),
(13, 'Folder', 'Stationery', 15);

INSERT INTO Sales VALUES
(201, 10, 3, 25000),
(202, 11, 5, 2000),
(203, 12, 200, 12),
(204, 13, 100, 20);

INSERT INTO profit_summary
SELECT 
  i.item_group,
  SUM(s.qty * s.unit_price) AS gross_revenue,
  SUM(s.qty * i.item_cost) AS gross_cost,
  SUM(s.qty * s.unit_price) - SUM(s.qty * i.item_cost) AS net_profit
FROM Items i
JOIN Sales s ON i.item_id = s.item_id
GROUP BY i.item_group
HAVING net_profit > 10000;

SELECT * FROM profit_summary;
