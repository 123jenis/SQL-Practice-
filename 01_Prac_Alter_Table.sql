SELECT * FROM students;

-- How to Rename the column 
ALTER TABLE students
RENAME COLUMN student_id TO Student_Id;

ALTER TABLE students 
RENAME COLUMN name TO Name;

ALTER TABLE students
RENAME COLUMN age TO Age;

ALTER TABLE students
RENAME COLUMN gender TO Gender;

ALTER TABLE students
RENAME COLUMN department TO Department;

-- How to Update data in column
UPDATE students
SET phone = 00000, city = 'Surat'
WHERE Student_Id = 1;

UPDATE students
SET gpa = 01.0
WHERE Student_Id = 1;

UPDATE students 
SET Gender = 'Male'
WHERE Student_Id = 1;

UPDATE students
SET semester = 0
WHERE Student_Id = 1;

UPDATE students
SET enrollment_date = '2000-12-12'
WHERE Student_Id = 1;

