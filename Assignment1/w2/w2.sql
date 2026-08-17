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



-- -- valid checks
-- for status
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'todo', 3, 1);
-- for priority
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'todo', 3, 1);
-- for role
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 1, 'member');
-- for email
INSERT INTO users (name, email) VALUES ('Ali', 'ali@test.com');




-- -- invalid checks
-- for status
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'blocked', 3, 1);
--  for priority
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Test task', 'todo', 9, 1);
-- for role
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 1, 'boss');
-- for email
INSERT INTO users (name, email) VALUES ('Ahmed', 'ali@test.com');





-- -- -- check duplicate tag
INSERT INTO tags (name) VALUES ('javascript');
-- the second tag should be rejected
INSERT INTO tags (name) VALUES ('javascript');