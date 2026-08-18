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




--check
INSERT INTO users (name, email)
VALUES
('Ali', 'ali1@test.com'),
('Ahmed', 'ahmed1@test.com');

INSERT INTO projects (name, owner_id)
VALUES
('Project 1', 1),
('Project 2', 2);


INSERT INTO project_members (user_id, project_id, role)
VALUES
(1, 1, 'owner'),
(2, 2, 'owner');


INSERT INTO tasks (title, status, priority, project_id)
VALUES
('Task 1', 'todo', 3, 1),
('Task 2', 'in_progress', 4, 1),
('Task 3', 'done', 5, 2);

--check data before deleting

SELECT * FROM projects;

SELECT * FROM project_members;

SELECT id, title, project_id FROM tasks;

DELETE FROM projects
WHERE id = 1;

-- check after delete

SELECT * FROM projects;

SELECT * FROM tasks;

SELECT * FROM project_members;