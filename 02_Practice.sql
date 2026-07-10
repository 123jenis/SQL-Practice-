SELECT * FROM students;

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
