-- 14. Geo-Sales Heatmap Database

CREATE DATABASE RegionalSalesHeatmapDB;
USE RegionalSalesHeatmapDB;

CREATE TABLE Transactions (
  txn_id INT PRIMARY KEY,
  buyer_name VARCHAR(100),
  city_name VARCHAR(50),
  region_name VARCHAR(50),
  txn_amount DECIMAL(10,2)
);

CREATE TABLE dw_region_sales (
  region_name VARCHAR(100),
  aggregated_revenue DECIMAL(10,2)
);

INSERT INTO Transactions VALUES
(101, 'Meena Iyer', 'Delhi', 'Delhi NCR', 22000),
(102, 'Rohit Sen', 'Gurgaon', 'Delhi NCR', 28000),
(103, 'Karan Mehta', 'Hyderabad', 'Telangana', 26000),
(104, 'Tina Kapoor', 'Kolkata', 'West Bengal', 17000),
(105, 'Ajay Nair', 'Ernakulam', 'Kerala', 15000);

INSERT INTO dw_region_sales
SELECT 
  region_name,
  SUM(txn_amount) AS aggregated_revenue
FROM Transactions
GROUP BY region_name;

SELECT * FROM dw_region_sales;
