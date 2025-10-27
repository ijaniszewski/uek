-- ============================================================================
-- UNIVERSITY DATABASE INITIALIZATION - EMPLOYEES AND LECTURERS
-- ============================================================================
-- This script populates employees and lecturers tables with sample data
-- Creates realistic academic staff for the university
-- 
-- Execution order: 03 (third script to run)
-- Dependencies: 01-init.sql, 02-reference-data.sql
-- ============================================================================

USE uek_analysis;

-- ============================================================================
-- 1. POPULATE EMPLOYEES
-- ============================================================================
-- Insert university employees (professors, lecturers, etc.)
INSERT INTO employees (surname, first_name, employment_date, pesel, acad_position_id) VALUES
-- Computer Science Department Staff
('Kowalski', 'Jan', '2015-09-01', '80010112345', 1), -- Professor
('Nowak', 'Anna', '2018-03-15', '85032298765', 2),   -- Associate Professor
('Wiśniewski', 'Piotr', '2020-09-01', '90050587654', 3), -- Assistant Professor
('Wójcik', 'Maria', '2019-02-10', '88121276543', 4), -- Senior Lecturer
('Kowalczyk', 'Tomasz', '2021-10-01', '92080398765', 5), -- Lecturer

-- Mathematics Department Staff
('Lewandowski', 'Krzysztof', '2012-09-01', '75121243210', 1), -- Professor
('Zielińska', 'Katarzyna', '2017-09-01', '82040165432', 2),   -- Associate Professor
('Szymański', 'Michał', '2019-03-01', '89070854321', 3),     -- Assistant Professor

-- Economics Department Staff
('Dąbrowski', 'Robert', '2014-09-01', '78030987654', 1),     -- Professor
('Kamińska', 'Agnieszka', '2016-09-01', '83110298765', 2),   -- Associate Professor
('Jankowski', 'Marcin', '2020-02-15', '91020176543', 4),     -- Senior Lecturer

-- Business Administration Staff
('Kozłowski', 'Paweł', '2013-09-01', '76081234567', 2),      -- Associate Professor
('Mazur', 'Joanna', '2018-09-01', '84090387654', 3),         -- Assistant Professor
('Krawczyk', 'Adam', '2021-03-01', '93040298765', 5),        -- Lecturer

-- Finance Department Staff  
('Piotrowski', 'Stanisław', '2011-09-01', '72110876543', 1), -- Professor
('Grabowska', 'Magdalena', '2017-02-01', '81060543210', 2),  -- Associate Professor

-- Management Department Staff
('Nowakowski', 'Jacek', '2016-09-01', '79050432109', 2),     -- Associate Professor
('Pawłowska', 'Beata', '2019-09-01', '86120987654', 3),      -- Assistant Professor

-- Marketing Department Staff
('Michalski', 'Rafał', '2018-09-01', '87030165432', 3),      -- Assistant Professor
('Wróbel', 'Ewa', '2020-09-01', '90110276543', 4),          -- Senior Lecturer

-- Visiting Professors
('Smith', 'John', '2023-09-01', '00000000001', 7),           -- Visiting Professor
('Müller', 'Hans', '2023-09-01', '00000000002', 7);         -- Visiting Professor

-- ============================================================================
-- 2. POPULATE LECTURERS
-- ============================================================================
-- Link employees to departments (some may teach in multiple departments)

-- Computer Science Department Lecturers
INSERT INTO lecturers (lecturer_id, employee_id, department_id) VALUES
(1, 1, 1),   -- Kowalski -> Computer Science
(2, 2, 1),   -- Nowak -> Computer Science  
(3, 3, 1),   -- Wiśniewski -> Computer Science
(4, 4, 1),   -- Wójcik -> Computer Science
(5, 5, 1),   -- Kowalczyk -> Computer Science

-- Mathematics Department Lecturers
(6, 6, 2),   -- Lewandowski -> Mathematics
(7, 7, 2),   -- Zielińska -> Mathematics
(8, 8, 2),   -- Szymański -> Mathematics
(9, 8, 1),   -- Szymański also teaches in Computer Science (cross-department)

-- Economics Department Lecturers  
(10, 9, 3),  -- Dąbrowski -> Economics
(11, 10, 3), -- Kamińska -> Economics
(12, 11, 3), -- Jankowski -> Economics

-- Business Administration Lecturers
(13, 12, 4), -- Kozłowski -> Business Administration
(14, 13, 4), -- Mazur -> Business Administration
(15, 14, 4), -- Krawczyk -> Business Administration

-- Finance Department Lecturers
(16, 15, 5), -- Piotrowski -> Finance
(17, 16, 5), -- Grabowska -> Finance
(18, 16, 3), -- Grabowska also teaches Economics (cross-department)

-- Management Department Lecturers
(19, 17, 6), -- Nowakowski -> Management
(20, 18, 6), -- Pawłowska -> Management
(21, 18, 4), -- Pawłowska also teaches Business Admin (cross-department)

-- Marketing Department Lecturers
(22, 19, 8), -- Michalski -> Marketing
(23, 20, 8), -- Wróbel -> Marketing

-- Visiting Professors (multiple departments)
(24, 21, 1), -- Smith -> Computer Science
(25, 21, 2), -- Smith -> Mathematics  
(26, 22, 3), -- Müller -> Economics
(27, 22, 4); -- Müller -> Business Administration

-- ============================================================================
-- END OF EMPLOYEES AND LECTURERS SCRIPT
-- ============================================================================