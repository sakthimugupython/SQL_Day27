-- 4. Customer Segmentation for Marketing

CREATE DATABASE ClientMarketingDB;
USE ClientMarketingDB;

CREATE TABLE Transactions (
  txn_id INT PRIMARY KEY,
  client_id INT,
  client_name VARCHAR(100),
  txn_amount DECIMAL(10,2)
);

INSERT INTO Transactions VALUES
(1001, 201, 'Meera Sinha', 16000),
(1002, 201, 'Meera Sinha', 17000),
(1003, 202, 'Rajesh Iyer', 12000),
(1004, 203, 'Sneha Kapoor', 9000),
(1005, 204, 'Manoj K', 4000),
(1006, 204, 'Manoj K', 3000);

CREATE TABLE client_segments (
  client_id INT,
  client_name VARCHAR(100),
  total_spend DECIMAL(10,2),
  segment_label VARCHAR(20)
);

INSERT INTO client_segments
SELECT 
  client_id,
  client_name,
  SUM(txn_amount) AS total_spend,
  CASE 
    WHEN SUM(txn_amount) > 30000 THEN 'Gold'
    WHEN SUM(txn_amount) BETWEEN 15000 AND 30000 THEN 'Silver'
    ELSE 'Bronze'
  END AS segment_label
FROM Transactions
GROUP BY client_id, client_name;

SELECT * FROM client_segments;
