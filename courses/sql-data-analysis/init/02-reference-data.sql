-- ============================================================================
-- UNIVERSITY DATABASE INITIALIZATION - REFERENCE DATA
-- ============================================================================
-- This script populates the reference tables with essential data
-- These are lookup tables that other entities depend on
-- 
-- Execution order: 02 (second script to run)
-- Dependencies: 01-init.sql (table structure must exist)
-- ============================================================================

USE uek_analysis;

-- ============================================================================
-- 1. POPULATE DEPARTMENTS
-- ============================================================================
-- Insert university departments
INSERT INTO departments (department_name) VALUES
('Computer Science'),
('Mathematics'),
('Economics'),
('Business Administration'),
('Finance and Accounting'),
('Management'),
('International Business'),
('Marketing'),
('Law'),
('Psychology');

-- ============================================================================
-- 2. POPULATE ACADEMIC POSITIONS
-- ============================================================================
-- Insert academic positions with overtime rates
INSERT INTO acad_positions (position_name, overtime_rate) VALUES
('Professor', 150.00),
('Associate Professor', 120.00),
('Assistant Professor', 100.00),
('Senior Lecturer', 80.00),
('Lecturer', 60.00),
('Teaching Assistant', 40.00),
('Visiting Professor', 130.00);

-- ============================================================================
-- 3. POPULATE GRADES
-- ============================================================================
-- Insert Polish university grading system
INSERT INTO grades (grade_value, grade_description) VALUES
(2.0, 'Insufficient (ndst)'),
(3.0, 'Sufficient (dst)'),
(3.5, 'Sufficient Plus (dst+)'),
(4.0, 'Good (db)'),
(4.5, 'Good Plus (db+)'),
(5.0, 'Very Good (bdb)');

-- ============================================================================
-- 4. POPULATE GROUPS
-- ============================================================================
-- Insert student groups for different years and programs
INSERT INTO `groups` (group_no, group_name, year_of_study) VALUES
(101, 'CS-1A', 1),
(102, 'CS-1B', 1),
(103, 'CS-1C', 1),
(201, 'CS-2A', 2),
(202, 'CS-2B', 2),
(301, 'CS-3A', 3),
(302, 'CS-3B', 3),
(111, 'ECON-1A', 1),
(112, 'ECON-1B', 1),
(211, 'ECON-2A', 2),
(212, 'ECON-2B', 2),
(311, 'ECON-3A', 3),
(121, 'BUS-1A', 1),
(122, 'BUS-1B', 1),
(221, 'BUS-2A', 2),
(321, 'BUS-3A', 3);

-- ============================================================================
-- END OF REFERENCE DATA SCRIPT
-- ============================================================================