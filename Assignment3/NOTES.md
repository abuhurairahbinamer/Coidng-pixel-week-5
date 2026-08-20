## W1
## Index on tasks.project_id

The index on `tasks.project_id` helps queries that search or join tasks by project, such as Q1 in Assingment2, which retrieves all tasks for one project.

It can reduce the amount of data PostgreSQL needs to scan when finding tasks for a specific `project_id`.



# W2

## idx_tasks_status
Helps queries that filter tasks by status, such as Q5 and Q6 in Assignment2.

## idx_tasks_assignee_id
Helps queries that join users with their assigned tasks using `assignee_id`, such as Q3 in Assignment2.

## idx_tasks_due_date

This index can help Q5 in Assignment2 because the query filters tasks using
`due_date < CURRENT_DATE`.

It may also help queries that order or search tasks by due date.