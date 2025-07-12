-- 9. Product Stock Analysis

CREATE DATABASE InventoryAlertDB;
USE InventoryAlertDB;

CREATE TABLE ItemMaster (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(100),
  opening_stock INT,
  reorder_level INT
);

CREATE TABLE ItemSales (
  tx_id INT PRIMARY KEY,
  item_id INT,
  sold_qty INT,
  tx_date DATE,
  FOREIGN KEY (item_id) REFERENCES ItemMaster(item_id)
);

CREATE TABLE stock_notifications (
  item_id INT,
  item_name VARCHAR(100),
  current_stock INT,
  notify_date DATE
);

INSERT INTO ItemMaster VALUES
(11, 'Tablet', 30, 5),
(12, 'Charger', 90, 20),
(13, 'Headphones', 60, 10);

INSERT INTO ItemSales VALUES
(201, 11, 28, '2024-06-05'),
(202, 12, 75, '2024-06-06'),
(203, 13, 55, '2024-06-07');

INSERT INTO stock_notifications
SELECT 
  im.item_id,
  im.item_name,
  im.opening_stock - IFNULL(SUM(isl.sold_qty), 0) AS current_stock,
  CURDATE() AS notify_date
FROM ItemMaster im
LEFT JOIN ItemSales isl ON im.item_id = isl.item_id
GROUP BY im.item_id, im.item_name, im.opening_stock, im.reorder_level
HAVING current_stock < im.reorder_level;

SELECT * FROM stock_notifications;
