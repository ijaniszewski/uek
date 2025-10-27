-- ============================================================================
-- UNIVERSITY DATABASE INITIALIZATION - GRADES AND TUITION FEES
-- ============================================================================
-- This script populates student grades and tuition fee payments
-- Creates realistic data for SQL analysis and learning
-- 
-- Execution order: 06 (final script to run)
-- Dependencies: All previous scripts (01-05)
-- ============================================================================

USE uek_analysis;

-- ============================================================================
-- 1. POPULATE STUDENT GRADES
-- ============================================================================
-- Insert grades for students who have completed exams
-- Mix of different grade values to create realistic scenarios

-- First Year CS Students - completed first semester exams
INSERT INTO student_grades (student_id, module_id, exam_date, grade_id, attempt_number) VALUES
-- Adam Kowalski (student_id: 1) - excellent student
(1, 1, '2024-01-15', 6, 1),  -- Very Good in Intro to Programming
(1, 2, '2024-01-22', 5, 1),  -- Good Plus in Math for CS I
(1, 3, '2024-02-05', 6, 1),  -- Very Good in Computer Systems
(1, 4, '2024-02-12', 5, 1),  -- Good Plus in Logic

-- Barbara Nowak (student_id: 2) - good student
(2, 1, '2024-01-15', 5, 1),  -- Good Plus in Intro to Programming
(2, 2, '2024-01-22', 4, 1),  -- Good in Math for CS I
(2, 3, '2024-02-05', 5, 1),  -- Good Plus in Computer Systems
(2, 4, '2024-02-12', 4, 1),  -- Good in Logic

-- Cezary Wiśniewski (student_id: 3) - struggling student
(3, 1, '2024-01-15', 3, 1),  -- Sufficient in Intro to Programming
(3, 2, '2024-01-22', 2, 1),  -- Failed Math for CS I (first attempt)
(3, 2, '2024-03-15', 3, 2),  -- Sufficient in Math for CS I (retake)
(3, 3, '2024-02-05', 4, 1),  -- Good in Computer Systems
(3, 4, '2024-02-12', 3, 1),  -- Sufficient in Logic

-- Diana Wójcik (student_id: 4) - average student
(4, 1, '2024-01-15', 4, 1),  -- Good in Intro to Programming
(4, 2, '2024-01-22', 4, 1),  -- Good in Math for CS I
(4, 3, '2024-02-05', 3, 1),  -- Sufficient in Computer Systems
(4, 4, '2024-02-12', 5, 1),  -- Good Plus in Logic

-- Emil Kowalczyk (student_id: 5) - very good student
(5, 1, '2024-01-15', 6, 1),  -- Very Good in Intro to Programming
(5, 2, '2024-01-22', 6, 1),  -- Very Good in Math for CS I
(5, 3, '2024-02-05', 5, 1),  -- Good Plus in Computer Systems
(5, 4, '2024-02-12', 6, 1),  -- Very Good in Logic

-- Group 102 students (sample grades)
(6, 1, '2024-01-15', 4, 1), (6, 2, '2024-01-22', 3, 1), (6, 3, '2024-02-05', 4, 1),
(7, 1, '2024-01-15', 5, 1), (7, 2, '2024-01-22', 5, 1), (7, 3, '2024-02-05', 6, 1),
(8, 1, '2024-01-15', 3, 1), (8, 2, '2024-01-22', 3, 1), (8, 3, '2024-02-05', 3, 1),
(9, 1, '2024-01-15', 6, 1), (9, 2, '2024-01-22', 5, 1), (9, 3, '2024-02-05', 5, 1),
(10, 1, '2024-01-15', 4, 1), (10, 2, '2024-01-22', 4, 1), (10, 3, '2024-02-05', 4, 1),

-- Second Year CS Students - some completed courses
(16, 5, '2024-01-29', 5, 1), (16, 6, '2024-02-19', 6, 1), -- Paweł - excellent
(17, 5, '2024-01-29', 4, 1), (17, 6, '2024-02-19', 4, 1), -- Regina - good
(18, 5, '2024-01-29', 6, 1), (18, 6, '2024-02-19', 5, 1), -- Sebastian - very good
(19, 5, '2024-01-29', 3, 1), (19, 6, '2024-02-19', 3, 1), -- Teresa - average
(20, 5, '2024-01-29', 2, 1), (20, 6, '2024-02-19', 3, 1), -- Urszula - struggling

