-- 5. Product Category Performance (Star vs Snowflake)

CREATE DATABASE ProductAnalysisSnowflake;
USE ProductAnalysisSnowflake;

CREATE TABLE Category_Master (
  cat_id INT PRIMARY KEY,
  cat_title VARCHAR(50)
);

CREATE TABLE Product_Master (
  prod_id INT PRIMARY KEY,
  prod_title VARCHAR(100),
  cat_id INT,
  FOREIGN KEY (cat_id) REFERENCES Category_Master(cat_id)
);

CREATE TABLE Sales_Fact (
  txn_id INT PRIMARY KEY,
  prod_id INT,
  qty INT,
  total_value DECIMAL(10,2),
  txn_date DATE,
  FOREIGN KEY (prod_id) REFERENCES Product_Master(prod_id)
);

INSERT INTO Category_Master VALUES
(11, 'Appliances'),
(12, 'Office');

INSERT INTO Product_Master VALUES
(201, 'Refrigerator', 11),
(202, 'Microwave', 11),
(203, 'File Folder', 12);

INSERT INTO Sales_Fact VALUES
(1001, 201, 1, 40000.00, '2024-01-12'),
(1002, 202, 2, 30000.00, '2024-02-20'),
(1003, 203, 15, 2250.00, '2024-03-05'),
(1004, 202, 1, 15000.00, '2024-03-20');

SELECT 
  cm.cat_title,
  pm.prod_title,
  SUM(sf.qty) AS units_sold,
  SUM(sf.total_value) AS total_earned
FROM Sales_Fact sf
JOIN Product_Master pm ON sf.prod_id = pm.prod_id
JOIN Category_Master cm ON pm.cat_id = cm.cat_id
GROUP BY cm.cat_title, pm.prod_title;

EXPLAIN SELECT 
  cm.cat_title,
  pm.prod_title,
  SUM(sf.qty),
  SUM(sf.total_value)
FROM Sales_Fact sf
JOIN Product_Master pm ON sf.prod_id = pm.prod_id
JOIN Category_Master cm ON pm.cat_id = cm.cat_id
GROUP BY cm.cat_title, pm.prod_title;
