-- 16. Seasonal Demand Forecasting Prep

CREATE DATABASE DemandForecastDB;
USE DemandForecastDB;

CREATE TABLE MonthlySales (
  record_id INT PRIMARY KEY,
  item_id INT,
  item_name VARCHAR(100),
  month INT,
  year INT,
  units_sold INT
);

CREATE TABLE top_trending_items (
  item_id INT,
  item_name VARCHAR(100),
  units_diff INT,
  demand_trend VARCHAR(50)
);

INSERT INTO MonthlySales VALUES
(11, 201, 'Cooler', 3, 2024, 90),
(12, 201, 'Cooler', 4, 2024, 140),
(13, 201, 'Cooler', 5, 2024, 190),
(14, 202, 'Blanket', 3, 2024, 80),
(15, 202, 'Blanket', 4, 2024, 70),
(16, 202, 'Blanket', 5, 2024, 50),
(17, 203, 'Water Bottle', 3, 2024, 110),
(18, 203, 'Water Bottle', 4, 2024, 120),
(19, 203, 'Water Bottle', 5, 2024, 130);

WITH ChangeTracker AS (
  SELECT 
    item_id,
    item_name,
    month,
    units_sold,
    LAG(units_sold) OVER (
      PARTITION BY item_id 
      ORDER BY month
    ) AS prev_units
  FROM MonthlySales
),
VariationCalc AS (
  SELECT 
    item_id,
    item_name,
    (units_sold - IFNULL(prev_units, 0)) AS units_diff,
    CASE 
      WHEN units_sold - IFNULL(prev_units, 0) > 0 THEN 'Upward'
      WHEN units_sold - IFNULL(prev_units, 0) < 0 THEN 'Downward'
      ELSE 'No Change'
    END AS demand_trend
  FROM ChangeTracker
  WHERE prev_units IS NOT NULL
)
SELECT * FROM VariationCalc;

INSERT INTO top_trending_items
SELECT * FROM (
  WITH ChangeTracker AS (
    SELECT 
      item_id,
      item_name,
      month,
      units_sold,
      LAG(units_sold) OVER (
        PARTITION BY item_id 
        ORDER BY month
      ) AS prev_units
    FROM MonthlySales
  ),
  VariationCalc AS (
    SELECT 
      item_id,
      item_name,
      (units_sold - IFNULL(prev_units, 0)) AS units_diff,
      CASE 
        WHEN units_sold - IFNULL(prev_units, 0) > 0 THEN 'Upward'
        WHEN units_sold - IFNULL(prev_units, 0) < 0 THEN 'Downward'
        ELSE 'No Change'
      END AS demand_trend
    FROM ChangeTracker
    WHERE prev_units IS NOT NULL
  )
  SELECT * FROM VariationCalc
) AS SubResult;

SELECT * FROM top_trending_items;