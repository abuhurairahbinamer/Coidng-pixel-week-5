ALTER TABLE project_members
ADD CONSTRAINT project_members_pkey
PRIMARY KEY (user_id, project_id);

ALTER TABLE task_tags
ADD CONSTRAINT task_tags_pkey
PRIMARY KEY (task_id, tag_id);


-- ------------------------------------------------------------------
-- Verification / Test Queries
-- ------------------------------------------------------------------

-- 1. Test Composite Key on project_members:
INSERT INTO projects (name, owner_id) VALUES ('Project 1', 1);

-- Valid inserts (unique pairs):
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 3, 'member');
INSERT INTO project_members (user_id, project_id, role) VALUES (1, 2, 'member');

-- Invalid insert (Duplicate (user_id=1, project_id=3) should fail):
-- INSERT INTO project_members (user_id, project_id, role) VALUES (1, 3, 'member');


-- 2. Test Composite Key on task_tags:
INSERT INTO tasks (title, status, priority, project_id) VALUES ('Task for C2', 'todo', 3, 3);
INSERT INTO tags (name) VALUES ('C2-tag-1'), ('C2-tag-2');

-- Valid inserts (unique pairs):
INSERT INTO task_tags (task_id, tag_id) VALUES (4, 1);
INSERT INTO task_tags (task_id, tag_id) VALUES (4, 2);

-- Invalid insert (Duplicate (task_id=4, tag_id=1) should fail):
-- INSERT INTO task_tags (task_id, tag_id) VALUES (4, 1);