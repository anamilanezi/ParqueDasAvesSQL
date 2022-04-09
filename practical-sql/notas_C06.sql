--------------------------------------------------------------
-- CAPÍTULO 6: JUNTANDO TABELAS EM UM BANCO DE DADOS RELACIONAL
--------------------------------------------------------------

CREATE TABLE departments (
	dept_id bigserial,
	dept varchar(100),
	city varchar(100),
	CONSTRAINT dept_key PRIMARY KEY (dept_id),
	CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
	emp_id bigserial,
	first_name varchar(100),
	last_name varchar(100),
	salary integer,
	dept_id integer REFERENCES departments (dept_id),
	CONSTRAINT emp_key PRIMARY KEY (emp_id),
	CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

INSERT INTO departments (dept, city)
VALUES 
	('Tax', 'Atlanta'),
	('IT', 'Boston');

INSERT INTO employees (first_name, last_name, salary, dept_id)
VALUES 
	('Nancy', 'Jones', 62500, 1),
	('Lee', 'Smith', 59300, 1),
	('Soo', 'Nguyen', 83000, 2),
	('Janet', 'King', 95000, 2);

SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id;

-- Criando tabela com censo 2000

CREATE TABLE us_counties_2000 (
    geo_name varchar(90),              -- County/state name,
    state_us_abbreviation varchar(2),  -- State/U.S. abbreviation
    state_fips varchar(2),             -- State FIPS code
    county_fips varchar(3),            -- County code
    p0010001 integer,                  -- Total population
    p0010002 integer,                  -- Population of one race:
    p0010003 integer,                      -- White Alone
    p0010004 integer,                      -- Black or African American alone
    p0010005 integer,                      -- American Indian and Alaska Native alone
    p0010006 integer,                      -- Asian alone
    p0010007 integer,                      -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,                      -- Some Other Race alone
    p0010009 integer,                  -- Population of two or more races
    p0010010 integer,                  -- Population of two races
    p0020002 integer,                  -- Hispanic or Latino
    p0020003 integer                   -- Not Hispanic or Latino:
);

COPY us_counties_2000
FROM 'us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

SELECT c2010.geo_name,
	c2010.state_us_abbreviation AS state,
	c2010.p0010001 AS pop_2010,
	c2000.p0010001 AS pop_2000,
	c2010.p0010001 - c2000.p0010001 AS raw_change,
	round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)    -- Arredonda/Muda tipo de dados/ Novo valor - velho valor 
		/ c2000.p0010001 * 100, 1 ) AS pct_change  											-- Dividido pelo velho valhor * 100 (converter pct)
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
	ON c2010.state_fips = c2000.state_fips
		AND c2010.county_fips = c2000.county_fips   										-- USA DUAS COLUNAS POIS PARA IDENTIFICAR PRECISA DA COMBINAÇÃO ÚNICA DAS DUAS
		AND c2010.p0010001 <> c2000.p0010001														-- Seleciona apenas quando a população apresentou diferença nos dois anos
	ORDER BY pct_change DESC;							

--------------------------------------------------------------
-- Chapter 7: Table Design that Works for You
--------------------------------------------------------------

CREATE TABLE natural_key_example (																	
	license_id varchar(10) CONSTRAINT license_key PRIMARY KEY,				-- Especifica a PK na definição da coluna, CONSTRAINT e o nome da PK podem
	first_name varchar(50),																						-- ser omitidos mas melhor utilizar pela redigibilidade 
	last_name varchar(50)
);

DROP TABLE natural_key_example;

CREATE TABLE natural_key_example (
	license_id varchar(10),
	first_name varchar(50),
	last_name varchar(50),
	CONSTRAINT license_key PRIMARY KEY (license_id)										-- Especifica a PK após criação das colunas, para quando existe mais de uma PK
);																																	-- Nome das colunas ficam especificadas dentro dos () e separa por vírgula	 

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Sam', 'Tracy')

-- Erro: ERROR:  duplicate key value violates unique constraint "license_key"
-- DETAIL:  Key (license_id)=(T229901) already exists.
-- SQL state: 23505

-- Example table for student attendance with a composite primary key

CREATE TABLE natural_key_composite_example (
	student_id varchar(10),
	school_day date,
	present boolean,
	CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/22/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES (775, '1/23/2017', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES (775, '1/22/2017', 'N');

-- ERROR:  duplicate key value violates unique constraint "student_key"
-- DETAIL:  Key (student_id, school_day)=(775, 2017-01-23) already exists.
-- SQL state: 23505

-- FOREIGN KEYS

CREATE TABLE licenses (
	license_id varchar(10),
	first_name varchar(50),
	last_name varchar(50),
	CONSTRAINT license_key PRIMARY KEY (license_id)																-- Tabela "mãe" da tabela registrations
);

CREATE TABLE registrations (														
	registration_id varchar(10),
	registration_date date,
	license_id varchar(10) REFERENCES licenses (license_id) ON DELETE CASCADE,		-- FK que se refere à licenses com comando para deletar registro 
	CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)					-- automaticamente quando algum license_id for deletado da tab. mãe
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Lynn', 'Malero');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '17/03/2017', 'T229901');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '17/03/2017', 'T000001');

-- ERROR:  insert or update on table "registrations" violates foreign key constraint "registrations_license_id_fkey"
-- DETAIL:  Key (license_id)=(T000001) is not present in table "licenses".
-- SQL state: 23503