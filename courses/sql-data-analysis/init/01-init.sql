-- ============================================================================
-- UNIVERSITY DATABASE INITIALIZATION - TABLE CREATION
-- ============================================================================
-- This script creates the core tables for the university database system
-- Based on the ERD provided for learning SQL analysis
-- 
-- Execution order: 01 (first script to run)
-- Dependencies: None
-- ============================================================================

-- Create the main database schema
USE uek_analysis;

-- ============================================================================
-- 1. DEPARTMENTS TABLE
-- ============================================================================
-- Stores information about university departments
-- This is a reference table that other entities depend on
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. GROUPS TABLE  
-- ============================================================================
-- Stores student group information (like class groups)
CREATE TABLE `groups` (
    group_no INT PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL,
    year_of_study INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 3. ACADEMIC POSITIONS TABLE
-- ============================================================================
-- Stores different academic positions (Professor, Associate Prof, etc.)
CREATE TABLE acad_positions (
    acad_position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name VARCHAR(50) NOT NULL UNIQUE,
    overtime_rate DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 4. EMPLOYEES TABLE
-- ============================================================================
-- Stores information about university employees (lecturers, professors, etc.)
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    employment_date DATE NOT NULL,
    pesel VARCHAR(11) UNIQUE NOT NULL, -- Polish national ID
    acad_position_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (acad_position_id) REFERENCES acad_positions(acad_position_id)
);

-- ============================================================================
-- 5. STUDENTS TABLE
-- ============================================================================
-- Stores student information
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    surname VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    group_no INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (group_no) REFERENCES `groups`(group_no)
);

-- ============================================================================
-- 6. LECTURERS TABLE
-- ============================================================================
-- Links employees to departments (an employee can lecture in multiple departments)
CREATE TABLE lecturers (
    lecturer_id INT,
    employee_id INT,
    department_id INT,
    PRIMARY KEY (lecturer_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ============================================================================
-- 7. MODULES TABLE
-- ============================================================================
-- Stores information about course modules/subjects
CREATE TABLE modules (
    module_id INT AUTO_INCREMENT PRIMARY KEY,
    module_name VARCHAR(100) NOT NULL,
    no_of_hours INT NOT NULL,
    lecturer_id INT,
    preceding_module_id INT, -- Self-referencing for prerequisites
    department_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id),
    FOREIGN KEY (preceding_module_id) REFERENCES modules(module_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ============================================================================
-- 8. GRADES TABLE
-- ============================================================================
-- Stores grade values (2.0, 3.0, 3.5, 4.0, 4.5, 5.0)
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    grade_value DECIMAL(2,1) NOT NULL UNIQUE,
    grade_description VARCHAR(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 9. STUDENTS_MODULES TABLE (Junction Table)
-- ============================================================================
-- Links students to modules they are enrolled in
-- Stores planned exam dates
CREATE TABLE students_modules (
    student_id INT,
    module_id INT,
    planned_exam_date DATE,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, module_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (module_id) REFERENCES modules(module_id)
);

-- ============================================================================
-- 10. STUDENT_GRADES TABLE
-- ============================================================================
-- Stores actual grades received by students for modules
CREATE TABLE student_grades (
    student_id INT,
    module_id INT,
    exam_date DATE NOT NULL,
    grade_id INT,
    attempt_number INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, module_id, exam_date),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (module_id) REFERENCES modules(module_id),
    FOREIGN KEY (grade_id) REFERENCES grades(grade_id)
);

-- ============================================================================
-- 11. TUITION_FEES TABLE
-- ============================================================================
-- Stores tuition fee payments made by students
CREATE TABLE tuition_fees (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    fee_amount DECIMAL(10,2) NOT NULL,
    date_of_payment DATE NOT NULL,
    payment_method VARCHAR(20) DEFAULT 'bank_transfer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- ============================================================================
-- INDEXES FOR BETTER PERFORMANCE
-- ============================================================================
-- Create indexes on frequently queried columns

-- Students table indexes
CREATE INDEX idx_students_surname ON students(surname);
CREATE INDEX idx_students_group ON students(group_no);

-- Modules table indexes  
CREATE INDEX idx_modules_name ON modules(module_name);
CREATE INDEX idx_modules_lecturer ON modules(lecturer_id);
CREATE INDEX idx_modules_department ON modules(department_id);

-- Student grades indexes
CREATE INDEX idx_student_grades_date ON student_grades(exam_date);
CREATE INDEX idx_student_grades_student ON student_grades(student_id);

-- Tuition fees indexes
CREATE INDEX idx_tuition_fees_student ON tuition_fees(student_id);
CREATE INDEX idx_tuition_fees_date ON tuition_fees(date_of_payment);

-- ============================================================================
-- END OF TABLE CREATION SCRIPT
-- ============================================================================