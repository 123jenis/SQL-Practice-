SELECT * FROM employees_1;

-- Offset / Value

-- LAG(col, n, default) — previous row
-- LEAD(col, n, default) — next row
-- FIRST_VALUE(col) — first value in frame
-- LAST_VALUE(col) — last value in frame
-- NTH_VALUE(col, n) — nth value in frame

-- Lag
-- Show the previous 1 row to data in next row perticular one column data
SELECT name, department, hire_date, salary,
	LAG(salary, 1) OVER (PARTITION BY department ORDER BY hire_date) AS prev_salary
FROM employees_1
ORDER BY department, hire_date;

--Lead
-- Show the next 1 row data in previous row perticular one column data
SELECT name, department, hire_date, salary,
	LEAD(salary, 1) OVER(PARTITION BY department ORDER BY hire_date) AS Next_salary
FROM employees_1
ORDER BY department, hire_date;

-- First Value

SELECT name, department, salary,
       FIRST_VALUE(name) OVER (PARTITION BY department ORDER BY salary DESC, name) AS top_earner
FROM employees_1
ORDER BY department, salary DESC;

-- Last Value
/* ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING 
   Without the ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING, every row would just show its own name — not useful. 
   This frame forces it to look at the whole partition, not just up to the current row. */

SELECT name, department, salary,
	LAST_VALUE(name) OVER (
		PARTITION BY department ORDER BY salary DESC, name
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
		AS Low_Earner
FROM employees_1
ORDER BY department, salary DESC;

-- NTH_VALUE

SELECT name, department, salary,
	NTH_VALUE(name, 3) OVER (PARTITION BY department ORDER BY salary DESC, name
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
	AS Second_highest_earner
FROM employees_1
ORDER BY department, salary DESC;








