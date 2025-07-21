/*
 3.1
 The school district superintendent asks for a list of teachers in each school. Write a
 query that lists the schools in alphabetical order along with teachers ordered by last
 name A–Z.
 */
SELECT
  school,
  last_name,
  first_name
FROM
  teachers
ORDER BY
  -- ASC by default
  school,
  last_name;

/*
 3.2
 Write a query that finds the one teacher whose first name starts with the letter S and
 who earns more than $40,000.
 */
SELECT
  first_name,
  last_name,
  salary
FROM
  teachers
WHERE
  first_name LIKE 'S%'
  AND salary > 40000;

/*
 3.3
 Rank teachers hired since January 1, 2010, ordered by highest paid to lowest.
 */
SELECT
  last_name,
  first_name,
  hire_date,
  salary
FROM
  teachers
WHERE
  hire_date >= '01-01-2010'
ORDER BY
  salary DESC, last_name ASC;
