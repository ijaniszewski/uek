-- ============================================================================
-- UNIVERSITY DATABASE INITIALIZATION - MODULES (COURSES)
-- ============================================================================
-- This script creates course modules for different departments
-- Includes prerequisites and proper course progression
-- 
-- Execution order: 04 (fourth script to run)
-- Dependencies: 01-init.sql, 02-reference-data.sql, 03-employees-lecturers.sql
-- ============================================================================

USE uek_analysis;

-- ============================================================================
-- 1. COMPUTER SCIENCE MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- First Year CS Modules
('Introduction to Programming', 60, 4, NULL, 1),
('Mathematics for Computer Science I', 45, 6, NULL, 1),
('Computer Systems Fundamentals', 30, 5, NULL, 1),
('Logic and Discrete Mathematics', 45, 7, NULL, 1),

-- Second Year CS Modules (with prerequisites)
('Object-Oriented Programming', 60, 2, 1, 1),     -- requires Intro to Programming
('Data Structures and Algorithms', 60, 1, 1, 1),  -- requires Intro to Programming
('Mathematics for Computer Science II', 45, 6, 2, 1), -- requires Math I
('Database Systems', 45, 3, 5, 1),                -- requires OOP
('Computer Networks', 45, 4, 3, 1),               -- requires Computer Systems

-- Third Year CS Modules
('Software Engineering', 60, 2, 5, 1),            -- requires OOP
('Machine Learning', 45, 1, 6, 1),                -- requires Data Structures
('Web Development', 45, 5, 8, 1),                 -- requires Database Systems
('Computer Graphics', 45, 3, 6, 1),               -- requires Data Structures
('Artificial Intelligence', 60, 24, 11, 1);       -- requires Machine Learning (Visiting Prof)

-- ============================================================================
-- 2. MATHEMATICS MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Mathematics Department Modules
('Calculus I', 60, 6, NULL, 2),
('Linear Algebra', 45, 7, NULL, 2),
('Calculus II', 60, 6, 15, 2),                    -- requires Calculus I
('Probability and Statistics', 45, 8, 15, 2),     -- requires Calculus I
('Differential Equations', 45, 7, 17, 2),         -- requires Calculus II
('Abstract Algebra', 45, 6, 16, 2),               -- requires Linear Algebra
('Numerical Methods', 45, 25, 17, 2);             -- requires Calculus II (Visiting Prof)

-- ============================================================================
-- 3. ECONOMICS MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Economics Department Modules
('Microeconomics I', 45, 10, NULL, 3),
('Macroeconomics I', 45, 11, NULL, 3),
('Statistics for Economics', 45, 18, NULL, 3),    -- Cross-department lecturer
('Microeconomics II', 45, 10, 22, 3),             -- requires Micro I
('Macroeconomics II', 45, 11, 23, 3),             -- requires Macro I
('Econometrics', 60, 12, 24, 3),                  -- requires Statistics
('International Economics', 45, 26, 25, 3),       -- requires Macro II (Visiting Prof)
('Economic History', 30, 12, NULL, 3);

-- ============================================================================
-- 4. BUSINESS ADMINISTRATION MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Business Administration Modules
('Principles of Management', 45, 19, NULL, 4),
('Business Law', 30, 13, NULL, 4),
('Organizational Behavior', 45, 20, 29, 4),       -- requires Principles of Management
('Strategic Management', 45, 19, 31, 4),          -- requires Organizational Behavior
('Operations Management', 45, 21, 29, 4),         -- requires Principles of Management (Cross-dept)
('International Business', 45, 27, 32, 4),        -- requires Strategic Management (Visiting Prof)
('Business Ethics', 30, 14, NULL, 4);

-- ============================================================================
-- 5. FINANCE MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Finance Department Modules
('Corporate Finance', 45, 16, NULL, 5),
('Investment Analysis', 45, 17, 36, 5),           -- requires Corporate Finance
('Financial Markets', 45, 16, NULL, 5),
('Risk Management', 45, 17, 37, 5),               -- requires Investment Analysis
('International Finance', 45, 18, 38, 5);         -- requires Financial Markets (Cross-dept)

-- ============================================================================
-- 6. MANAGEMENT MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Management Department Modules
('Human Resource Management', 45, 20, NULL, 6),
('Project Management', 45, 19, NULL, 6),
('Leadership and Team Management', 30, 20, 41, 6), -- requires HRM
('Change Management', 30, 19, 43, 6);             -- requires Leadership

-- ============================================================================
-- 7. MARKETING MODULES
-- ============================================================================
INSERT INTO modules (module_name, no_of_hours, lecturer_id, preceding_module_id, department_id) VALUES
-- Marketing Department Modules
('Marketing Fundamentals', 45, 22, NULL, 8),
('Consumer Behavior', 45, 23, 45, 8),             -- requires Marketing Fundamentals
('Digital Marketing', 45, 22, 45, 8),             -- requires Marketing Fundamentals
('Market Research', 45, 23, 46, 8),               -- requires Consumer Behavior
('Brand Management', 30, 22, 47, 8);              -- requires Digital Marketing

-- ============================================================================
-- END OF MODULES SCRIPT
-- ============================================================================