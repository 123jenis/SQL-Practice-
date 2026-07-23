SELECT * FROM employees_2;

-- 🟢 Basic

-- 1. Assign a unique ROW_NUMBER() to each employee, ordered by salary descending (whole table, no partition).
-- 2. Use RANK() to rank employees by salary descending within each department. Notice where gaps appear.
-- 3. Use DENSE_RANK() for the same query as Q2. Compare the output — where does it differ from RANK?
-- 4. Write a query using ROW_NUMBER() to number employees within each department, ordered by join_date ascending (i.e., seniority order).

-- 🟡 Intermediate

-- 5. Find the top 2 highest-paid employees per department using RANK(). (Hint: wrap in a CTE/subquery and filter WHERE rnk <= 2.)
-- 6. Use NTILE(4) to split all 12 employees into 4 salary-based buckets (quartiles). Then write a follow-up query showing the average salary per bucket.
-- 7. A classic trap: use ROW_NUMBER() partitioned by department + salary, ordered by join_date, to break ties consistently — then explain in one line why RANK() alone can't guarantee exactly N rows per department when there are ties.

-- 🔴 Advanced

-- 8. Find the second-highest salary in each department without using LIMIT/OFFSET — using DENSE_RANK() only (this handles ties correctly, unlike a naive ROW_NUMBER() approach).
-- 9. Deduplication scenario: imagine this table has duplicate rows per emp_id (same employee entered twice with different join_date). Write a query using ROW_NUMBER() partitioned by emp_id, ordered by join_date descending, to keep only the most recent record per employee.
-- 10. Combine two window functions in one query: use NTILE(4) to create salary quartiles, and within each quartile, use RANK() ordered by join_date to find the most senior employee in each quartile. (This tests whether you can layer/nest window function logic correctly.)

-- Solve Questions

-- 1. Assign a unique ROW_NUMBER() to each employee, ordered by salary descending (whole table, no partition).

SELECT emp_name, department, salary,
	ROW_NUMBER() OVER (
		ORDER BY salary DESC
	) AS Row_Number
FROM employees_2;

-- 2. Use RANK() to rank employees by salary descending within each department. Notice where gaps appear.

SELECT emp_name, department, salary,
	RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS Rank_by_salary
FROM employees_2;

-- 3. Use DENSE_RANK() for the same query as Q2. Compare the output — where does it differ from RANK?

SELECT emp_name,department, salary,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS Rank_by_salary
FROM employees_2;

-- 4. Write a query using ROW_NUMBER() to number employees within each department, ordered by join_date ascending (i.e., seniority order).

SELECT emp_name, department, salary,
	ROW_NUMBER() OVER (PARTITION BY department ORDER BY join_date ASC) AS Row_number_by_salary
FROM employees_2;

-- 🟡 Intermediate

-- 5. Find the top 2 highest-paid employees per department using RANK(). (Hint: wrap in a CTE/subquery and filter WHERE rnk <= 2.)

WITH ranked_employees AS (
    SELECT emp_name, department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees_2
)
SELECT emp_name, department, salary, rnk
FROM ranked_employees
WHERE rnk <= 2;

-- 6. Use NTILE(4) to split all 12 employees into 4 salary-based buckets (quartiles). Then write a follow-up query showing the average salary per bucket.

SELECT emp_name, department, salary,
	NTILE(4) OVER (ORDER BY salary DESC) AS Salary_per_bucket
FROM employees_2;

-- 7. A classic trap: use ROW_NUMBER() partitioned by department + salary, ordered by join_date, to break ties consistently — 
-- then explain in one line why RANK() alone can't guarantee exactly N rows per department when there are ties.

SELECT emp_name, department, salary,
	ROW_NUMBER() OVER (PARTITION BY department , salary ORDER BY join_date ASC) AS Salary
FROM employees_2;

-- 8. Find the second-highest salary in each department without using LIMIT/OFFSET — using DENSE_RANK() only (this handles ties correctly, unlike a naive ROW_NUMBER() approach).

WITH ranked_salaries AS (
    SELECT emp_name, department, salary,
           DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees_2
)
SELECT emp_name, department, salary, salary_rank
FROM ranked_salaries
WHERE salary_rank = 2;

-- 9. Deduplication scenario: imagine this table has duplicate rows per emp_id (same employee entered twice with different join_date). Write a query using ROW_NUMBER() partitioned by emp_id, ordered by join_date descending, to keep only the most recent record per employee.

SELECT emp_name, department, salary, join_date,
	ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY join_date DESC) AS record
FROM employees_2;

-- 10. Combine two window functions in one query: use NTILE(4) to create salary quartiles, and within each quartile, use RANK() ordered by join_date to find the 
-- most senior employee in each quartile. (This tests whether you can layer/nest window function logic correctly.)

WITH salary_quartiles AS (
    SELECT emp_name, department, salary, join_date,
           NTILE(4) OVER (ORDER BY salary DESC) AS quartile
    FROM employees_2
)
SELECT emp_name, department, salary, join_date, quartile,
       RANK() OVER (PARTITION BY quartile ORDER BY join_date ASC) AS seniority_rank
FROM salary_quartiles
ORDER BY quartile, seniority_rank;


