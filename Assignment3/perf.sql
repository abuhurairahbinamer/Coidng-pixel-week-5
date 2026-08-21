-- -- W1
-- CREATE INDEX idx_tasks_project_id
-- ON tasks(project_id);


-- -- W2
-- CREATE INDEX idx_tasks_status
-- ON tasks(status);

-- CREATE INDEX idx_tasks_assignee_id
-- ON tasks(assignee_id);

-- CREATE INDEX idx_tasks_due_date
-- ON tasks(due_date);


-- C1
--check
--before operation 

-- SELECT * FROM tasks;
-- SELECT * FROM project_members;

-- BEGIN;

-- UPDATE tasks
-- SET assignee_id = 11
-- WHERE assignee_id = 10;

-- DELETE FROM project_members
-- WHERE user_id = 10  AND project_id = 10;

-- COMMIT;

--check
--after operation 

-- SELECT * FROM tasks;
-- SELECT * FROM project_members;




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