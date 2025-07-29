# Math and Stats

- Postgres is often ahead of the ANSI standard. You'll often see deprecated items after ANSI replaces a postgres implementation
- Order of precedence
  - (): group to override precedence
  - ^ |/ exponents, roots
  - \* / %: multiply, divide, modulo
  - \+ \-: add, subtract

## Types

Math results for numbers have rules according to the type they return: you may need to use CAST()

You can view the operators and their return types by viewing the built-in pg_operator table

```SQL
SELECT * FROM pg_operator
```

## Basics

You can work with the operators directly (without using a table).

```SQL
SELECT 2 + 2;
SELECT 9 - 1;
SELECT 3 * 4;
```

### AS label

The default (unknown) column header is labeled '?column?', but you can use AS to assign one

```SQL
SELECT 2 + 2 AS sum_total;
```

### Division and Modulo

#### Integer division

```SQL
SELECT 11 / 6; -- returns 1 (whole number only: it drops the remainder)
SELECT 11 % 6; -- returns 5 (remainder number only: it drops the integer)
SELECT CAST(11 AS numeric(3,1)) / 6; -- returns 1.833...by forcing decimal division with CAST()
```

#### Decimal division

```SQL
SELECT 11.0 / 6; -- returns 1.833...
```

#### Modulo as a test condition

```SQL
-- Using modulo to divide a number by 2:
-- A 0 remainder means it's even. A non-zero remainder means it's odd
SELECT
  CASE
    WHEN 12 % 2 = 0 THEN 'Even'
    ELSE 'Odd'
  END AS result;
```

### More Math Operators

```SQL
SELECT 2 ^ 3; -- exponent
SELECT |/ 10; -- square root (postgres-specific)
SELECT sqrt(10); -- square root (ANSI)
SELECT ||/ 10;        -- cube root (postgres-specific)
SELECT factorial(4);  -- factorial (ANSI), especially to calculate possible combinarions
--SELECT 4 !;           -- factorial (operator; PostgreSQL <= v13 only)
```

## Calculations On Column Data

Example shows subtracting 2 columns (births_2019 - deaths_2019) and displayign the total in a new column with an alias heading (AS natural_increase)

```SQL
SELECT
  county_name AS county,
  state_name AS state,
  births_2019 AS births,
  deaths_2019 AS deaths,
  -- Subtract 2 columns and display result in a new column with an alias heading
  births_2019 - deaths_2019 AS natural_increase
FROM
  us_counties_pop_est_2019
ORDER BY
  state_name, county_name;
```

### Data Validation

This example ensures that the data is valid by ensuring that the calculation of the difference alway balances to 0

```SQL
SELECT
  county_name AS county,
  state_name AS state,
  pop_est_2019 AS pop,
  pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019 AS components_total,
  pop_est_2019 - (
    pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019
  ) AS difference
FROM
  us_counties_pop_est_2019
ORDER BY
  difference DESC;  -- first and last record should be 0
```

```text
"county","state","pop","components_total","difference"
"Baldwin County","Alabama",223234,223234,0
"Barbour County","Alabama",24686,24686,0
"Bibb County","Alabama",22394,22394,0
...
```

## Understanding the Data

### Percentages of the Whole

```text
Formula:
n / Total

Example: 9 of 12
9 / 12 == 0.75 == %75
```

```SQL
SELECT
  COUNTY_NAME AS COUNTY,
  STATE_NAME AS STATE,
  -- Cast to int using area_water::"numeric" (postgres-specific)
  area_water::"numeric" / (area_land + area_water) * 100 AS pct_water
FROM
  US_COUNTIES_POP_EST_2019
ORDER BY
  pct_water DESC;
```

### Percent Change

How much a number is greater or smaller than another. Uses include

- show change over time
- compare similar items

```text
Formula:
(new number - old number) / old number

Example: 73 items were sold today, 59 items yesterday
(73 - 59) / 59 == .237 == %23.7
```

### Aggregate Functions (sum(), avg())

Calculate result from multiple values in the same column

ref [Aggregate Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)

```text
Examples:
avg(n), sum(n)
```

Example using sum(), avg() (and round())

```SQL
SELECT
  sum(pop_est_2019) AS county_sum,
  round(avg(pop_est_2019), 0) AS county_average
FROM
  us_counties_pop_est_2019;
```

### Median (Middle Value)

NOTE: Median requires the data to be sorted

Is the average skewed (by an exceptionally large or small data entry -- outlier)? Soln is to find the median instead

Median: the point where half are more and half are less.

- If the median position is even, take the average of the two middle numbers

#### Average or Median?

Calculate the average and median for a group of numbers. If they're close, it's probably a normal distribution, you can probably use the average.

#### Percentile Functions

Median and percentiles are a little like the position in a range (address in an array), rather than the values.

```text
Here are grades for 10 students:
60, 65, 70, 75, 80, 85, 90, 95, 98, 100
What score is at the 50th percentile?
50% of 10 students = position 5.5, halfway between 5th (score 80) and 6th student (score 85)
Position 5.5 would be: 82.5 (halfway between 80 and 85)
```

```percentile_disc(n)```: "discrete values." Picks a value from the sorted data that is at or just past the nth percentile.
```percentile_cont(n)```: "continuous values." Calculates the exact percentile value, possibly between values.

```text
Given: 1, 2, 3, 4, 5, 6
percentile_disc(.5) == 3. Selects the value at the median poistion, ceil(n × N).
   Calculate position = ceil(n × N)
   n = 0.5, N = 6
   ceil(0.5 × 6) = ceil(3) = 3
percentile_cont(.5) == 3.5. Calculates the exact median.
```

The query would look like this, note the WITHIN GROUP on the ordered numbers:

```SQL
SELECT
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;
```

#### Slicing Data into Smaller Equal Groups (Quartiles, Quintiles, etc.)

Use ```percentile_cont()```

Example:

```text
To find the value marking the first quartile or the lowest 25 percent of data by passing an array of values
```

```SQL
SELECT percentile_cont(ARRAY[.25,.5,.75])
       WITHIN GROUP (ORDER BY pop_est_2019) AS quartiles
FROM us_counties_pop_est_2019;
```

Note the output display for arrays is in braces ```{value/s}``

``` text
quartiles
------------------------
{10902.5,25726,68072.75}
```

#### Arrays

ref: [Arrays](https://www.postgresql.org/docs/current/arrays.html), [Array Functions](https://www.postgresql.org/docs/current/functions-array.html)

Example using the array function, ```unnest()``` to flatten the array output from columns to a single row

```SQL
SELECT
  unnest(
    percentile_cont(ARRAY [.25,.5,.75]) WITHIN GROUP (
      ORDER BY
        pop_est_2019
    )
  ) AS quartiles
FROM
  us_counties_pop_est_2019;
```

```text
quartiles
---------
10902.5 25726 68072.75
```

#### Mode

Mode: the most frequently occuring value, use Postgres-specific function ```mode()```

```SQL
SELECT
  mode() WITHIN GROUP (
    ORDER BY
      births_2019
  )
FROM
  us_counties_pop_est_2019;
```
