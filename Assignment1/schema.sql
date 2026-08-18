-- w1 task
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT NOT NULL,
    created_at TIMESTAMP
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id INTEGER NOT NULL,
    created_at TIMESTAMP
);

CREATE TABLE project_members (
    user_id INTEGER,
    project_id INTEGER,
    role TEXT NOT NULL
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT,
    priority INTEGER,
    project_id INTEGER NOT NULL,
    assignee_id INTEGER,
    due_date DATE,
    created_at TIMESTAMP
);

CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE task_tags (
    task_id INTEGER,
    tag_id INTEGER
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    task_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    created_at TIMESTAMP
);


--w2 task

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
--for status
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