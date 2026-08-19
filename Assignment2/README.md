# Week 5 — Assignment 2: SQL Query Set

**CMIT Internship Program · Delivered by Coding Pixel**  
*Phase 3: Data & System Design (PostgreSQL & SQL)*

---

##  Overview

This repository contains the complete solution for **Week 5 — Assignment 2: Query Set**. 

The goal of this assignment is to write ten precise, production-grade SQL queries against the **Task Management** database domain (designed in Assignment 1). The queries demonstrate mastery over crucial relational database concepts:
- **Explicit NULL handling in ordering** (`NULLS LAST`)
- **Proper aggregations and groupings** (`GROUP BY`, `COUNT`, `AVG`)
- **Intentional joins** (`LEFT JOIN` vs `INNER JOIN`) to prevent silent row drops
- **Many-to-many relationship traversal** through junction tables
- **Anti-join patterns** to identify absences (`IS NULL`)

---

##  Database Schema Summary

The queries operate on the fixed 7-table Task Management schema:
- `users`: User profiles (`id`, `name`, `email`, `created_at`)
- `projects`: Projects created by users (`id`, `name`, `owner_id`, `created_at`)
- `project_members`: Project memberships and roles (`user_id`, `project_id`, `role`)
- `tasks`: Tasks within projects (`id`, `title`, `description`, `status`, `priority`, `project_id`, `assignee_id`, `due_date`, `created_at`)
- `tags`: Tag taxonomy (`id`, `name`)
- `task_tags`: Many-to-many join table for tasks and tags (`task_id`, `tag_id`)
- `comments`: Comments on tasks (`id`, `task_id`, `author_id`, `body`, `created_at`)

---

##  Getting Started & Execution

### 1. Prerequisites
Ensure PostgreSQL is running locally or inside Docker, and that `schema.sql` and `seed.sql` from Assignment 1 have been loaded into your database:

```bash
# Create database and seed schema + data
dropdb assignment1 --if-exists
createdb assignment1
psql -U postgres -d assignment1 -f path/to/assignment1/schema.sql -f path/to/assignment1/seed.sql
```

### 2. Running the Query Set
Execute all queries in [`queries.sql`](queries.sql):

```bash
psql -U postgres -d assignment1 -f queries.sql
```

---

##  Query Inventory & Details

| # | Code | Tier | Description | Key Concept / Technique |
|:---:|:---:|:---:|:---|:---|
| **Q1** | **W1** | Warm-Up | All tasks for one project ordered by `due_date` ASC | `ORDER BY due_date ASC NULLS LAST` |
| **Q2** | **W2** | Warm-Up | Total number of tasks per status | `GROUP BY status` with `COUNT(*)` |
| **Q3** | **C1** | Core | Every user with assigned task count | `LEFT JOIN` with `COUNT(tasks.id)` (preserves 0-task users) |
| **Q4** | **C2.a** | Core | All tasks carrying a specific tag name | M:N join (`tasks` ⭢ `task_tags` ⭢ `tags`) |
| **Q5** | **C2.b** | Core | All overdue unfinished tasks with assignee | `due_date < CURRENT_DATE` & `status <> 'done'` + `LEFT JOIN users` |
| **Q6** | **C3.a** | Core | Top 3 users by completed (`done`) tasks | Filter `WHERE status = 'done'`, aggregate, `ORDER BY done_count DESC LIMIT 3` |
| **Q7** | **C3.b** | Core | Projects that have no tasks | Anti-join via `LEFT JOIN tasks ... WHERE tasks.id IS NULL` |
| **Q8** | **C4.a** | Core | Average number of tags per task | Subquery with `LEFT JOIN` & `AVG(tag_count)` (0-tag tasks included) |
| **Q9** | **C4.b** | Core | Comments per task, highest first | `LEFT JOIN comments` with `ORDER BY comment_count DESC` |
| **Q10**| **C4.c** | Core | Every project with its members and roles | `LEFT JOIN project_members` & `LEFT JOIN users` (preserves 0-member projects) |

---

##  Key Design & Correctness Decisions

1. **The `LEFT JOIN` Lesson (Q3, Q8, Q9, Q10)**:
   - Queries asking for "every user", "every task", or "every project" utilize `LEFT JOIN` rather than `INNER JOIN` so records with zero children are not silently eliminated from results or denominator averages.
2. **`COUNT(column)` vs `COUNT(*)` (Q3, Q8, Q9)**:
   - When aggregating across a `LEFT JOIN`, `COUNT(child_table.id)` evaluates to `0` for rows with no child records, whereas `COUNT(*)` would incorrectly return `1`.
3. **Explicit NULL Ordering (Q1)**:
   - PostgreSQL places `NULL` values first when sorting `DESC` and last when sorting `ASC` by default. Using explicit `NULLS LAST` ensures consistent and intended UI behavior across all queries.
4. **Anti-Joins for Absences (Q7)**:
   - Finding absence (projects with no tasks) is cleanly performed using a `LEFT JOIN ... WHERE tasks.id IS NULL` anti-join pattern.

---

##  File Structure

```text
Assignment2/
├── queries.sql      # Complete set of 10 SQL queries with comments
└── README.md        # Assignment documentation and breakdown
```
