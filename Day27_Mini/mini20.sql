-- 20. Project Task Dependency Tracker

CREATE DATABASE WorkflowManagerDB;
USE WorkflowManagerDB;

CREATE TABLE WorkflowTasks (
  step_id INT PRIMARY KEY,
  step_name VARCHAR(100),
  prerequisite_step_id INT,
  FOREIGN KEY (prerequisite_step_id) REFERENCES WorkflowTasks(step_id)
);

CREATE TABLE WorkflowPath (
  step_id INT,
  step_name VARCHAR(100),
  prerequisite_step_id INT,
  step_level INT,
  execution_path VARCHAR(255)
);

INSERT INTO WorkflowTasks VALUES
(10, 'Setup Repository', NULL),
(11, 'Code Core Logic', 10),
(12, 'Connect Frontend', 11),
(13, 'Run QA Tests', 12),
(14, 'Launch App', 13);

WITH RECURSIVE StepFlow AS (
  SELECT 
    step_id,
    step_name,
    prerequisite_step_id,
    1 AS step_level,
    CAST(step_name AS CHAR(255)) AS execution_path
  FROM WorkflowTasks
  WHERE prerequisite_step_id IS NULL

  UNION ALL

  SELECT 
    wt.step_id,
    wt.step_name,
    wt.prerequisite_step_id,
    sf.step_level + 1,
    CONCAT(sf.execution_path, ' → ', wt.step_name)
  FROM WorkflowTasks wt
  JOIN StepFlow sf ON wt.prerequisite_step_id = sf.step_id
)
SELECT * FROM StepFlow;

INSERT INTO WorkflowPath
SELECT * FROM (
  WITH RECURSIVE StepFlow AS (
    SELECT 
      step_id,
      step_name,
      prerequisite_step_id,
      1 AS step_level,
      CAST(step_name AS CHAR(255)) AS execution_path
    FROM WorkflowTasks
    WHERE prerequisite_step_id IS NULL

    UNION ALL

    SELECT 
      wt.step_id,
      wt.step_name,
      wt.prerequisite_step_id,
      sf.step_level + 1,
      CONCAT(sf.execution_path, ' → ', wt.step_name)
    FROM WorkflowTasks wt
    JOIN StepFlow sf ON wt.prerequisite_step_id = sf.step_id
  )
  SELECT * FROM StepFlow
) AS InsertTree;

SELECT * FROM WorkflowPath;


