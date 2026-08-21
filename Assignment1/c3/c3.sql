-- ==================================================================
-- Assignment 1 - Task C3: Seed Data (seed.sql)
-- ==================================================================

-- ------------------------------------------------------------------
-- 1. USERS (7 users: meets minimum 6)

-- Special Case: User ID 16 ('George Clark') has 0 assigned tasks.
-- ------------------------------------------------------------------
INSERT INTO users (id, name, email) VALUES
(10, 'Alice Smith', 'alice.smith@example.com'),
(11, 'Bob Jones', 'bob.jones@example.com'),
(12, 'Charlie Brown', 'charlie.brown@example.com'),
(13, 'Diana Prince', 'diana.prince@example.com'),
(14, 'Evan Wright', 'evan.wright@example.com'),
(15, 'Fiona Gallagher', 'fiona.gallagher@example.com'),
(16, 'George Clark', 'george.clark@example.com');


-- ------------------------------------------------------------------
-- 2. PROJECTS (4 projects: meets minimum 3)

-- Special Case: Project ID 13 ('Delta Empty Project') has 0 tasks.
-- ------------------------------------------------------------------
INSERT INTO projects (id, name, owner_id) VALUES
(10, 'Alpha Platform', 10),
(11, 'Beta Mobile App', 11),
(12, 'Gamma Analytics', 12),
(13, 'Delta Empty Project', 13);


-- ------------------------------------------------------------------
-- 3. PROJECT MEMBERS (9 memberships: meets minimum 6)
-- Mix of roles: 'owner', 'admin', 'member', 'viewer'
-- ------------------------------------------------------------------
INSERT INTO project_members (user_id, project_id, role) VALUES
(10, 10, 'owner'),
(11, 10, 'admin'),
(12, 10, 'member'),
(13, 10, 'viewer'),
(11, 11, 'owner'),
(14, 11, 'member'),
(15, 11, 'admin'),
(12, 12, 'owner'),
(13, 13, 'owner');


-- ------------------------------------------------------------------
-- 4. TAGS (7 tags: meets minimum 6)

-- ------------------------------------------------------------------
INSERT INTO tags (id, name) VALUES
(10, 'frontend'),
(11, 'backend'),
(12, 'bug'),
(13, 'feature'),
(14, 'urgent'),
(15, 'database'),
(16, 'devops');


-- ------------------------------------------------------------------
-- 5. TASKS (16 tasks: meets minimum 15)

-- Special Cases:
--   - Task 17 & 22: Unassigned (assignee_id IS NULL)
--   - Task 15, 16 & 21: Overdue non-done (due_date in past, status <> 'done')
--   - Task 17 & 23: NULL due_date
--   - Top 3 leaderboard for done tasks: Alice (3), Bob (2), Charlie (1)
-- ------------------------------------------------------------------
INSERT INTO tasks (id, title, description, status, priority, project_id, assignee_id, due_date) VALUES
-- Alpha Platform (Project 10) Tasks:
(10, 'Setup database schema', 'Design PostgreSQL schema with constraints', 'done', 5, 10, 10, CURRENT_DATE - INTERVAL '10 days'),
(11, 'Build authentication flow', 'Implement JWT authentication and signup', 'done', 4, 10, 10, CURRENT_DATE - INTERVAL '8 days'),
(12, 'Write API documentation', 'Generate OpenAPI Swagger documentation', 'done', 3, 10, 10, CURRENT_DATE - INTERVAL '4 days'),
(13, 'Configure CI/CD pipeline', 'Setup GitHub Actions automated testing', 'done', 4, 10, 11, CURRENT_DATE - INTERVAL '7 days'),
(14, 'Implement caching layer', 'Integrate Redis caching for hot endpoints', 'done', 3, 10, 11, CURRENT_DATE - INTERVAL '2 days'),
(15, 'Fix memory leak in websocket', 'Investigate disconnects during high traffic', 'in_progress', 5, 10, 13, CURRENT_DATE - INTERVAL '3 days'), -- Overdue
(16, 'Optimize heavy search queries', 'Add composite indexes on tasks table', 'todo', 4, 10, 13, CURRENT_DATE - INTERVAL '5 days'), -- Overdue
(17, 'Create onboarding walkthrough', 'Interactive UI tutorial for new team members', 'todo', 2, 10, NULL, NULL), -- Unassigned & NULL due date
(18, 'Design settings page', 'Dark mode toggle and notification preferences', 'in_progress', 3, 10, 12, CURRENT_DATE + INTERVAL '5 days'),
(19, 'Implement push notifications', 'Setup FCM for iOS and Android devices', 'done', 4, 10, 12, CURRENT_DATE - INTERVAL '6 days'),

