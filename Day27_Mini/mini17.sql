-- 17. Sales Representative Performance Analytics

CREATE DATABASE RepAnalyticsDB;
USE RepAnalyticsDB;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100)
);

CREATE TABLE Deals (
  deal_id INT PRIMARY KEY,
  emp_id INT,
  deal_value DECIMAL(10,2),
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

CREATE TABLE rep_performance_summary (
  emp_id INT,
  emp_name VARCHAR(100),
  total_deals DECIMAL(10,2),
  position INT
);

INSERT INTO Employees VALUES
(10, 'Rohit Sinha'),
(11, 'Kavita Reddy'),
(12, 'Ajay Nair'),
(13, 'Meena Iyer');

INSERT INTO Deals VALUES
(201, 10, 35000),
(202, 10, 30000),
(203, 11, 42000),
(204, 11, 38000),
(205, 12, 25000),
(206, 13, 60000);

INSERT INTO rep_performance_summary
SELECT 
  e.emp_id,
  e.emp_name,
  SUM(d.deal_value) AS total_deals,
  ROW_NUMBER() OVER (ORDER BY SUM(d.deal_value) DESC) AS position
FROM Employees e
JOIN Deals d ON e.emp_id = d.emp_id
GROUP BY e.emp_id, e.emp_name;

SELECT * FROM rep_performance_summary;