-- Third Year CS Students - advanced courses
(26, 10, '2024-04-15', 6, 1), (26, 11, '2024-04-22', 5, 1), -- Beata - excellent
(27, 10, '2024-04-15', 5, 1), (27, 11, '2024-04-22', 5, 1), -- Cyprian - very good
(28, 10, '2024-04-15', 4, 1), (28, 11, '2024-04-22', 4, 1), -- Dorota - good
(29, 10, '2024-04-15', 3, 1), (29, 11, '2024-04-22', 4, 1), -- Edward - average
(30, 10, '2024-04-15', 5, 1), (30, 11, '2024-04-22', 6, 1), -- Felicja - excellent

-- Economics Students - first year grades
(31, 22, '2024-01-16', 4, 1), (31, 23, '2024-01-23', 5, 1), -- Laura - good
(32, 22, '2024-01-16', 6, 1), (32, 23, '2024-01-23', 6, 1), -- Marek - excellent
(33, 22, '2024-01-16', 3, 1), (33, 23, '2024-01-23', 3, 1), -- Natalia - sufficient
(34, 22, '2024-01-16', 5, 1), (34, 23, '2024-01-23', 4, 1), -- Oskar - good
(35, 22, '2024-01-16', 4, 1), (35, 23, '2024-01-23', 4, 1), -- Patrycja - good

-- Business Administration grades
(46, 29, '2024-01-17', 5, 1), (46, 30, '2024-01-24', 4, 1), -- Gabriela
(47, 29, '2024-01-17', 4, 1), (47, 30, '2024-01-24', 5, 1), -- Hubert
(48, 29, '2024-01-17', 6, 1), (48, 30, '2024-01-24', 6, 1); -- Inga

-- ============================================================================
-- 2. POPULATE TUITION FEES
-- ============================================================================
-- Insert tuition fee payments for students
-- Different payment amounts and dates to simulate real scenarios

INSERT INTO tuition_fees (student_id, fee_amount, date_of_payment, payment_method) VALUES
-- First Year CS Students - semester fees
(1, 2500.00, '2023-09-15', 'bank_transfer'),   -- Adam - full payment
(1, 2500.00, '2024-02-15', 'bank_transfer'),   -- Adam - second semester

(2, 2500.00, '2023-09-20', 'bank_transfer'),   -- Barbara
(2, 2500.00, '2024-02-18', 'bank_transfer'),

(3, 1250.00, '2023-09-25', 'bank_transfer'),   -- Cezary - partial payment
(3, 1250.00, '2023-11-15', 'cash'),            -- Cezary - remaining amount
(3, 2500.00, '2024-02-25', 'bank_transfer'),   -- Cezary - second semester

(4, 2500.00, '2023-09-18', 'bank_transfer'),   -- Diana
(4, 2500.00, '2024-02-20', 'bank_transfer'),

(5, 2500.00, '2023-09-10', 'bank_transfer'),   -- Emil - early payment
(5, 2500.00, '2024-02-10', 'bank_transfer'),

-- Group 102 payments
(6, 2500.00, '2023-09-22', 'bank_transfer'), (6, 2500.00, '2024-02-22', 'bank_transfer'),
(7, 2500.00, '2023-09-19', 'bank_transfer'), (7, 2500.00, '2024-02-19', 'bank_transfer'),
(8, 2000.00, '2023-09-30', 'bank_transfer'), (8, 500.00, '2023-12-15', 'cash'), -- late payment
(9, 2500.00, '2023-09-12', 'bank_transfer'), (9, 2500.00, '2024-02-12', 'bank_transfer'),
(10, 2500.00, '2023-09-25', 'bank_transfer'), (10, 2500.00, '2024-02-25', 'bank_transfer'),

-- Second Year CS Students - higher fees
(16, 3000.00, '2023-09-15', 'bank_transfer'), (16, 3000.00, '2024-02-15', 'bank_transfer'),
(17, 3000.00, '2023-09-18', 'bank_transfer'), (17, 3000.00, '2024-02-18', 'bank_transfer'),
(18, 3000.00, '2023-09-20', 'bank_transfer'), (18, 3000.00, '2024-02-20', 'bank_transfer'),
(19, 1500.00, '2023-09-25', 'bank_transfer'), (19, 1500.00, '2023-11-20', 'bank_transfer'),
(20, 3000.00, '2023-10-05', 'bank_transfer'), (20, 3000.00, '2024-03-05', 'bank_transfer'),

