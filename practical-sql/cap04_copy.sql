-- 1. Write a WITH statement to include with COPY to handle the import of an
-- imaginary text file that has a first couple of rows that look like this:

-- id:movie:actor
-- 50:#Mission: Impossible#:Tom Cruise

-- Answer: The WITH statement will need the options seen here:

COPY movies
FROM 'C:\...'
WITH (FORMAT CSV, HEADER, DELIMITER ':')

COPY actors
FROM 'C:\YourDirectory\movies.txt'
WITH (FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');

-- 2. Using the table us_counties_2010 you created and filled in this chapter,
-- export to a CSV file the 20 counties in the United States that have the most
-- housing units. Make sure you export only each county's name, state, and
-- number of housing units. (Hint: Housing units are totaled for each county in
-- the column housing_unit_count_100_percent.)

COPY (
	SELECT geo_name AS county, state_us_abbreviation AS state, housing_unit_count_100_percent AS housing_units
	FROM us_counties_2010
	ORDER BY housing_units DESC 
	LIMIT 20
	)
TO 'counties_house_units.csv'
WITH (FORMAT CSV, HEADER);
