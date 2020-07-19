-- Creating tables for PH-EmployeeDB
CREATE TABLE departments
(
    dept_no VARCHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);

CREATE TABLE employees
(
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    gender VARCHAR NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager
(
    dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles
(
    emp_no INT NOT NULL,
    title VARCHAR(20) NOT NULL,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
);

CREATE TABLE dept_emp
(
    emp_no INT NOT NULL,
    dept_no VARCHAR(4) NOT NULL,
    from_date DATE,
    to_date DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

-- Create table Number of Retiring Employees by Title
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.from_date,
    t.title,
    s.salary
INTO retiring_employees
FROM employees as e
    INNER JOIN titles as t
    ON (e.emp_no = t.emp_no)
    INNER JOIN salaries as s
    ON (e.emp_no = s.emp_no)
    INNER JOIN dept_emp as de
    on (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (de.to_date = '9999-01-01')
GROUP BY e.emp_no, t.from_date, t.title, s.salary
ORDER BY title;

-- Partition the data to show only most recent title per employee
-- creating a new table updated_retiring_employees
SELECT emp_no,
    first_name,
    last_name,
    from_date,
    title,
    salary
INTO updated_retiring_employees

FROM
    (SELECT emp_no,
        first_name,
        last_name,
        from_date,
        title,
        salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
    FROM retiring_employees
 ) tmp
WHERE rn = 1
ORDER BY emp_no;


--Employee mentorship program and partitioning to remove duplicats
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    t.title,
    de.from_date,
    de.to_date
INTO employee_mentorship_program
FROM employees as e
    INNER JOIN titles as t
    ON (e.emp_no = t.emp_no)
    INNER JOIN dept_emp as de
    on (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
    AND (t.to_date = '9999-01-01')
GROUP BY e.emp_no , t.title, de.from_date , de.to_date
ORDER BY e.emp_no;

-- Partition the data to show only most recent title per employee
-- updated table called updated_employee_mentorship_program
SELECT emp_no,
    first_name,
    last_name,
    title,
    from_date,
    to_date

INTO updated_employee_mentorship_program
FROM
    (SELECT emp_no,
        first_name,
        last_name,
        title,
        from_date,
        to_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
    FROM employee_mentorship_program
 ) tmp
WHERE rn = 1
ORDER BY emp_no;