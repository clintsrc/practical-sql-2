# SELECT statement

Use SELECT to become familiar with the data. It can tell you:

- quality of the data (especially note DISTINCT)
- ranges of its values

## SELECT FROM

Specify column/s in a specific table

```sql
SELECT column1, column2, column3
FROM table_name;
```

Useful trivia: 'TABLE table_name' is a lesser-known command. These are equivalent

```sql
SELECT *
FROM table_name;
-- OR use
TABLE table_name;
```

## ORDER BY

It's usually best to avoid specifying multiple columns in the query: more than a couple, and you'll get diminishing returns.

Typically you want to include the most important, then run multiple queries to answer each question.

```sql
SELECT column1, column2, column3
FROM table_name
ORDER BY column1, column2 DESC; -- default is ASC (ascending)
```

### Positional

```sql
SELECT column1, column2, column3
FROM table_name
ORDER BY 3 DESC; -- uses the 3rd column from the SELECT clause (i.e. here it's 'column3')
```

## SELECT DISTINCT (returns unique values)

Use DISTINCT to eliminate duplicates and only show unique values

- Helps find data quality (especially inconsistent naming/formatting)

```sql
SELECT DISTINCT column1
FROM table_name;
```

### Distinct Pairs (DISTINCT with 2 columns)

- If 1 or more matches are found in both column1 and column2 (distinct pair), only 1 record is displayed
- Similar to the concept of:

```text
for each x in table
  print y values
```

```sql
-- If 1 or more matches are found in both column1 and column2 (distinct pair), only 1 record is displayed
SELECT DISTINCT column1, column2
FROM table_name;
```

## WHERE (filter)

```sql
SELECT column1, column2, column3
FROM table_name
WHERE column1 = value; -- use quotes for text: column1 = 'text value'
```

NOTE: examples of other operators: <> (or !=), >=, IN, LIKE, BETWEEN

(ref [https://www.postgresql.org/docs/6.3/c09.htm](https://www.postgresql.org/docs/6.3/c09.htm))

BETWEEN: is inclusive, meaning it also includes the start and end range matches themselves. You may prefer to use the >= (etc) operators for better precision.

### LIKE (and ILIKE)

For text pattern matching

- LIKE: case sensitive
- ILIKE (Postgres-specific): case insensitive

Wildcards

_: match a single character (e.g.: LIKE 'S_L')
%: match 1 or more characters (e.g.: LIKE 'S%')

### AND / OR (combining operators)

AND: All comparisons must be true
OR: At least one comparison must be true
(): use parens to explicitly group multiple comparisons

```sql
SELECT department, salary
FROM table_name
WHERE department = 'Information Technologies'
AND (salary < 138000 OR salary > 140000);
```
