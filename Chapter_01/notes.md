# Postgres Environment

## Install

### Postgres

- Creates a default 'postgres' database, and its default 'postgres' superuser account
- Prompts you to set the password for the default 'postgres' superuser

To create a nondefault superuser:

```bash
# Connect as a superuser
pgsql -U postgres

# Don't forget the closing ';'
postgres=# CREATE USER <username> SUPERUSER;
# For login access: CREATE ROLE <username> WITH LOGIN SUPERUSER PASSWORD '<password>';

# Confirm the user exists
postgres=# \du

# exit
postgres=# \q
```

### pgAdmin

- pgAdmin login credentials are tied to the OS user. The user is prompted to set thier pgAdmin credential, which is not a Postgres user credential
- pgAdmin user permissions to the Postgres databases is configured separately

#### View a Table

Servers | PostgresSQL <Version> | Databases | <DB Name> | Schemas | public | Tables

Right-click the table, View...

#### Run a Query

- UI: Tools | Query Tool
- Command line: Tools | PSQL Tool
  - Click the folder icon to open a .sql script

##### Postgres Version

```SQL
SELECT version();
```

#### Customization Examples

Be sure to Save changes:

- File | Preferences | Miscellaneous | User Interface | Themes: System
- File | Preferences | Query Tool | Results Grid | Maximum column width: 300
