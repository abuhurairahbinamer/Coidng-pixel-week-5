ALTER TABLE project_members
ADD CONSTRAINT project_members_pkey
PRIMARY KEY (user_id, project_id);

ALTER TABLE task_tags
ADD CONSTRAINT task_tags_pkey
PRIMARY KEY (task_id, tag_id);


--check
INSERT INTO projects (name, owner_id)
VALUES ('Project 1', 1);

INSERT INTO project_members (user_id, project_id, role)
VALUES (1, 3, 'member');

INSERT INTO project_members (user_id, project_id, role)
VALUES (1, 2, 'member');

-- should not work
INSERT INTO project_members (user_id, project_id, role)
VALUES (1, 3, 'member');


-- Create a task
INSERT INTO tasks (title, status, priority, project_id)
VALUES ('Task for C2', 'todo', 3, 3);

-- Create two tags
INSERT INTO tags (name)
VALUES ('C2-tag-1'), ('C2-tag-2');


-- Should  work
INSERT INTO task_tags (task_id, tag_id)
VALUES (4, 1);

-- Should  work
INSERT INTO task_tags (task_id, tag_id)
VALUES (4, 2);

-- should not work
INSERT INTO task_tags (task_id, tag_id)
VALUES (4, 1);