# Importing and Exporting Data

Notes

## Overview

The three basic steps are:

1. Get a copy of the source data in a delimited text file (typically CSV, Comma-separated Values). Also called a flat file
1. Create a table to store the data
1. Write a Postgres-specific COPY statement (or equivalent) to perform the import
   - ref: [Converting from other Databases to PostgreSQL](https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL)
1. Examine the data for any issues (gaps, misalignments) that may need to be addressed as well as the type and consistency of the data itself

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

## COPY to import

- ref [COPY](https://www.postgresql.org/docs/current/sql-copy.html) command

The table that's the target of the import must exist, it's not automatically created

```SQL
COPY table_name
FROM '<local_system_path>'
WITH (FORMAT CSV, HEADER); -- HEADER option indicates a header row is present in the input that is to be excluded
```

### pgAdmin Permission Issues

Use the psql commond line instead for the import:

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


### Handling Subsets
