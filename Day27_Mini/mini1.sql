-- 1. Retail Sales Data Warehouse

CREATE DATABASE SmartSalesDW;
USE SmartSalesDW;

CREATE TABLE Product_Dim (
  prod_id INT PRIMARY KEY,
  prod_name VARCHAR(100),
  prod_type VARCHAR(50)
);

CREATE TABLE Customer_Dim (
  cust_id INT PRIMARY KEY,
  cust_name VARCHAR(100),
  cust_segment VARCHAR(50)
);

CREATE TABLE Time_Dim (
  date_id INT PRIMARY KEY,
  order_day DATE,
  month_label VARCHAR(20),
  fiscal_year INT
);

CREATE TABLE Location_Dim (
  loc_id INT PRIMARY KEY,
  city_name VARCHAR(50),
  state_name VARCHAR(50),
  region_name VARCHAR(50)
);

CREATE TABLE Sales_Fact (
  txn_id INT PRIMARY KEY,
  prod_id INT,
  cust_id INT,
  date_id INT,
  loc_id INT,
  units INT,
  sales_value DECIMAL(10,2),
  FOREIGN KEY (prod_id) REFERENCES Product_Dim(prod_id),
  FOREIGN KEY (cust_id) REFERENCES Customer_Dim(cust_id),
  FOREIGN KEY (date_id) REFERENCES Time_Dim(date_id),
  FOREIGN KEY (loc_id) REFERENCES Location_Dim(loc_id)
);

INSERT INTO Product_Dim VALUES
(10, 'Toothpaste', 'Hygiene'),
(11, 'Marker', 'Office Supply'),
(12, 'Eraser', 'Office Supply');

INSERT INTO Customer_Dim VALUES
(201, 'Deepak Joshi', 'Silver'),
(202, 'Meena Rao', 'Bronze'),
(203, 'Nikhil Verma', 'Gold');

INSERT INTO Time_Dim VALUES
(501, '2024-01-20', 'January', 2024),
(502, '2024-02-18', 'February', 2024),
(503, '2024-03-22', 'March', 2024);

INSERT INTO Location_Dim VALUES
(601, 'Bangalore', 'Karnataka', 'South'),
(602, 'Pune', 'Maharashtra', 'West'),
(603, 'Kolkata', 'West Bengal', 'East');

INSERT INTO Sales_Fact VALUES
(9001, 10, 203, 501, 601, 3, 180.00),
(9002, 11, 201, 502, 602, 6, 180.00),
(9003, 12, 202, 503, 603, 8, 80.00),
(9004, 10, 201, 503, 603, 1, 60.00),
(9005, 11, 202, 502, 602, 2, 60.00);

SELECT prod_name, SUM(units) AS total_units_sold
FROM Sales_Fact sf
JOIN Product_Dim pd ON sf.prod_id = pd.prod_id
GROUP BY prod_name
ORDER BY total_units_sold DESC
LIMIT 3;

SELECT td.month_label, td.fiscal_year, SUM(sf.sales_value) AS monthly_revenue
FROM Sales_Fact sf
JOIN Time_Dim td ON sf.date_id = td.date_id
GROUP BY td.fiscal_year, td.month_label
ORDER BY td.fiscal_year, FIELD(td.month_label, 'January','February','March','April','May','June','July','August','September','October','November','December');

SELECT cust_segment, SUM(sales_value) AS total_spent
FROM Sales_Fact sf
JOIN Customer_Dim cd ON sf.cust_id = cd.cust_id
GROUP BY cust_segment
ORDER BY total_spent DESC;
