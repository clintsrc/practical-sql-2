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
/*
 5.2
 Using the table us_counties_pop_est_2019 you created and filled in this chapter,
 export to a CSV file the 20 counties in the United States that had the most births.
 Make sure you export only each county’s name, state, and number of births.
 (Hint: births are totaled for each county in the column births_2019.)
 */
/*
 5.3
 Imagine you’re importing a file that contains a column with these values:
 17519.668
 20084.461
 18976.335
 Will a column in your target table with data type numeric(3,8) work for these
 values? Why or why not?
 */
 