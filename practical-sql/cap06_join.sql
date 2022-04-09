--------------------------------------------------------------
-- Chapter 6: Joining Tables in a Relational Database
--------------------------------------------------------------

-- 1. The table us_counties_2010 contains 3,143 rows, and us_counties_2000 has
-- 3,141. That reflects the ongoing adjustments to county-level geographies that
-- typically result from government decision making. Using appropriate joins and
-- the NULL value, identify which counties don't exist in both tables. For fun,
-- search online to  nd out why they’re missing

-- Condados que existiam em 2000 deixaram de existir em 2010

SELECT c2000.geo_name,
	c2000.state_us_abbreviation AS state,
	C2010.geo_name
FROM us_counties_2000 AS c2000 LEFT JOIN us_counties_2010 AS c2010
	ON c2000.county_fips = c2010.county_fips
	AND c2000.state_fips = c2010.state_fips
WHERE c2010.geo_name IS NULL

-- Condados que existiam foram fundados entre 2000 e 2010 

SELECT c2010.geo_name,
       c2010.state_us_abbreviation,
       c2000.geo_name
FROM us_counties_2010 c2010 LEFT JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
WHERE c2000.geo_name IS NULL;

-- 2. Using either the median() or percentile_cont() functions in Chapter 5,
-- determine the median of the percent change in county population.

SELECT percentile_cont(.5)
	WITHIN GROUP (ORDER BY round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)     
		/ c2000.p0010001 * 100, 1)) AS percentile_median
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
	ON c2010.state_fips = c2000.state_fips
		AND c2010.county_fips = c2000.county_fips;  	


-- 3. Which county had the greatest percentage loss of population between 2000
-- and 2010? Do you have any idea why? Hint: a weather event happened in 2005.

SELECT c2010.geo_name,
	c2010.state_us_abbreviation,
	c2010.p0010001 AS "Population 2010",
	c2000.p0010001 AS "Population 2000",
	c2010.p0010001 - c2000.p0010001 AS "Raw Change",
	round((CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001) / c2000.p0010001 * 100, 1) AS loss_pop     -- nova menos velha dividido por velha
FROM us_counties_2010 AS c2010 INNER JOIN us_counties_2000 AS c2000
	ON c2010.state_fips = c2000.state_fips
		AND c2010.county_fips = c2000.county_fips
ORDER BY loss_pop DESC; 	