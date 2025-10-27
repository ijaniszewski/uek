# UEK SQL Analysis - University Database

A complete university database system with MySQL and Adminer for SQL learning and analysis.

## Quick Start

NOTE: Please check different ports - MySQL runs on port **3308** and Adminer on port **8083** (not default ports).

### 1. Start the Database
```bash
docker compose up -d
```

### 2. Access Adminer (Web Interface)
- **URL:** http://localhost:8083
- **Server:** `mysql_db-uek`
- **Username:** `user`
- **Password:** `userpassword`
- **Database:** `uek_analysis`

### 3. Connect to MySQL

#### Option A: Through Docker Container (No MySQL installation needed)
```bash
docker exec -it mysql_db-uek mysql -u user -p uek_analysis
# Password: userpassword
```

#### Option B: Local MySQL Client
```bash
mysql -h localhost -P 3308 -u user -p uek_analysis
# Password: userpassword
```

### 4. Stop the Database
```bash
docker compose down
```

---

## Database Architecture & Learning Guide

### Services
- **MySQL 8.0** - Database server (port 3308)
- **Adminer** - Web-based database management (port 8083)

### University Database Schema

This database models a complete university system with realistic relationships and data.

### Core Tables:
- **`departments`** - University departments (Computer Science, Mathematics, Economics, etc.)
- **`groups`** - Student groups/classes with year information
- **`acad_positions`** - Academic positions (Professor, Lecturer, etc.) with overtime rates
- **`employees`** - University staff members with personal and employment details
- **`students`** - Student records with personal information and group assignments
- **`lecturers`** - Junction table linking employees to departments
- **`modules`** - Course modules with prerequisites and department assignments
- **`grades`** - Grade values (Polish system: 2.0-5.0)

### Relationship Tables:
- **`students_modules`** - Student enrollments in modules with planned exam dates
- **`student_grades`** - Actual grades received by students with exam dates and attempt numbers
- **`tuition_fees`** - Tuition fee payments made by students

### Learning Features:
- ✅ **Complex Relationships** - Foreign keys, junction tables, self-referencing prerequisites
- ✅ **Realistic Scenarios** - Failed exams, retakes, partial payments, cross-department teaching
- ✅ **Rich Dataset** - 50+ students, 22 employees, 49 modules, hundreds of grades and payments
- ✅ **Pre-built Views** - Student performance, enrollment statistics, financial summaries
- ✅ **Learning Examples** - Ready-to-use SQL queries from basic to advanced

### Data Overview:
- **7 Departments** - Computer Science, Mathematics, Economics, Business, Finance, Management, Marketing
- **50+ Students** - Across 3 years and different programs
- **22 Employees** - Professors, lecturers, and teaching assistants
- **49 Course Modules** - With realistic prerequisites and hour requirements
- **Multiple Grade Records** - Including failures and retakes for learning scenarios

### Database Initialization Scripts:
The database is built using 6 sequential SQL scripts:
1. **`01-init.sql`** - Table structures and indexes
2. **`02-reference-data.sql`** - Lookup tables (departments, positions, grades, groups)
3. **`03-employees-lecturers.sql`** - Academic staff and assignments
4. **`04-modules.sql`** - Course modules with prerequisites
5. **`05-students-enrollments.sql`** - Student records and enrollments
6. **`06-grades-tuition.sql`** - Grades, payments, and analysis views

## 🎯 Example Queries for Learning

## Configuration

You can modify the database credentials and ports in the `.env` file:

- `MYSQL_ROOT_PASSWORD`: Root user password
- `MYSQL_DATABASE`: Default database name
- `MYSQL_USER`: Regular user username
- `MYSQL_PASSWORD`: Regular user password
- `MYSQL_PORT`: MySQL port (default: 3306)
- `ADMINER_PORT`: Adminer web interface port (default: 8080)

## Data Persistence

Database data is persisted in a Docker volume named `mysql_data`. Your data will be preserved even when containers are stopped and restarted.

## Adding Custom SQL Scripts

Place any `.sql` files in the `init/` directory to have them executed when the MySQL container starts for the first time. Files are executed in alphabetical order.

## Example Queries for Learning

Once the database is set up, try these SQL queries to explore the data:

### Basic Queries:
```sql
-- View all students and their groups
SELECT s.first_name, s.surname, g.group_name, g.year_of_study 
FROM students s 
JOIN `groups` g ON s.group_no = g.group_no;

-- Find all Computer Science modules
SELECT m.module_name, m.no_of_hours, d.department_name
FROM modules m
JOIN departments d ON m.department_id = d.department_id
WHERE d.department_name = 'Computer Science';
```

### Intermediate Queries:
```sql
-- Student grades with module information
SELECT s.first_name, s.surname, m.module_name, gr.grade_value, sg.exam_date
FROM students s
JOIN student_grades sg ON s.student_id = sg.student_id
JOIN modules m ON sg.module_id = m.module_id
JOIN grades gr ON sg.grade_id = gr.grade_id
ORDER BY s.surname, sg.exam_date;

-- Modules with prerequisites
SELECT m1.module_name as module, m2.module_name as prerequisite
FROM modules m1
LEFT JOIN modules m2 ON m1.preceding_module_id = m2.module_id
WHERE m1.preceding_module_id IS NOT NULL;
```

### Advanced Queries:
```sql
-- Top performing students by average grade
SELECT s.first_name, s.surname, g.group_name, 
       ROUND(AVG(gr.grade_value), 2) as avg_grade,
       COUNT(sg.grade_id) as exams_taken
FROM students s
JOIN `groups` g ON s.group_no = g.group_no
JOIN student_grades sg ON s.student_id = sg.student_id
JOIN grades gr ON sg.grade_id = gr.grade_id
GROUP BY s.student_id
HAVING COUNT(sg.grade_id) >= 3
ORDER BY avg_grade DESC;

-- Department financial summary
SELECT d.department_name,
       COUNT(DISTINCT s.student_id) as total_students,
       SUM(tf.fee_amount) as total_revenue
FROM departments d
JOIN modules m ON d.department_id = m.department_id
JOIN students_modules sm ON m.module_id = sm.module_id
JOIN students s ON sm.student_id = s.student_id
JOIN tuition_fees tf ON s.student_id = tf.student_id
GROUP BY d.department_id, d.department_name
ORDER BY total_revenue DESC;
```

### Using Pre-built Views:
```sql
-- Student performance overview
SELECT * FROM student_performance WHERE average_grade >= 4.0;

-- Module popularity and difficulty
SELECT * FROM module_enrollment ORDER BY enrolled_students DESC;

-- Payment status by student
SELECT * FROM student_financials WHERE total_paid < 5000;
```

## 🔧 Advanced Usage

### Docker Commands
```bash
# View logs
docker compose logs mysql_db-uek

# Connect via MySQL CLI
docker exec -it mysql_db-uek mysql -u user -p uek_analysis

# Reset database (WARNING: Deletes all data)
docker compose down -v && docker compose up -d
```

### Configuration
Modify ports and credentials in `.env` file:
- `MYSQL_PORT` - MySQL port (default: 3308)
- `ADMINER_PORT` - Adminer port (default: 8083)
- Database credentials can be customized

### Data Persistence
Database data persists in Docker volume `mysql_data_uek` - survives container restarts.