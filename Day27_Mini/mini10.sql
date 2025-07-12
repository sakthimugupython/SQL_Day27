-- 10. Customer Churn Prediction Report

CREATE DATABASE InactiveClientsDB;
USE InactiveClientsDB;

CREATE TABLE ClientInfo (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(100),
  recent_txn_date DATE
);

CREATE TABLE churn_list (
  client_id INT,
  client_name VARCHAR(100),
  inactivity_days INT,
  flagged_on DATE
);

INSERT INTO ClientInfo VALUES
(101, 'Pooja Desai', '2024-01-20'),
(102, 'Rohan Singh', '2024-03-01'),
(103, 'Tina Iyer', '2023-11-15'),
(104, 'Arjun Rao', '2024-05-10'),
(105, 'Divya Shah', '2024-02-25');

INSERT INTO churn_list
SELECT 
  client_id,
  client_name,
  DATEDIFF(CURDATE(), recent_txn_date) AS inactivity_days,
  CURDATE() AS flagged_on
FROM ClientInfo
WHERE DATEDIFF(CURDATE(), recent_txn_date) > 90;

SELECT * FROM churn_list;