-- Third Year CS Students - highest fees
(26, 3500.00, '2023-09-10', 'bank_transfer'), (26, 3500.00, '2024-02-10', 'bank_transfer'),
(27, 3500.00, '2023-09-12', 'bank_transfer'), (27, 3500.00, '2024-02-12', 'bank_transfer'),
(28, 3500.00, '2023-09-15', 'bank_transfer'), (28, 3500.00, '2024-02-15', 'bank_transfer'),
(29, 3500.00, '2023-09-20', 'bank_transfer'), (29, 3500.00, '2024-02-20', 'bank_transfer'),
(30, 3500.00, '2023-09-18', 'bank_transfer'), (30, 3500.00, '2024-02-18', 'bank_transfer'),

-- Economics Students
(31, 2200.00, '2023-09-20', 'bank_transfer'), (31, 2200.00, '2024-02-20', 'bank_transfer'),
(32, 2200.00, '2023-09-15', 'bank_transfer'), (32, 2200.00, '2024-02-15', 'bank_transfer'),
(33, 1100.00, '2023-09-30', 'bank_transfer'), (33, 1100.00, '2023-12-30', 'cash'),
(34, 2200.00, '2023-09-18', 'bank_transfer'), (34, 2200.00, '2024-02-18', 'bank_transfer'),
(35, 2200.00, '2023-09-22', 'bank_transfer'), (35, 2200.00, '2024-02-22', 'bank_transfer'),

-- Business Administration Students
(46, 2400.00, '2023-09-25', 'bank_transfer'), (46, 2400.00, '2024-02-25', 'bank_transfer'),
(47, 2400.00, '2023-09-20', 'bank_transfer'), (47, 2400.00, '2024-02-20', 'bank_transfer'),
(48, 2400.00, '2023-09-15', 'bank_transfer'), (48, 2400.00, '2024-02-15', 'bank_transfer');

-- ============================================================================
-- SUMMARY VIEWS FOR EASY ANALYSIS
-- ============================================================================
-- Create some useful views for learning SQL

-- View: Student Performance Summary
CREATE VIEW student_performance AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.surname) as full_name,
    g.group_name,
    COUNT(sg.grade_id) as exams_taken,
    ROUND(AVG(gr.grade_value), 2) as average_grade,
    MIN(gr.grade_value) as lowest_grade,
    MAX(gr.grade_value) as highest_grade
FROM students s
LEFT JOIN `groups` g ON s.group_no = g.group_no
LEFT JOIN student_grades sg ON s.student_id = sg.student_id
LEFT JOIN grades gr ON sg.grade_id = gr.grade_id
GROUP BY s.student_id, s.first_name, s.surname, g.group_name;

-- View: Module Enrollment Summary
CREATE VIEW module_enrollment AS
SELECT 
    m.module_id,
    m.module_name,
    d.department_name,
    COUNT(sm.student_id) as enrolled_students,
    COUNT(sg.student_id) as completed_exams,
    ROUND(AVG(gr.grade_value), 2) as average_grade
FROM modules m
LEFT JOIN departments d ON m.department_id = d.department_id
LEFT JOIN students_modules sm ON m.module_id = sm.module_id
LEFT JOIN student_grades sg ON m.module_id = sg.module_id
LEFT JOIN grades gr ON sg.grade_id = gr.grade_id
GROUP BY m.module_id, m.module_name, d.department_name;

-- View: Financial Summary by Student
CREATE VIEW student_financials AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.surname) as full_name,
    g.group_name,
    COUNT(tf.payment_id) as total_payments,
    SUM(tf.fee_amount) as total_paid,
    MAX(tf.date_of_payment) as last_payment_date
FROM students s
LEFT JOIN `groups` g ON s.group_no = g.group_no
LEFT JOIN tuition_fees tf ON s.student_id = tf.student_id
GROUP BY s.student_id, s.first_name, s.surname, g.group_name;

-- ============================================================================
-- END OF GRADES AND TUITION FEES SCRIPT
-- ============================================================================