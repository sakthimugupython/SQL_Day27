-- 19. Return and Refund Analytics

CREATE DATABASE RefundAnalysisDB;
USE RefundAnalysisDB;

CREATE TABLE Purchase (
  purchase_id INT PRIMARY KEY,
  item_id INT,
  item_name VARCHAR(100),
  item_type VARCHAR(50),
  purchase_date DATE,
  total_cost DECIMAL(10,2)
);

CREATE TABLE Refunds (
  refund_id INT PRIMARY KEY,
  purchase_id INT,
  refund_date DATE,
  refund_value DECIMAL(10,2),
  FOREIGN KEY (purchase_id) REFERENCES Purchase(purchase_id)
);

CREATE TABLE refund_summary (
  item_id INT,
  item_name VARCHAR(100),
  item_type VARCHAR(50),
  purchase_count INT,
  refund_count INT,
  total_refunded DECIMAL(10,2)
);

INSERT INTO Purchase VALUES
(11, 201, 'Tablet Z1', 'Electronics', '2024-06-01', 25000),
(12, 202, 'Sneakers Y2', 'Footwear', '2024-06-02', 6000),
(13, 203, 'Monitor X3', 'Electronics', '2024-06-03', 18000),
(14, 204, 'T-Shirt W4', 'Apparel', '2024-06-04', 1500),
(15, 205, 'Desktop V5', 'Electronics', '2024-06-05', 45000);

INSERT INTO Refunds VALUES
(101, 11, '2024-06-06', 25000),
(102, 13, '2024-06-07', 18000),
(103, 14, '2024-06-08', 1500);

INSERT INTO refund_summary
SELECT 
  p.item_id,
  p.item_name,
  p.item_type,
  COUNT(DISTINCT p.purchase_id) AS purchase_count,
  COUNT(DISTINCT r.refund_id) AS refund_count,
  SUM(IFNULL(r.refund_value, 0)) AS total_refunded
FROM Purchase p
LEFT JOIN Refunds r ON p.purchase_id = r.purchase_id
GROUP BY p.item_id, p.item_name, p.item_type;

SELECT * FROM refund_summary;
