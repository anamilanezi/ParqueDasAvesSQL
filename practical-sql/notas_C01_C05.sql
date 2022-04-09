-- CAPÍTULO 01: CRIAR BASE DE DADOS, TABELA, INSERIR DADO NA TABELA, BOAS PRÁTICAS DE ESCRITA

-- CAPÍTULO 02: FAZENDO CONSULTAS COM SELECT, ORDER BY, WHERE, OPERADORES LÓGICOS

-- EXEMPLOS DE OPERADORES DE COMPARAÇÃO EM WHERE 

-- Professores com o primeiro nome Janet (=)
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

-- Escolas com nome diferente de F.D. Roosevelt HS (!=) 
SELECT school
FROM teachers
WHERE school != 'F.D. Roosevelt HS';

-- Professores contratados antes de Jan. 1, 2000  ( antes < data, depois > data )
SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

-- Professores que ganham 43500 ou mais
SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

-- Professores que ganham entre 40000 e 65000 (coluna BETWEEN valor1 AND valor2)
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;

-- FILTRANDO RESULTADOS COM LIKE E ILIKE

SELECT first_name
FROM teachers
WHERE first_name LIKE 'sam%'; 			-- LIKE é sensível à capitalização, procura com nomes que iniciam com "sam" seguidos de qualquer sequência de caracteres

SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';			-- ILIKE é uma função de PostgreSQL que não é sensível a capitalização.

-- COMBINANDO OS OPERADORES AND E OR

SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
      AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
      OR last_name = 'Bush';

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
      AND (salary < 38000 OR salary > 40000);

-- EXEMPLO DE SELECT USANDO WHERE, LIKE E ORDER BY
SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;


--EXEMPLOS DE DADOS TIPO CHAR/STRING

CREATE TABLE char_data_types ( 
    varchar_column varchar(10),
    char_column char(10),
    text_column text
);

INSERT INTO char_data_types
VALUES
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');				-- Arquivo mostra que o tipo CHAR utiliza todo espaço dos 10 caracteres especificados
    									-- enquanto o varchar e text utilizam somente o espaço de caracteres que foi inserido 				
COPY char_data_types TO 'C:\YourDirectory\typetest.txt'     	-- havendo limite de 10 em varchar e sem limite em text. 	
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- EXEMPLOS DE DADOS NUMÉRICOS   -  ALGUNS EXEMPLOS TIVERAM 
-- RESULTADOS DIFERENTES DOS APRESENTADOS NO LIVRO, REVISAR 
-- ESSA MATÉRIA COM CONTEÚDO ATUALIZADO! 

CREATE TABLE number_data_types (
    numeric_column numeric(20,5),
    real_column real,
    double_column double precision
);

INSERT INTO number_data_types
VALUES
    (.7, .7, .7),
    (2.13579, 2.13579, 2.13579),
    (2.1357987654, 2.1357987654, 2.1357987654);

SELECT * FROM number_data_types;

-- Problemas no arredondamento utilizando dados float
-- Assumes table created and loaded with Listing 3-2

SELECT
    numeric_column * 10000000 AS "Fixed",
    real_column * 10000000 AS "Float"
FROM number_data_types
WHERE numeric_column = .7;

-- TIMESTAMP E INTERVALO DE TEMPO

CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,          -- Registra horário de acordo com o fuso
    interval_column interval
);

