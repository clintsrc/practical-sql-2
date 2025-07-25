/*
 Continue your exploration of data import and export with these exercises.
 Remember to consult the PostgreSQL documentation
 at https://www.postgresql.org/docs/current/sql-copy.html for hints:
 */
/*
 5.1
 Write a WITH statement to include with COPY to handle the import of an imaginary
 text file whose first couple of rows look like this:
 id:movie:actor
 50:#Mission: Impossible#:Tom Cruise
 */
CREATE TABLE actors (id integer, movie text, actor text);

-- NOTE:
-- delimiter is ':' (... Impossible#:Tom... )
-- quotes are '#' (#Mission: Impossible#)
COPY actors
FROM
  '/tmp/actors.txt' WITH (FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');

/*
 5.2
 Using the table us_counties_pop_est_2019 you created and filled in this chapter,
 export to a CSV file the 20 counties in the United States that had the most births.
 Make sure you export only each county’s name, state, and number of births.
 (Hint: births are totaled for each county in the column births_2019.)
 */
-- Use select in the COPY TO parameter the export
COPY (
  SELECT
    county_name,
    state_name,
    births_2019
  FROM
    us_counties_pop_est_2019
  ORDER BY
    births_2019 DESC -- Most births
  LIMIT
    20 -- Top 20
)
TO '/tmp/most_births.csv' WITH (FORMAT CSV, HEADER);

/*
 5.3
 Q: Imagine you’re importing a file that contains a column with these values:
 17519.668
 20084.461
 18976.335
 Will a column in your target table with data type numeric(3,8) work for these
 values? Why or why not?

 A: No. The precision is specified as:
 numeric(<precision>,<scale>)
 Where 'precision' represents the total digits (8) and scale represents the decimal place (3), and so the parameters are reversed here.
  - numeric(3,8) should be numeric(8,3)
 */

