-- ==================================================================
-- TASK W1: Table Creation (DDL)
-- ==================================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT,
    email TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    owner_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
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
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ==================================================================
-- TASK W2: Check & Unique Constraints
-- ==================================================================

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


-- ==================================================================
-- TASK C1: Foreign Key Constraints & Referential Actions (ON DELETE)
-- ==================================================================

ALTER TABLE projects
ADD CONSTRAINT projects_owner_fk
FOREIGN KEY (owner_id)
REFERENCES users(id)
ON DELETE RESTRICT;

ALTER TABLE project_members
ADD CONSTRAINT project_members_user_fk
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE project_members
ADD CONSTRAINT project_members_project_fk
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE;

ALTER TABLE tasks
ADD CONSTRAINT tasks_project_fk
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE;

ALTER TABLE tasks
ADD CONSTRAINT tasks_assignee_fk
FOREIGN KEY (assignee_id)
REFERENCES users(id)
ON DELETE SET NULL;

ALTER TABLE task_tags
ADD CONSTRAINT task_tags_task_fk
FOREIGN KEY (task_id)
REFERENCES tasks(id)
ON DELETE CASCADE;

ALTER TABLE task_tags
ADD CONSTRAINT task_tags_tag_fk
FOREIGN KEY (tag_id)
REFERENCES tags(id)
ON DELETE CASCADE;

ALTER TABLE comments
ADD CONSTRAINT comments_task_fk
FOREIGN KEY (task_id)
REFERENCES tasks(id)
ON DELETE CASCADE;

ALTER TABLE comments
ADD CONSTRAINT comments_author_fk
FOREIGN KEY (author_id)
REFERENCES users(id)
ON DELETE RESTRICT;


-- ==================================================================
-- TASK C2: Composite Primary Keys for Junction Tables
-- ==================================================================

ALTER TABLE project_members
ADD CONSTRAINT project_members_pkey
PRIMARY KEY (user_id, project_id);

ALTER TABLE task_tags
ADD CONSTRAINT task_tags_pkey
PRIMARY KEY (task_id, tag_id);


-- ==================================================================
-- VERIFICATION & TEST QUERIES
-- ==================================================================

-- ------------------------------------------------------------------
-- Task W2 Tests: Constraint Checks
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


-- ------------------------------------------------------------------
-- Task C1 Tests: Foreign Key & Cascade Delete Checks
-- ------------------------------------------------------------------

-- 1. Setup Test Data for C1 (Users 2 & 3, Projects 2 & 3):
INSERT INTO users (name, email) VALUES ('User 2', 'ali1@test.com'), ('User 3', 'ahmed1@test.com');
INSERT INTO projects (name, owner_id) VALUES ('Project 2', 2), ('Project 3', 3);
INSERT INTO project_members (user_id, project_id, role) VALUES (2, 2, 'owner'), (3, 3, 'owner');
INSERT INTO tasks (title, status, priority, project_id) VALUES 
    ('Task 1', 'todo', 3, 2), 
    ('Task 2', 'in_progress', 4, 2), 
    ('Task 3', 'done', 5, 3);

-- 2. Inspect Data Before Deletion:
SELECT * FROM projects;
SELECT * FROM project_members;
SELECT id, title, project_id FROM tasks;

-- 3. Perform Deletion (Deleting Project 2 cascades to its tasks and members):
DELETE FROM projects WHERE id = 2;

-- 4. Inspect Data After Deletion:
SELECT * FROM projects;
SELECT * FROM tasks;
SELECT * FROM project_members;


-- ------------------------------------------------------------------
-- Task C2 Tests: Composite Primary Key Checks
-- ------------------------------------------------------------------

-- 1. Valid Composite Key Inserts for project_members:
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 3, 'member');
INSERT INTO project_members (user_id, project_id, role) VALUES (2, 3, 'member');

-- Invalid Composite Key Insert (Duplicate (user_id=1, project_id=3) intentionally fails):
-- INSERT INTO project_members (user_id, project_id, role) VALUES (1, 3, 'member');

-- 2. Valid Composite Key Inserts for task_tags:
INSERT INTO tags (name) VALUES ('C2-tag-1'), ('C2-tag-2');
INSERT INTO task_tags (task_id, tag_id) VALUES (4, 2);
INSERT INTO task_tags (task_id, tag_id) VALUES (4, 3);

-- Invalid Composite Key Insert (Duplicate (task_id=4, tag_id=2) intentionally fails):
-- INSERT INTO task_tags (task_id, tag_id) VALUES (4, 2);

-- 3. Final verification of composite junction tables:
SELECT * FROM project_members;
SELECT * FROM task_tags;