INSERT INTO date_time_types
VALUES
    ('2018-12-31 01:00 EST','2 days'),
    ('2018-12-31 01:00 PST','1 month'),
    ('2018-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

SELECT * FROM date_time_types;

-- USANDO O TIPO DE DADO INTERVALO PARA CALCULAR UMA NOVA DATA
-- Assumes script 3-4 has been run

SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date      -- Nova coluna diminui o intervalo da data com timestamp e produz uma nova coluna com timestamp
FROM date_time_types;

-- CAST PARA CONVERTER UM TIPO DE DADO PARA OUTRO:
SELECT timestamp_column, CAST(timestamp_column AS varchar(10))    -- Converter de timestamp para varchar
FROM data_time_types;

SELECT numeric_column,
	CAST(numeric_column AS integer),
	CAST(numeric_column AS varchar(6))
FROM number_data_types;

SELECT CAST(char_column AS integer) FROM char_data_types;

-- CAPÍTULO 4: CSV, COPY PARA IMPORTAR E EXPORTAR, ESCOLHER 
-- SUBCONJUNTO DE COLUNAS PARA IMPORTAR, ADICIONAR UM VALOR
-- À UMA COLUNA ENQUANTO IMPORTA DADOS (TABELA TEMPORÁRIA)

-- IMPORTAR VALORES DE UMA TABELA CSV ESPECIFICANDO AS COLUNAS

COPY supervisor_salaries (town, supervisor, salary)
FROM 'supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- Exportar a tabela somente com algumas colunas e filtro de informações --

COPY (
	SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent
	FROM us_counties_2010
	ORDER BY housing_unit_count_100_percent DESC
	LIMIT 20)
TO 'us_housing_unit.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- CAPÍTUO 5: MATEMÁTICA BÁSICA E ESTATÍSTICA - OPERADORES MATEMÁTICOS
-- CÁLCULOS, FUNÇÕES AGREGADAS, MEDIANA, MODO

-- OPERADORES MATEMÁTICOS DIVISÃO E MÓDULO

SELECT 11 / 6; --resulta no quociente
SELECT 11 % 6; --resuta no resto, útil para testar números pares
SELECT 11.0 / 6;
SELECT CAST (11 AS numeric(3,1)) / 6;

--OPERADORES DE EXPONENCIAÇÃO, RAIZ E FATORIAL EM POSTRGRE
SELECT 3 ^ 4;  --exponenciação
SELECT |/ 10; -- raiz quadrada
SELECT sqrt(10); --raiz quadrada
SELECT ||/ 10; --raiz cúbica
SELECT 4 !;

--ALTERAR NOME DAS COLUNAS DA TABELA us_counties_2010

SELECT geo_name,
       state_us_abbreviation AS "st",
       p0010001 AS "Total Population",
       p0010003 AS "White Alone",
       p0010004 AS "Black or African American Alone",
       p0010005 AS "Am Indian/Alaska Native Alone",
       p0010006 AS "Asian Alone",
       p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
       p0010008 AS "Some Other Race Alone",
       p0010009 AS "Two or More Races"
FROM us_counties_2010;

--Calcular com dados das colunas exibidas e cria nova coluna com o resultado

SELECT geo_name,
	state_us_abbreviation AS "st",
	p0010003 AS "White Alone",
	p0010004 AS "Black Alone",
	p0010003 + p0010004 AS "Total White and Black"        -- realiza o cálculo linha por linha, 
FROM us_counties_2010;

--TESTAR SE COLUNAS FORAM IMPORTADAS CORRETAMENTE CALCULANDO O TOTAL POR RAÇA

SELECT geo_name,
	state_us_abbreviation AS "st",
	p0010001 AS "Total",
	p0010003 + p0010004 + p0010005 + p0010006 + p0010007 
	+ p0010008 + p0010009 AS "All Races",
	(p0010003 + p0010004 + p0010005 + p0010006 + p0010007 
	+ p0010008 + p0010009) - p0010001 AS "Difference"
FROM us_counties_2010
ORDER BY "Difference" DESC;

--DESCOBRIR A PORCENTAGEM DE PESSOAS QUE REPORTOU RAÇA ASIÁTICA NO CENSO

SELECT geo_name, state_us_abbreviation AS "st",
	(CAST (P0010006 AS numeric(8,1)) / p0010001) * 100 AS "pct_asian"    -- Converter um valor para numeric força resultado a ser desse tipo
FROM us_counties_2010
ORDER BY "pct_asian" DESC;

--CÁLCULO DE MUDANÇA DE % AO LONGO DO TEMPO: (novo valor - antigo valor) / antigo valor (*100 para transformar em %)

CREATE TABLE percent_change (
	department varchar(20),
	spend_2014 numeric(10,2),
	spend_2017 numeric(10,2)
);

INSERT INTO percent_change
VALUES
	('Building', 250000, 289000),
    ('Assessor', 178556, 179500),
    ('Library', 87777, 90001),
    ('Clerk', 451980, 650000),
    ('Police', 250000, 223000),
    ('Recreation', 199000, 195000);

SELECT department,
	spend_2014,
	spend_2017,
	round( (spend_2017 - spend_2014) /
		spend_2014 * 100, 1) AS "pct_change"
FROM percent_change;

--FUNÇÕES AGREGADAS PARA SOMAR VALORES EM COLUNAS

SELECT sum(p0010001) AS "County Sum",
	round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;

-- CONSULTAS ALEATÓRIAS PARA PRATICAR

SELECT geo_name AS "County",
	p0010003 AS "White Alone",
	p0010004 AS "Black or African American Alone",
	p0010001 AS "Total population",
	((CAST (sum(p0010003) + sum(p0010004) AS numeric(8,1))) / p0010001) * 100 AS "Black and white %"
FROM us_counties_2010
GROUP BY "County", "White Alone", "Black or African American Alone", "Total population"
ORDER BY "Black and white %";

SELECT geo_name AS "County",
	p0010003 AS "White Alone",
	p0010004 AS "Black or African American Alone",
	p0010001 AS "Total population",
	(ROUND (((CAST (sum(p0010003) + 
					sum(p0010004) AS numeric(8,1))) 
			 			/ p0010001) * 100), 3)AS "Black and white %"
FROM us_counties_2010
GROUP BY "County", "White Alone", "Black or African American Alone", "Total population"
ORDER BY "Black and white %";

-- CALCULANDO A MEDIANA ATRAVÉS DA FUNÇÃO PERCENTILE

-- Em estatística, os percentis indicam o ponto em um conjunto ordenado 
-- de dados abaixo do qual uma certa porcentagem dos dados é encontrada.
-- A MEDIANA equivale ao percentil 50% ou 0.5 

CREATE TABLE percentile_test ( numbers integer);

INSERT INTO percentile_test (numbers)
VALUES (1), (2), (3), (4), (5), (6);

SELECT percentile_cont(.5)					-- Resultado é 3.5
	WITHIN GROUP (ORDER BY numbers),           
	percentile_disc(.5)					-- Resultado é 3, o último valor no primeiro 50 percentil dos números.
	WITHIN GROUP (ORDER BY numbers) 
FROM percentile_test

-- MEDIANA ATRAVÉS DO PERCENTILE NA TABELA us_counties_2010
-- Como a mediana pode contar uma história diferente que a média:

SELECT sum(p0010001) AS "County Sum",
	round(avg(p0010001), 0) AS "County Average",           	-- Média é igual a 98233
	percentile_cont(.5)
	WITHIN GROUP (ORDER BY p0010001) AS "County Median"	-- Mediana é igual a 25857
FROM us_counties_2010;

-- ENCONTRAR OUTRAS PORÇÕES USANDO PERCENTIL
-- Dados podem ser fatiados em grupos menores equivalentes.
-- Função é utilizada com um array para delimitar as porções

SELECT percentile_cont(array[.25, .5, .75])			-- Array é um construtor, 
	WITHIN GROUP (ORDER BY p0010001) AS "quartiles"         -- Resultados: {11104.5, 25857, 66699} (também é um array)
FROM us_counties_2010;

-- Mesmo query mas usando a função unnest para exibir os resultados em linhas separadas

SELECT unnest(							-- Separa valores em linhas diferentes
	percentile_cont(array[.25, .5, .75])			-- Array é um construtor, 
	WITHIN GROUP (ORDER BY p0010001) 
	) AS "quartiles"         					-- Resultados: {11104.5, 25857, 66699 em três linhas separadas
FROM us_counties_2010;

SELECT unnest(							-- Separa valores em linhas diferentes
	percentile_cont(array[.1,.2,.3,.4,.5,.6,.7,.8,.9])	-- Array é um construtor, 
	WITHIN GROUP (ORDER BY p0010001) 
	) AS "deciles"         					
FROM us_counties_2010;


-- Script para criar uma função agregada no pgAdmin4 para cálculo da mediana -- DEU ERRO
-- Basicamente, sendo um scrip específico para PostgreSQL, é melhor aprender pelo método
-- percentile que é padrão

-- ENCONTRANDO O MODO (valor que aparece com mais frequência)

SELECT mode() WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010;						-- Resultado é 21720
