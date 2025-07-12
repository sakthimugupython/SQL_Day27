-- 15. Payment Method Effectiveness Report

CREATE DATABASE PaymentAnalyticsDB;
USE PaymentAnalyticsDB;

CREATE TABLE Transactions (
  txn_id INT PRIMARY KEY,
  customer_name VARCHAR(100),
  pay_method VARCHAR(50),
  txn_amount DECIMAL(10,2)
);

INSERT INTO Transactions VALUES
(101, 'Rohit Mehta', 'Credit Card', 17000),
(102, 'Divya Shah', 'UPI', 8000),
(103, 'Ajay Nair', 'Debit Card', 14000),
(104, 'Sunita Iyer', 'Credit Card', 23000),
(105, 'Rajeev Sen', 'UPI', 10000),
(106, 'Kavita Jain', 'Net Banking', 19000),
(107, 'Anil Das', 'Credit Card', 21000),
(108, 'Tanya Malhotra', 'Debit Card', 15000);

SELECT 
  pay_method,
  COUNT(*) AS number_of_txns,
  ROUND(AVG(txn_amount), 2) AS avg_value,
  SUM(txn_amount) AS total_value
FROM Transactions
GROUP BY pay_method
ORDER BY total_value DESC;
