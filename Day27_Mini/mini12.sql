-- 12. Daily ETL Pipeline Simulation

CREATE DATABASE ETLProcessDB;
USE ETLProcessDB;

CREATE TABLE staging_orders (
  txn_id INT PRIMARY KEY,
  client_name VARCHAR(100),
  txn_total DECIMAL(10,2)
);

CREATE TABLE warehouse_orders (
  txn_id INT PRIMARY KEY,
  client_name VARCHAR(100),
  txn_total DECIMAL(10,2),
  inserted_on DATE
);

CREATE TABLE etl_job_status (
  etl_id INT AUTO_INCREMENT PRIMARY KEY,
  etl_status VARCHAR(50),
  etl_date DATE
);

INSERT INTO staging_orders VALUES
(1001, 'meena singh', 10020.879),
(1002, 'rohit kumar', 5800.155),
(1003, 'tanya jain', 9420.675);


INSERT INTO warehouse_orders
SELECT 
  txn_id,
  UPPER(client_name),
  ROUND(txn_total, 2),
  CURDATE()
FROM staging_orders;


INSERT INTO etl_job_status (etl_status, etl_date)
VALUES ('SUCCESS', CURDATE());

SELECT * FROM warehouse_orders;
SELECT * FROM etl_job_status;
