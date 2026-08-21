-- -- W1
CREATE INDEX idx_tasks_project_id
ON tasks(project_id);


-- -- W2
CREATE INDEX idx_tasks_status
ON tasks(status);

CREATE INDEX idx_tasks_assignee_id
ON tasks(assignee_id);

CREATE INDEX idx_tasks_due_date
ON tasks(due_date);


-- C1
--check
--before operation 

SELECT * FROM tasks;
SELECT * FROM project_members;

BEGIN;

UPDATE tasks
SET assignee_id = 11
WHERE assignee_id = 10;

DELETE FROM project_members
WHERE user_id = 10  AND project_id = 10;

COMMIT;

--check
--after operation 

SELECT * FROM tasks;
SELECT * FROM project_members;




--C2

-- Count memberships before
SELECT COUNT(*) FROM project_members;

BEGIN;

UPDATE tasks
SET assignee_id = 11
WHERE assignee_id = 13;

DELETE FROM project_members
WHERE user_id = 13 AND project_id = 10;

ROLLBACK;

-- Count memberships after
SELECT COUNT(*) FROM project_members;


-- C3: EXPLAIN ANALYZE

-- ==========================================
-- Pair 1: Query 1 (Filter by project_id)
-- ==========================================

-- 1. Before Index (Run this first to observe plan without index)
DROP INDEX IF EXISTS idx_tasks_project_id;

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 10
ORDER BY due_date ASC NULLS LAST;

-- 2. After Index (Create index and run query again to observe plan change)
CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON tasks(project_id);

EXPLAIN ANALYZE
SELECT *
FROM tasks
WHERE project_id = 10
ORDER BY due_date ASC NULLS LAST;


-- ==========================================
-- Pair 2: Query 5 (Filter overdue tasks by due_date)
-- ==========================================

-- 1. Before Index (Run this first to observe plan without index)
DROP INDEX IF EXISTS idx_tasks_due_date;

EXPLAIN ANALYZE
SELECT tasks.*, users.name AS assignee_name
FROM tasks
LEFT JOIN users
    ON tasks.assignee_id = users.id
WHERE tasks.due_date < CURRENT_DATE
  AND tasks.status <> 'done';

-- 2. After Index (Create index and run query again to observe plan change)
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);

EXPLAIN ANALYZE
SELECT tasks.*, users.name AS assignee_name
FROM tasks
LEFT JOIN users
    ON tasks.assignee_id = users.id
WHERE tasks.due_date < CURRENT_DATE
  AND tasks.status <> 'done';

