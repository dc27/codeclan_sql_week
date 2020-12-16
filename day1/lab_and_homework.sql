----- MVP -----
----- Q1  -----

SELECT *
FROM employees 
WHERE department = 'Human Resources';

----- Q2  -----

SELECT
	first_name,
	last_name,
	country
FROM employees
WHERE department = 'Legal';

----- Q3  -----

SELECT
	COUNT(id) AS no_of_Portugal_staff
FROM employees
WHERE country = 'Portugal';

----- Q4  -----

SELECT
	COUNT(id) AS no_of_Iberian_staff
FROM employees
WHERE (country = 'Portugal') OR (country = 'Spain');

----- Q5 -----

SELECT
	COUNT(id) AS no_of_missing_local_account_number
FROM pay_details
WHERE local_account_no IS NULL;

----- Q6  -----

SELECT
	first_name,
	last_name
FROM employees
ORDER BY last_name ASC NULLS LAST; 

-- fun facts - it orders ASC by default and there are no NULLs in last_name

----- Q7  -----

SELECT
	COUNT(id) AS no_of_F_names
FROM employees 
WHERE first_name ILIKE 'f%';

-- It would be cool to see the names though

SELECT *
FROM employees 
WHERE first_name ILIKE 'f%';

----- Q8  -----

SELECT
	COUNT(id) AS no_of_non_ger_or_french_pension_enrolled_staff
FROM employees
WHERE (pension_enrol = TRUE)
AND (country != 'France')
AND (country != 'Germany');

----- Q9  -----

SELECT
	department,
	COUNT(id) AS no_of_person_starting_after_2003
FROM employees
WHERE EXTRACT(YEAR FROM start_date) > 2003
GROUP BY department;

----- Q10 -----

SELECT
	department,
	fte_hours,
	COUNT(id) AS no_of_employees_in_each_FTE_bracket_per_department
FROM employees
GROUP BY
	department,
	fte_hours 
ORDER BY
	department ASC NULLS LAST,
	fte_hours ASC NULLS LAST;

----- Q11 -----

SELECT
	department,
	COUNT(id) AS no_of_persons_in_dep_without_first_name 
FROM employees 
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT(id) >= 2
ORDER BY
	COUNT(id) DESC NULLS LAST,
	department ASC NULLS LAST;

----- Q12 -----

SELECT
	department,
	CAST(SUM(CAST(grade = 1 AS INT)) AS REAL)/COUNT(id) AS proportion_is_grade1s
FROM employees
GROUP BY
	department;

-- and as a percentage

SELECT
	department,
	COUNT(id) AS no_of_persons_in_department,
	SUM(CAST(grade = 1 AS INT)) AS no_of_grade1s,
	CAST(SUM(CAST(grade = 1 AS INT)) AS REAL)*100/COUNT(id) AS percentage_of_grade1s
FROM employees
GROUP BY
	department;


-- Extensions --

----- Q1  -----

SELECT
	EXTRACT(YEAR FROM start_date) AS year,
	COUNT(id) AS no_of_employees_starting
FROM employees 
GROUP BY EXTRACT(YEAR FROM start_date)
ORDER BY EXTRACT(YEAR FROM start_date);

----- Q2  -----

SELECT
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 40000 THEN 'low'
		WHEN salary >=40000  THEN 'high'
	END AS salary_class
FROM employees;
	

----- Q3  -----

SELECT
	LEFT(local_sort_code, 2) AS first_two_digits,
	COUNT(id) AS count_records
FROM pay_details
GROUP BY first_two_digits 
ORDER BY CASE
		WHEN LEFT(local_sort_code, 2) IS NULL THEN 1
		ELSE 0
END DESC,
COUNT(id) DESC,
first_two_digits ASC;

----- Q4  -----

SELECT
	SUBSTRING(local_tax_code, ('[0-9]{4}')) AS digits
FROM pay_details;
	