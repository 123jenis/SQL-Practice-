/* Windows Function definition:
   A window function does a calculation across a group of related rows, but shows the result next to every row — it doesn't merge rows into one, like GROUP BY does. */

   -- Think of it as: "look at a group of rows (the window), calculate something, but still give me every row back.".

-- 1 Ranking

-- ROW_NUMBER() — unique sequential number
-- RANK() — ties share rank, skips next
-- DENSE_RANK() — ties share rank, no skip
-- NTILE(n) — splits into n buckets

-- 2 Offset / Value

-- LAG(col, n, default) — previous row
-- LEAD(col, n, default) — next row
-- FIRST_VALUE(col) — first value in frame
-- LAST_VALUE(col) — last value in frame
-- NTH_VALUE(col, n) — nth value in frame

-- 3 Aggregate (as window functions)

-- SUM(col) OVER (...)
-- AVG(col) OVER (...)
-- COUNT(*) OVER (...)
-- MIN(col) OVER (...)
-- MAX(col) OVER (...)

-- 4 Distribution

-- PERCENT_RANK() — relative rank (0 to 1)
-- CUME_DIST() — cumulative distribution

CREATE TABLE employees_1 (
    emp_id      INT PRIMARY KEY,
    name        VARCHAR(50),
    department  VARCHAR(50),
    salary      NUMERIC(10,2),
    hire_date   DATE
);

INSERT INTO employees_1 VALUES
(1,  'Aarav',  'Sales', 50000, '2022-01-10'),
(2,  'Bhavna', 'Sales', 60000, '2021-03-15'),
(3,  'Chirag', 'Sales', 60000, '2023-06-01'),
(4,  'Diya',   'IT',    75000, '2020-07-20'),
(5,  'Esha',   'IT',    65000, '2022-11-05'),
(6,  'Farhan', 'IT',    85000, '2019-09-12'),
(7,  'Gauri',  'HR',    40000, '2023-02-18'),
(8,  'Harsh',  'HR',    45000, '2021-12-01'),
(9,  'Ishaan', 'IT',    65000, '2021-05-22'),
(10, 'Jiya',   'HR',    45000, '2020-08-30'),
(11, 'Kavya',  'Sales', 55000, '2020-11-11'),
(12, 'Lakshay','Sales', 60000, '2022-09-09');

SELECT * FROM employees_1;