ALTER TABLE tasks
ADD CONSTRAINT tasks_status_check
CHECK (status IN ('todo', 'in_progress', 'done'));

ALTER TABLE tasks
ADD CONSTRAINT tasks_priority_check
CHECK (priority BETWEEN 1 AND 5);

ALTER TABLE project_members
ADD CONSTRAINT project_members_role_check
CHECK (role IN ('owner', 'admin', 'member', 'viewer'));

ALTER TABLE users
ADD CONSTRAINT users_email_unique
UNIQUE (email);

ALTER TABLE tags
ADD CONSTRAINT tags_name_unique
UNIQUE (name);


-- ------------------------------------------------------------------
-- Verification / Test Queries
-- ------------------------------------------------------------------

-- Valid Inserts:
INSERT INTO users (name, email) VALUES ('Ali', 'ali@test.com');
INSERT INTO projects (name, owner_id) VALUES ('Project 1', 1);
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 1, 'member');
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'todo', 3, 1);
INSERT INTO tags (name) VALUES ('javascript');

-- Invalid Inserts (Commented out because they intentionally fail):
-- -- Invalid status (fails tasks_status_check):
-- INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'blocked', 3, 1);
-- -- Invalid priority (fails tasks_priority_check):
-- INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'todo', 9, 1);
-- -- Invalid role (fails project_members_role_check):
-- INSERT INTO project_members (user_id, project_id, role) VALUES (1, 1, 'boss');
-- -- Duplicate email (fails users_email_unique):
-- INSERT INTO users (name, email) VALUES ('Ahmed', 'ali@test.com');
-- -- Duplicate tag (fails tags_name_unique):
-- INSERT INTO tags (name) VALUES ('javascript');