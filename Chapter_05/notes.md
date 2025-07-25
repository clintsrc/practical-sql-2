# Importing and Exporting Data

## Overview

The three basic steps are:

1. Get a copy of the source data in a delimited text file (typically CSV, Comma-separated Values). Also called a flat file
1. Create a table to store the data
1. Write a Postgres-specific COPY statement (or equivalent) to perform the import
   - ref: [Converting from other Databases to PostgreSQL](https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL)
1. Examine the data for any issues (gaps, misalignments) that may need to be addressed as well as the type and consistency of the data itself

Data processing can require multiple steps/passes to get the result you want

## Special Cases

### HEADER Rows

Often an export will include the field names in the first row exported

- It's helpful for identifying the data itself
- Using Postgres, you need to exclude it when you import

### Text Qualifiers

String values that may contain commas, line breaks, or quote characters themselves are handled with a text qualifier, usually the double-quote.
A text qualifier ensures that fields with special characters are parsed correctly.

```text
id,name,note
1,"Dave","Hello, friend"
```

## Importing

### COPY FROM to import

- ref [COPY](https://www.postgresql.org/docs/current/sql-copy.html) command

The table that's the target of the import must exist, it's not automatically created

```SQL
COPY table_name
FROM '<local_system_path>'
WITH (FORMAT CSV, HEADER); -- HEADER option indicates a header row is present in the input that is to be excluded
```

### pgAdmin Permission Issues

Use the psql commond line instead for the import (note the escape character '\copy'):

```bash
psql -U <superuserid> -d <database_name> -c "\copy table_name FROM ..."
```

### LIMIT

To limit the number of records a query returns use LIMIT

```SQL
SELECT column1, column2
FROM table_name
LIMIT 3; -- only show the first 3 rows

```

### DELETE table data

To delete all data from a table, without deleting the table itself, use:

```SQL
DELETE FROM table_name;
```

## Handling Subsets

### Scenario: the table specifies fields that are missing in the datafile

#### Specify Fields Explicitly

Explicitly specify the fields into which you want to import the fields that are present in the datafile

Example:

The table has these fields

``` text
| id | town | county | supervisor | start_date | salary | benefits |
```

The data file only contains these:

``` text
town,supervisor,salary
Anytown,Jones,67000
```

This will populate the available data into the specified fields

```SQL
COPY supervisor_salaries (town, supervisor, salary) -- the fields are explicitly specified here in parenthesis
FROM '<path_to.csv>'
WITH (FORMAT CSV, HEADER);
```

### Scenario: import a specific number of rows

#### COPY WHERE

NOTE: The WHERE clause is Postgres-specific, v12+

```SQL
COPY supervisor_salaries (town, supervisor, salary) -- the fields are explicitly specified here in parenthesis
FROM '<path_to.csv>'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';  -- only import these matching records
```

### Scenario: field is missing from dataset: add the column value during import

#### TEMPORARY TABLE

- A temporary table only exists until the database connection session ends.
- You can process data in a temporary table before adding it to a permanent table.

```SQL
 -- LIKE <table_name>: create the temporary table based on the <table_name> table
 -- INCLUDING ALL: include all indexes and IDENTITY settings
CREATE TEMPORARY TABLE supervisor_salaries_temp
    (LIKE supervisor_salaries INCLUDING ALL);
```

Now you can COPY the dataset into the temporary table (see the COPY command in the previous scenario')

```SQL
-- Import the data into the <table_name_temp> temporary table
COPY supervisor_salaries_temp ...
```

Next you can process the data (e.g. add the missing County 'Mills').

This roughly translates to:

- FROM the supervisor_salaries_temp table
- SELECT the specified columns, but explicitly set the 'county' field to 'Mills'
- INSERT that resulting dataset (which now includes 'Mills) into the target table (supervisor_salaries)

NOTE: The INSERT is not modifying supervisor_salaries_temp, it's updating that selected dataset itself, then applying it to supervisor_salaries: supervisor_salaries_temp will still have empty 'county' fields, but supervisor_salaries records will have the 'Mills' county value.

```SQL
INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;
```

The temporary table will be cleared when you disconnect, but best practices is to explicitly clear it to keep the environment clean.

```SQL
DROP TABLE supervisor_salaries_temp;
```

## Exporting

### Export All (table) data

### COPY TO for export

```SQL
COPY table_name
TO '<path_to_output.txt>'
WITH (FORMAT CSV, HEADER, DELIMITER '|'); -- note delimiter is '|', not ',' for this example
```

### Export specific field/s

```SQL
COPY table_name (column1, column2, column3)
TO '<path_to_output.txt>'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
```

### Export results of a query

This example runs a query for case-insensitive county_name values like 'mill', then exports the resulting dataset to file

```SQL
COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO '<path_to_output.csv>'
WITH (FORMAT CSV, HEADER);
```
