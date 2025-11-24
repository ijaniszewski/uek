# UEK SQL Analysis - University Database

SQL Server database with university data for SQL learning and exercises.

## Quick Start

**Start the database:**
```bash
docker compose up -d
```

**Access Adminer (web interface):** http://localhost:8083
- System: `MS SQL (beta)`
- Server: `sqlserver`
- Username: `sa`
- Password: `YourStrong@Passw0rd`
- Database: `university`

**Stop the database:**
```bash
docker compose down
```

## Database Contents

- **35 students** across multiple groups
- **42 employees** (professors, lecturers)
- **26 modules** with prerequisites
- **Grades, enrollments, tuition fees**

### Main Tables
- `students`, `employees`, `lecturers`
- `modules`, `students_modules`
- `student_grades`, `grades`
- `departments`, `groups`, `acad_positions`
- `tuition_fees`

## SQL Exercises

Open `exercises_notebooks/sql-exercises.ipynb` for practice tasks or use Adminer web interface to run queries.
For personal scratch work, copy the notebook as `local_<name>.ipynb` inside the same folder (these files are ignored by git).

## Reset Database

To start fresh (deletes all data):
```bash
docker compose down -v && docker compose up -d
```
