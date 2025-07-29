/*
 6.1
 Write a SQL statement for calculating the area of a circle whose radius is 5
 inches. (If you don’t remember the formula, it’s an easy web search.) Do you need
 parentheses in your calculation? Why or why not?
 */
SELECT
  PI() * (5 ^ 2) AS area_of_radius_5;

/*
 6.2
 Using the 2019 US Census county estimates data, calculate a ratio of births to deaths
 for each county in New York state. Which region of the state generally saw a higher
 ratio of births to deaths in 2019?
 */
SELECT
  state_name,
  county_name,
  births_2019 AS births,
  deaths_2019 AS deaths,
  region,
  CAST(births_2019 AS numeric) / deaths_2019 AS birth_death_ratio
FROM
  us_counties_pop_est_2019
WHERE
  state_name = 'New York'
  AND deaths_2019 > 0
ORDER BY
  birth_death_ratio DESC;

/*
 6.3
 Was the 2019 median county population estimate higher in California or New York?
 */
SELECT
  state_name,
  percentile_cont(0.5) WITHIN GROUP (
    ORDER BY
      pop_est_2019
  ) as median_population
FROM
  us_counties_pop_est_2019
WHERE
  state_name = 'New York'
  OR state_name = 'California'
GROUP BY
  state_name;

/*
Output:

"state_name","median_population"
"California","187029"
"New York","86687"
*/