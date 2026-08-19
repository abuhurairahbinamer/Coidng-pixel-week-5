-- before ruunig this,run schema.sql and seed.sql in assignment1
-- psql -U postgres -d assignment1 -f schema.sql -f seed.sql



-- W1-->Q1: Get all tasks for project 10, ordered by due date ascending with NULL due dates last
SELECT *
FROM tasks
WHERE project_id = 10
ORDER BY due_date ASC NULLS LAST;

-- W2-->Q2: Count the number of tasks in each status
SELECT status, COUNT(*)
FROM tasks
GROUP BY status;

-- C1-->Q3: Show every user with the number of tasks assigned to them
SELECT users.id, users.name, COUNT(tasks.id) AS task_count
FROM users
LEFT JOIN tasks
    ON tasks.assignee_id = users.id
GROUP BY users.id, users.name;

--C2
-- Q4: Find all tasks carrying the 'frontend' tag
SELECT tasks.*
FROM tasks
JOIN task_tags
    ON tasks.id = task_tags.task_id
JOIN tags
    ON task_tags.tag_id = tags.id
WHERE tags.name = 'frontend';

-- Q5: Find all overdue unfinished tasks with their assignee's name
SELECT tasks.*, users.name AS assignee_name
FROM tasks
LEFT JOIN users
    ON tasks.assignee_id = users.id
WHERE tasks.due_date < CURRENT_DATE
  AND tasks.status <> 'done';


--C3
-- Q6: Top 3 users by number of done tasks
SELECT users.id, users.name, COUNT(tasks.id) AS done_count
FROM users
INNER JOIN tasks
    ON tasks.assignee_id = users.id
WHERE tasks.status = 'done'
GROUP BY users.id, users.name
ORDER BY done_count DESC
LIMIT 3;


-- Q7: Find projects that have no tasks
SELECT projects.*
FROM projects
LEFT JOIN tasks
    ON tasks.project_id = projects.id
WHERE tasks.id IS NULL;

--C4
-- Q8: Average number of tags per task
SELECT AVG(tag_count)
FROM (
    SELECT tasks.id, COUNT(task_tags.tag_id) AS tag_count
    FROM tasks
    LEFT JOIN task_tags
        ON tasks.id = task_tags.task_id
    GROUP BY tasks.id
) AS task_tag_counts;


-- Q9: Number of comments for every task, highest first
SELECT tasks.id, tasks.title, COUNT(comments.id) AS comment_count
FROM tasks
LEFT JOIN comments
    ON comments.task_id = tasks.id
GROUP BY tasks.id, tasks.title
ORDER BY comment_count DESC;


-- Q10: Every project with its members and their roles
SELECT
    projects.id AS project_id,
    projects.name AS project_name,
    users.id AS user_id,
    users.name AS member_name,
    project_members.role
FROM projects
LEFT JOIN project_members
    ON project_members.project_id = projects.id
LEFT JOIN users
    ON project_members.user_id = users.id;