# Joining Tables

## Overview

Relational model

- Each table stores data for a single entity
- Avoids duplicate data, easier to maintain, more flexible queries

## JOIN

Command to connect tables

### Primary Key

A column (or collection of columns) whose values uniquely identify each row in a table

- The primary key must have a unique value for each row
- The primary key cannot have missing values

#### CONSTRAINT

The CONSTRAINT keyword creates a rule (a constraint) for column/s, such as enforcing uniqueness, primary key status, foreign key relationships, or checks.

A primary key is a special constraint that requires the column/s have unique, non-null values using the command: CONSTRAINT name PRIMARY KEY


Example:

```SQL
CREATE TABLE departments (
  dept_id integer,
  dept text,
  city text,
  --  CONSTRAINT creating a primary key constraint on dept_id, named dept_key
  CONSTRAINT dept_key PRIMARY KEY (dept_id),
  -- CONSTRAINT ensuring that the (dept, city) combination is unique across rows, named
  CONSTRAINT dept_city_unique UNIQUE (dept, city)
);
```

### Foreign Key

- Its values must already exist in the column(s) it references (usually a primary key or unique key in another table).
- The primary key column(s) cannot contain null values.

```SQL
CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10,2),
    -- Foreign key referencing departments.dept_id
    dept_id integer REFERENCES departments (dept_id),
    -- Primary key
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);
```

### JOIN ON

Query to connect (link) rows in multiple tables where the boolean value of the ON clause is true

```SQL
SELECT *
FROM
  table1
JOIN  -- link another table
  table2
ON
  -- boolean condition
  table1.key_column = table2.foreign_key_column
```

### OTHER JOINs

Picture JOINS as two tables side-by-side: ```<left table>``` JOIN ```<right table>```

- ```JOIN``` (aka ```INNER JOIN```): returns matches from both tables if both tables have matching values -- mismatches in both tables are filtered out.

```SQL
SELECT *
FROM district_2020 JOIN district_2035 -- use 'JOIN' or the full 'INNER JOIN' here
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;
```

```SQL
SELECT *
FROM district_2020 JOIN district_2035
-- If the fields being compared have the same name you can use 'USING' for convenience
USING (id)
ORDER BY district_2020.id;
```

- ```LEFT JOIN```: returns matches from the left table, otherwise no values from the right table are included -- returns all rows from the left table, even if unmatched, filters out mismatches in the right table. (Matches 'where it can' on the right). Can help reveal missing data.

```SQL
SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;
```

- ```RIGHT JOIN```: returns every row from the right table when there's a match in the left table, otherwise no values from the left table are included -- returns all rows from the right table, even if unmatched, filters out mismatches in the left table. (Matches 'where it can' on the left). Can help reveal missing data.

```SQL
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
-- order on right table since all of its records are returned - the output's cleaner
ORDER BY district_2035.id;
```

- ```FULL OUTER JOIN```: returns every row from both tables and joins rows where the joined columns match. If there is no matching value in either table, the result has no values for that table -- returns all rows from both tables, regardless of any matches. Can help to show partial overlap, show degree of matches.

```SQL
SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;
```

- ```CROSS JOIN```: returns all possible combinations of rows from both tables. WARNING: avoid using for large tables, the time to run it increases exponentially with the data. Cross join is helpful for smaller matrixes (e.g. available shirt sizes to available colors)

```SQL
SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;
```
