------------------------------------------------------------------
-- Chapter 2: Beginning Data Exploration with SELECT - 2022-01-10
------------------------------------------------------------------

-- 1. The school district superintendent asks for a list of teachers in each
-- school. Write a query that lists the schools in alphabetical order along
-- with teachers ordered by last name A-Z.

SELECT first_name, last_name, school
FROM teachers
ORDER BY school ASC, last_name ASC;

-- 2. Write a query that finds the one teacher whose first name starts
-- with the letter 'S' and who earns more than $40,000.

SELECT first_name, last_name, school, salary
FROM teachers
WHERE first_name LIKE 'S%' 
	  AND salary > 40000;       -- LIKE é sensível à maiúscula/minúscula


-- 3. Rank teachers hired since Jan. 1, 2010, ordered by highest paid to lowest.
SELECT *
FROM teachers
WHERE hire_date >= '2010-01-01'    --- Datas devem ser colocadas entre aspas
ORDER BY salary DESC;
