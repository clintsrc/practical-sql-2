/*
 7.1
 Q: According to the census population estimates, which county had the greatest
 percentage loss of population between 2010 and 2019? Try an internet search to find
 out what happened. (Hint: The decrease is related to a particular type of facility.)
 
 A: Summary:
 
 County with greatest percentage decline (2010–2019): Concho County, Texas
 
 Cause: Closure of a major prison facility → removal of institutional residents and
 associated jobs → steep population loss
 */
SELECT
  c2019.county_name,
  c2019.state_name,
  c2019.pop_est_2019 AS pop_2019,
  c2010.estimates_base_2010 AS pop_2010,
  c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
  round(
    (
      c2019.pop_est_2019 :: numeric - c2010.estimates_base_2010
    ) / c2010.estimates_base_2010 * 100,
    1
  ) AS pct_change
FROM
  us_counties_pop_est_2019 AS c2019
  JOIN us_counties_pop_est_2010 AS c2010 ON c2019.state_fips = c2010.state_fips
  AND c2019.county_fips = c2010.county_fips
ORDER BY
  pct_change ASC;

/*
 7.2
 Apply the concepts you learned about UNION to create query results that merge queries
 of the census county population estimates for 2010 and 2019. Your results should
 include a column called year that specifies the year of the estimate for each row in
 the results.
 */
SELECT
  '2010' AS year,
  state_fips,
  county_fips,
  county_name,
  state_name,
  estimates_base_2010 AS estimate
FROM
  us_counties_pop_est_2010
UNION
SELECT
  '2019' AS year,
  state_fips,
  county_fips,
  county_name,
  state_name,
  pop_est_2019 AS estimate
FROM
  us_counties_pop_est_2019
ORDER BY
  state_fips,
  county_fips,
  year;

/*
 7.3
 Using the percentile_cont() function from Chapter 6, determine the median of the
 percent change in estimated county population between 2010 and 2019.
 */
SELECT
  percentile_cont(.5) WITHIN GROUP (
    -- group the calcluation
    ORDER BY
      round(
        (
          c2019.pop_est_2019 :: numeric - c2010.estimates_base_2010
        ) / c2010.estimates_base_2010 * 100,
        1
      )
  ) AS percentile_50th -- update the header
FROM
  us_counties_pop_est_2019 AS c2019
  JOIN us_counties_pop_est_2010 AS c2010 ON c2019.state_fips = c2010.state_fips
  AND c2019.county_fips = c2010.county_fips;