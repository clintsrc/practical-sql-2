# Table Design

Organization and consistency help with efficiency

## Naming Convention

Determine your org's naming convention, otherwise be consistent in your own projects:

- camelCase
- PascalCase
- snake_case

### Case sensitivity

Postgres defaults to lowercase. Use qotes if you need specific case, but it's best practice to avoid it:

```SQL
CREATE TABLE "Customers" (
  ...
);

SELECT * FROM "Customers";
```

### Use Plurals for Table Names

Since talbles have multiple rows, it's more natural to use plurals (students, managers, etc.)

### Sensible Descriptor Length

Descriptive names are helpful, but keep the lengh within reason. Each RDBMS has a maximum descriptor length

### Copies of Tables

If you're making a copy / backup of a table, add the date to help you identify it long after you've created it (name_YYYY_MM_DD), and to help with sorting them.