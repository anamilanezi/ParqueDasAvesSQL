-- 5.1: Write a SQL statement for calculating the area of a circle 
-- whose radius is 5 inches. Do you need parentheses?

SELECT 3.14 * 5 ^ 2 AS area_do_circulo;      		-- Não precisa parenteses pois obedece a ordem de expressões numéricas 

-- Calcular perímetro do círculo

SELECT 2 * 3.14 * 5 AS perimetro_do_circulo;

-- Using the 2010 Census county data, find out which New York state 
-- county has the highest percentage of the population that identi-
-- fied as "American Indian/Alaska Native Alone"

SELECT *
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY';        

SELECT geo_name AS "County",
	   state_us_abbreviation AS "State",
	   p0010001 AS "Total Population",
       p0010005 AS "Am Indian/Alaska Native Alone",
       (CAST (P0010005 AS numeric(8,3)) / p0010001) * 100 AS "AI/AN Percentage"
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY "AI/AN Percentage" DESC;


-- Was the median county population higher in CA or NY?

SELECT state_us_abbreviation AS "State",					     -- Sem selecionar e agrupar essa coluna, 	 
	   percentile_cont(.5)										 -- calcula uma mediana para os dois estados
	   WITHIN GROUP (ORDER BY p0010001) AS "County Median"
FROM us_counties_2010
WHERE state_us_abbreviation IN ('NY', 'CA')
GROUP BY "State";													-

SELECT state_us_abbreviation,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY p0010001) AS median
FROM us_counties_2010
GROUP BY state_us_abbreviation;                                -- Sem os filtros e sem agrupar, mediana para todos os estados.