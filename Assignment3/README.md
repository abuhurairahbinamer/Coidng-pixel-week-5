# Week 5 — Assignment 3: Indexing, Transactions & Query Plans

This repository contains the deliverables for **Assignment 3** of the CMIT Full-Stack Internship Program (Week 5: PostgreSQL and SQL).

The focus of this assignment is database performance, data safety with transactions, and analyzing query execution plans using PostgreSQL's query optimizer.

---

## 📁 Repository Structure

```text
Assignment3/
├── perf.sql        # SQL script containing index creation, multi-statement transactions, and EXPLAIN ANALYZE queries
├── NOTES.md        # Detailed justifications for indexes, transaction rollback verification, and execution plan analyses
├── image-1.png     # Terminal screenshot demonstrating atomic rollback execution
└── README.md       # Project documentation and execution instructions
```

---

## 🎯 Assignment Objectives & Implementations

### **1. Warm-Up: Performance Indexing**
* **W1 (`idx_tasks_project_id`)**: Created a B-tree index on `tasks.project_id` to optimize project-scoped task searches and joins (e.g., Assignment 2 Q1).
* **W2 (Additional Indexes)**:
  * `idx_tasks_status`: Speeds up filtering by task workflow status (`status = 'done'`, etc.).
  * `idx_tasks_assignee_id`: Optimizes foreign key joins between `users` and assigned `tasks`.
  * `idx_tasks_due_date`: Accelerates overdue filtering (`due_date < CURRENT_DATE`) and date-ordered sorting.

### **2. Core: Multi-Statement Transactions**
* **C1 (Atomic Reassignment & Removal)**:
  * Wrapped inside `BEGIN ... COMMIT` to ensure that reassigning a departing member's tasks and deleting their `project_members` row happen together atomically.
* **C2 (Rollback & Atomicity Demonstration)**:
  * Demonstrated that executing modifications inside `BEGIN ... ROLLBACK` leaves table row counts identical before and after execution (`8` $\rightarrow$ `ROLLBACK` $\rightarrow$ `8`).

### **3. Core: Query Plan Analysis (`EXPLAIN ANALYZE`)**
* **C3 (Before vs. After Indexing Comparisons)**:
  * **Pair 1 (Q1 - Tasks by Project)**: Tested `SELECT * FROM tasks WHERE project_id = 10 ORDER BY due_date ASC NULLS LAST;` before and after `idx_tasks_project_id`.
  * **Pair 2 (Q5 - Overdue Tasks)**: Tested overdue task retrieval with assignee joins before and after `idx_tasks_due_date`.
  * **Key Insight**: Documented why PostgreSQL's cost-based optimizer chooses `Seq Scan` over index scans on small seed datasets (16 rows) due to page-level cache efficiency, and observed reductions in planning/execution times.

---

## 🚀 How to Run

### **Prerequisites**
Ensure PostgreSQL is running and the database schema and seed data are loaded from Assignment 1:
```bash
psql -U postgres -d assignment1 -f ../Assignment1/schema.sql -f ../Assignment1/seed.sql
```

### **Running `perf.sql`**
Execute the performance script directly via `psql`:
```bash
psql -U postgres -d assignment1 -f perf.sql
```

### **Interactive Terminal Verification**
You can also run individual sections directly in the `psql` interactive shell:
```sql
-- Check indexes created
\di

-- View query execution plan
EXPLAIN ANALYZE SELECT * FROM tasks WHERE project_id = 10 ORDER BY due_date ASC NULLS LAST;
```

---

## 📖 Detailed Notes
For complete index justifications, query plans, and before/after metrics, see **[NOTES.md](NOTES.md)**.
