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
-- FROM district_2020, district_2035 -- alternative method (comma)
-- FROM district_2020 JOIN district_2035 ON true -- alternative method (ON boolean)
ORDER BY district_2020.id, district_2035.id;
```

### NULL

Represents missing data (not the same as 0 nor empty string '')

```SQL
SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
-- WHERE district_2035.id IS NOT NULL -- filter on non-NULL
WHERE district_2035.id IS NULL; -- filter on missing values (aka anti-join)
```

### Relationship Types (Relational Model)

#### One-to-One (1:1)

Each row in Table A is linked to exactly one row in Table B, and vice versa.

Example: One person has one passport. One passport belongs to one person.

#### One-to-Many (1:N)

A single row in Table A can relate to many rows in Table B, but each row in Table B relates to only one row in Table A.

Example: One author can write many books. Each book has one author.

#### Many-to-Many (M:N)

Rows in Table A can relate to many rows in Table B, and vice versa. This is typically modeled using a junction table.

Example: Students can enroll in many courses, and each course can have many students.

### Selecting Specific Columns

To avoid ambiguity in the ```SELECT <column>, <column>``` clause, specify which specific table's column:

```SQL
SELECT <table1.columnA>, <table2.columnA>
...
```

Use AS for helpful aliases:

```SQL
SELECT district_2020.id AS d20_id
FROM district_2020;
```

Table Alias syntax example to simplify the code (more succinct):

```SQL
SELECT
  d20.id,
  d20.school_2020,
  d35.school_2035
FROM
  district_2020 AS d20  -- d20 is shorter, more succinct
  -- district_2020 d20  -- NOTE the AS is optional and this is also valid
  LEFT JOIN district_2035 AS d35  -- and d35 here
  ON d20.id = d35.id
ORDER BY
  d20.id;
```

### Join Multiple Tables

You can link as many tables as you want as long as they have columns with matching values to join on (though there may be a vendor-specific hard limit)

Here we have 3 tables with matching values. First:

- district_2020.id

And these tables are joined to that table's id field using their own matching id fields:

- district_2020_enrollment.id
- district_2020_grades.id

```SQL
SELECT d20.id,
       d20.school_2020,
       en.enrollment,
       gr.grades
FROM district_2020 AS d20 JOIN district_2020_enrollment AS en
    ON d20.id = en.id
JOIN district_2020_grades AS gr
    ON d20.id = gr.id
ORDER BY d20.id;
```

### Set Operators (to Combine Query Results)

Set operators combine the results of multiple SELECT queries.

#### ```UNION```

Appends the rows of the second query to the rows of the first. Duplicates are removed, though ```UNION ALL``` will preserve the duplicates.

```SQL
SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;
```

Customized results with UNION, here showing all records (UNION ALL) with alias headings to indicate the table (year) each school is from.

```SQL
SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020
UNION ALL
SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;
```

#### ```INTERSECT```

Return only rows that match in both queries. Duplicates are removed.

```SQL
SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;
```

#### ```EXCEPT```

Return only rows that exist in ('unique to') the first query but not in the second. Duplicates are removed.

```SQL
SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;
```

### Math operations on Joined Table Columns

Include the table name in the math operation.

Full example with tablename.columname used in math operations:

```SQL
SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
       -- Math operations use the joined table names:
       --    (table1_name_alias.column_name - table2_name_alias.column_name) / table2_name_alias.column_name
       round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_change
FROM us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
ON c2019.state_fips = c2010.state_fips
    AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change DESC;
```
