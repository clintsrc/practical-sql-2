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
