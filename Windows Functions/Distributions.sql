SELECT * FROM employees_1;

-- What it means :-
-- PERCENT_RANK() tells you where a row stands relative to all other rows, on a scale from 0 to 1. It's basically "what percentile is this row in."

/* Gujarati ma: PERCENT_RANK() etle "aa row, baaki badha rows ni saapeksh ma kya percentile par che" — result hamesha 0 thi 1 vachche j hoy che. 
   Sauthi nichi value ne hamesha 0 male, sauthi vadhu value ne 1 (jo tie na hoy to). */

-- High       --> 1
-- Low  	  --> 0
-- Same value --> Value Between 0 and 1

-- PERCENT_RANK() = (rank - 1) / (total_rows_in_partition - 1)

-- 1. PERCENT_RANK()

SELECT name, department, salary,
	RANK() OVER (PARTITION BY department ORDER BY salary) AS Rank_Num,
	PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS Per_Rank
FROM employees_1;

-- When You are only show the data perticular

SELECT *
FROM (
    SELECT 
        name, 
        department, 
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary) AS Rank_Num,
        PERCENT_RANK() OVER (PARTITION BY department ORDER BY salary) AS Per_Rank
    FROM employees_1
) sub
WHERE Per_Rank < 0.5;

-- 2. CUME_DIST()

-- What it means :-
-- CUME_DIST() (cumulative distribution) tells you what fraction of rows have a value less than or equal to the current row's value — again scaled 0 to 1, but calculated differently from

-- CUME_DIST() = (number of rows with value <= current row's value) / (total rows in partition)

SELECT name, department, salary,
	RANK() OVER (PARTITION BY department ORDER BY salary) AS Rank_num,
	CUME_DIST() OVER (PARTITION BY department ORDER BY salary) AS Cume_per
FROM employees_1;
