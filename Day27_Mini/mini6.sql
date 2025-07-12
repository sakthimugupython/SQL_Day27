-- 6. Regional Revenue Tracker

CREATE DATABASE ZoneSalesTracker;
USE ZoneSalesTracker;

CREATE TABLE Location_Dim (
  loc_id INT PRIMARY KEY,
  city_name VARCHAR(50),
  zone_name VARCHAR(50)
);

CREATE TABLE Client_Dim (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(100),
  loc_id INT,
  FOREIGN KEY (loc_id) REFERENCES Location_Dim(loc_id)
);

CREATE TABLE Product_Dim (
  prod_id INT PRIMARY KEY,
  prod_name VARCHAR(100),
  prod_type VARCHAR(50)
);

CREATE TABLE Sales_Fact (
  trans_id INT PRIMARY KEY,
  client_id INT,
  prod_id INT,
  qty INT,
  revenue DECIMAL(10,2),
  FOREIGN KEY (client_id) REFERENCES Client_Dim(client_id),
  FOREIGN KEY (prod_id) REFERENCES Product_Dim(prod_id)
);

INSERT INTO Location_Dim VALUES
(10, 'Bangalore', 'South'),
(11, 'Pune', 'West'),
(12, 'Lucknow', 'North');

INSERT INTO Client_Dim VALUES
(201, 'Sneha Das', 10),
(202, 'Manish Jain', 11),
(203, 'Tanya Rao', 12);

INSERT INTO Product_Dim VALUES
(301, 'Washing Machine', 'Home Appliance'),
(302, 'Tablet', 'Electronics'),
(303, 'Notebook', 'Stationery');

INSERT INTO Sales_Fact VALUES
(1001, 201, 301, 1, 30000),
(1002, 202, 302, 1, 20000),
(1003, 203, 303, 25, 1250),
(1004, 202, 303, 50, 2500),
(1005, 201, 302, 1, 20000);

SELECT 
  ld.zone_name,
  pd.prod_type,
  SUM(sf.revenue) AS zone_revenue
FROM Sales_Fact sf
JOIN Client_Dim cd ON sf.client_id = cd.client_id
JOIN Location_Dim ld ON cd.loc_id = ld.loc_id
JOIN Product_Dim pd ON sf.prod_id = pd.prod_id
GROUP BY ld.zone_name, pd.prod_type
HAVING zone_revenue > 10000
ORDER BY zone_revenue DESC;
