-- 2. Online Orders Dashboard (OLTP vs OLAP)

CREATE DATABASE EcommerceData;
USE EcommerceData;

CREATE TABLE Item (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(100),
  unit_price DECIMAL(10,2)
);

CREATE TABLE Buyer (
  buyer_id INT PRIMARY KEY,
  buyer_name VARCHAR(100)
);

CREATE TABLE Purchase (
  purchase_id INT PRIMARY KEY,
  buyer_id INT,
  item_id INT,
  qty INT,
  purchase_date DATE,
  FOREIGN KEY (buyer_id) REFERENCES Buyer(buyer_id),
  FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

INSERT INTO Item VALUES
(10, 'Stapler', 50.00),
(11, 'Folder', 30.00),
(12, 'Glue', 15.00);

INSERT INTO Buyer VALUES
(201, 'Kiran Rao'),
(202, 'Manoj Das'),
(203, 'Sneha Reddy');

INSERT INTO Purchase VALUES
(9001, 201, 10, 1, '2024-01-12'),
(9002, 202, 11, 4, '2024-01-25'),
(9003, 201, 12, 5, '2024-02-14'),
(9004, 203, 10, 2, '2024-03-01'),
(9005, 202, 11, 3, '2024-03-18');

SELECT purchase_id, buyer_name, item_name, qty, purchase_date
FROM Purchase p
JOIN Buyer b ON p.buyer_id = b.buyer_id
JOIN Item i ON p.item_id = i.item_id
ORDER BY purchase_date;

CREATE TABLE Purchase_Monthly_Analytics AS
SELECT 
  YEAR(purchase_date) AS year,
  MONTH(purchase_date) AS month,
  i.item_name,
  SUM(qty) AS total_qty,
  SUM(qty * i.unit_price) AS total_revenue
FROM Purchase p
JOIN Item i ON p.item_id = i.item_id
GROUP BY year, month, i.item_name;

SELECT * FROM Purchase_Monthly_Analytics;