-- Beta Mobile App (Project 11) Tasks:
(20, 'Redesign profile screen', 'Modernize layout and add avatar cropper', 'in_progress', 2, 11, 14, CURRENT_DATE + INTERVAL '3 days'),
(21, 'Fix Bluetooth sync bug', 'Resolve connection drops in background mode', 'todo', 5, 11, 14, CURRENT_DATE - INTERVAL '2 days'), -- Overdue
(22, 'Add biometrics login', 'FaceID and fingerprint biometric authentication', 'todo', 3, 11, NULL, CURRENT_DATE + INTERVAL '10 days'), -- Unassigned
(23, 'Refactor state management', 'Migrate state management to lightweight store', 'in_progress', 3, 11, 15, NULL), -- NULL due date

-- Gamma Analytics (Project 12) Tasks:
(24, 'Build export to CSV feature', 'Stream large dataset exports without timeout', 'done', 4, 12, 12, CURRENT_DATE - INTERVAL '1 day'),
(25, 'Setup Prometheus metrics', 'Export application latency and error rates', 'todo', 3, 12, 12, CURRENT_DATE + INTERVAL '7 days');


-- ------------------------------------------------------------------
-- 6. TASK TAGS (24 associations: meets minimum 20)
-- ------------------------------------------------------------------
INSERT INTO task_tags (task_id, tag_id) VALUES
-- Task 10: database (15), backend (11)
(10, 15),
(10, 11),

-- Task 11: backend (11), feature (13), urgent (14)
(11, 11),
(11, 13),
(11, 14),

-- Task 12: backend (11), feature (13)
(12, 11),
(12, 13),

-- Task 13: devops (16), backend (11)
(13, 16),
(13, 11),

-- Task 14: backend (11), database (15), urgent (14)
(14, 11),
(14, 15),
(14, 14),

-- Task 15: bug (12), urgent (14), backend (11)
(15, 12),
(15, 14),
(15, 11),

-- Task 16: database (15), backend (11), urgent (14)
(16, 15),
(16, 11),
(16, 14),

-- Task 18: frontend (10), feature (13)
(18, 10),
(18, 13),

-- Task 19: frontend (10), feature (13)
(19, 10),
(19, 13),

-- Task 20: frontend (10)
(20, 10),

-- Task 21: bug (12), urgent (14)
(21, 12),
(21, 14),

-- Task 22: feature (13)
(22, 13),

-- Task 23: frontend (10)
(23, 10),

-- Task 25: devops (16), backend (11)
(25, 16),
(25, 11);


-- ------------------------------------------------------------------
-- 7. COMMENTS (12 comments: meets minimum 10)

-- ------------------------------------------------------------------
INSERT INTO comments (id, task_id, author_id, body) VALUES
(10, 15, 10, 'Heap profiling shows retained connections in socket pool.'),
(11, 15, 13, 'Testing patch on staging environment now.'),
(12, 15, 11, 'Looks stable after running load test for 1 hour.'),
(13, 16, 10, 'Query plan showed a sequential scan on project_id column.'),
(14, 16, 13, 'Adding btree index reduced execution time by 80%.'),
(15, 10, 11, 'Initial migrations verified against PostgreSQL 15.'),
(16, 10, 12, 'All foreign key cascaded rules tested successfully.'),
(17, 21, 14, 'Bug reproduced on Android 13 devices.'),
(18, 21, 15, 'Background service permission was being revoked by OS.'),
(19, 11, 12, 'Token refresh rotation working smoothly.'),
(20, 13, 15, 'Docker caching step added to workflow.'),
(21, 18, 10, 'Figma mockups approved by product lead.');



SELECT count(*) FROM users;

SELECT count(*) FROM projects;

SELECT count(*) FROM project_members;

SELECT count(*) FROM tags;

SELECT count(*) FROM tasks;

SELECT count(*) FROM task_tags;

SELECT count(*) FROM comments;
-- 1. Unassigned tasks
SELECT count(*) AS unassigned_tasks FROM tasks WHERE assignee_id IS NULL;

-- 2. Overdue non-done tasks
SELECT count(*) AS overdue_tasks FROM tasks WHERE due_date < CURRENT_DATE AND status <> 'done';

-- 3. Projects with 0 tasks
SELECT p.id, p.name FROM projects p LEFT JOIN tasks t ON t.project_id = p.id WHERE t.id IS NULL;

-- 4. Users with 0 tasks
SELECT u.id, u.name FROM users u LEFT JOIN tasks t ON t.assignee_id = u.id WHERE t.id IS NULL;