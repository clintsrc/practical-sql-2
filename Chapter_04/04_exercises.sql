/*
 4.1
 Your company delivers fruit and vegetables to local grocery stores, and you need to
 track the mileage driven by each driver each day to a tenth of a mile. Assuming no
 driver would ever travel more than 999 miles in a day, what would be an appropriate
 data type for the mileage column in your table? Why?
 */
CREATE TABLE driver (
  -- NNN.N tracks up to 999.9. Four total digits, 1 decimal place for tenths
  numeric_column numeric(4, 1)
);

/*
 4.2
 In the table listing each driver in your company, what are appropriate data types
 for the drivers’ first and last names? Why is it a good idea to separate first and
 last names into two columns rather than having one larger name column?
 */
CREATE TABLE driver (
  first_name varchar(50),
  /* A separate last name:
   - keeps data discrete and easy to work with (e.g. alphabetize by last name)
   - prevents the need for a wasted separator character (like ' ' or ',')
   */
  last_name varchar(50),
  numeric_column numeric(4, 1)
);

/*
 4.3
 Q: Assume you have a text column that includes strings formatted as dates. One of the
 strings is written as '4//2021'. What will happen when you try to convert that string
 to the timestamp data type?
 
 A: Casting would fail because '//' can't be interpreted into any of the recognized
 time formats
 */