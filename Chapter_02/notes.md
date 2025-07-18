# Fundamentals

- Semicolon: always be sure to end a SQL statement with ';' or it most likely won't run.
  The statement will remain in the buffer until it receives the ';'. For example you
  may be entering multiple SQL statements, but they will all run together as a single
  (invalid) statement and you won't see the failing error result until you type the ';'
- Default database: when you first connect to the server you connect to the default
  database ('postgres'). From there you can create/connect to other databases, similar to
  changing your working directory in an OS.

## Create Database

```bash
# Connect as a superuser
psql -U postgres

# Don't forget the closing ';'
postgres=# CREATE DATABASE <DB Name>;
# Confirm the new database
postgres=# \l
```

### Create Table

Column (aka field, attribute):

- Each colmun has a data type (varchar for text, date, numeric)

#### Data Types

- Text and dates need quotes, nubers, integers and decimals don't
- varchar(25): '()' indicates the text limit (e.g. 25 characters)
- bigserial: a special integer type that auto-increments for every row (record)

First switch context to the database you want to work on

```bash
# Connect to the database
postgres=# \c <DB Name>
# Paste in your SQL commands
```

Example:

```SQL
CREATE TABLE <Table Name> (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);
```

```bash
# Show the new table
postgres=# \dt
```

#### Insert Data

- Insert adds each VALUES parameter into the table's specified fields
- id bigserial is not included because it's automatically handled by the DBMS (DB Managment System)

Example:

```SQL
INSERT INTO <Table Name> (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000);
```