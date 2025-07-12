-- 11. Financial Year Revenue Dashboard

CREATE DATABASE FiscalRevenueDB;
USE FiscalRevenueDB;

CREATE TABLE Transactions (
  txn_id INT PRIMARY KEY,
  txn_date DATE,
  txn_amount DECIMAL(10,2)
);

INSERT INTO Transactions VALUES
(101, '2023-03-10', 18000),
(102, '2023-04-22', 26000),
(103, '2023-06-30', 35000),
(104, '2023-09-05', 31000),
(105, '2023-12-12', 41000),
(106, '2024-02-28', 47000),
(107, '2024-03-31', 38000),
(108, '2024-04-15', 24000),
(109, '2024-05-10', 29000),
(110, '2024-06-25', 33000);

WITH FiscalData AS (
  SELECT 
    txn_id,
    txn_date,
    txn_amount,
    CASE 
      WHEN MONTH(txn_date) >= 4 THEN YEAR(txn_date)
      ELSE YEAR(txn_date) - 1
    END AS fy_year,
    MONTH(txn_date) AS fy_month
  FROM Transactions
)
SELECT 
  fy_year,
  fy_month,
  SUM(txn_amount) AS total_revenue
FROM FiscalData
GROUP BY fy_year, fy_month
ORDER BY fy_year, fy_month;
