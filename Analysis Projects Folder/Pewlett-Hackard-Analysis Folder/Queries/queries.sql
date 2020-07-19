--Determine Retierment Eligability
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--Get a count
SELECT COUNT(*)
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--Narrow down the year in the where clause
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- Retirement eligibility, multiple conditions
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Create a new table with our data, will use to export data to csv laster
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--query for reitrement numbers grouped by title
select count(title), title
from updated_retiring_employees
group by title
order by title;

--query for mentorship program
select count(title), title
from updated_employee_mentorship_program
group by title
order by title