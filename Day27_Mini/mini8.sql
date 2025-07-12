-- 8. Sales Funnel Analysis

CREATE DATABASE FunnelAnalyticsDB;
USE FunnelAnalyticsDB;

CREATE TABLE FunnelStages (
  contact_id INT PRIMARY KEY,
  contact_name VARCHAR(100),
  funnel_stage VARCHAR(50)
);

INSERT INTO FunnelStages VALUES
(101, 'Deepa Rao', 'Lead'),
(102, 'Manoj Iyer', 'Converted'),
(103, 'Sunita Jain', 'Repeat'),
(104, 'Ajay Malhotra', 'Lead'),
(105, 'Meena Das', 'Converted'),
(106, 'Rohit Sen', 'Repeat'),
(107, 'Geeta Kaur', 'Lead'),
(108, 'Karan Thakur', 'Converted'),
(109, 'Shruti Ghosh', 'Repeat'),
(110, 'Arun Mishra', 'Lead');

WITH StageGroup AS (
  SELECT funnel_stage, COUNT(*) AS total_stage
  FROM FunnelStages
  GROUP BY funnel_stage
),
AllContacts AS (
  SELECT COUNT(*) AS total FROM FunnelStages
)
SELECT 
  sg.funnel_stage,
  sg.total_stage,
  ROUND((sg.total_stage / ac.total) * 100, 2) AS stage_percentage
FROM StageGroup sg, AllContacts ac;

WITH FunnelCTE AS (
  SELECT 
    funnel_stage,
    COUNT(*) AS stage_volume
  FROM FunnelStages
  GROUP BY funnel_stage
)
SELECT * FROM FunnelCTE
ORDER BY FIELD(funnel_stage, 'Lead', 'Converted', 'Repeat');
