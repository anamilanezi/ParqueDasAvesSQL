--------------------------------------------------------------
-- Chapter 1: Creating Your First Database and Table
--------------------------------------------------------------

-- 1. Imagine you're building a database to catalog all the animals at your
-- local zoo. You want one table for tracking all the kinds of animals and
-- another table to track the specifics on each animal. Write CREATE TABLE
-- statements for each table that include some of the columns you need. Why did
-- you include the columns you chose?

CREATE TABLE lista_especies (
	id_especie serial PRIMARY KEY,                     -- Identificação do animal (FICTÍCIA)
	nome_comum varchar(50),                            -- Nome comum
	id_setor varchar(3),	                           -- Identificação do setor
	especie varchar(50),                               -- Nome científico 
	genero varchar(20),                                -- Gênero 
	familia varchar(30),                               -- Família
	ordem varchar(30),                                 -- Ordem 
	classe varchar(30),                                -- Classe 
	origem varchar(10),                                -- Origem (nativa ou exotica)
	status_conservacao varchar(2)                      -- Sigla status de conservação IUCN (FG KEY)

);


CREATE TABLE lista_animais (
	id_animal serial PRIMARY KEY,                				    -- Identificação do animal 
	id_especie int REFERENCES lista_especies (id_especie)         	-- Identificação da espécie (FG KEY)
	id_setor varchar(3)                                				-- Identificação do setor (FG KEY)
	data_nascimento date,                                           -- Data de nascimento real ou estimado
	data_entrada date,                                 				-- Data de admissão no parque
	peso_nascimento integer,                                 	    -- Peso EM GRAMAS	
	sexo varchar(1)                                    				-- Sexo

);

INSERT INTO lista_especies 
VALUES ('Gavião-real', 'A07', 'Harpia harpyja',	'Harpia', 'Accipitridae', 'Accipitriformes', 'Aves', 'nativa', 'VU')
	   ('Pé-vermelho', 'A04', 'Amazonetta brasiliensis', 'Amazonetta', 'Anatidae', 'Anseriformes', 'Aves', 'nativa', 'LC')
	   ('Marreca-toicinho'	'A09'	'Anas bahamensis'	'Anas'	'Anatidae'	'Anseriformes'	'Aves'	'nativa'	'LC');

INSERT INTO lista_animais
VALUES ('0001', 'A07', '2011-00-00', '2012-01-10', '7823', 'F')
	   ('0001', 'A07', '2014-02-03', '2014-02-03', '111', 'M')
	   ('0001', 'A07', '2014-02-03', '2014-02-03', '98', 'F')
	   ('0001', 'A07', '2014-02-03', '2014-02-03', '126', 'F')
	   ('0002', 'A04', '2012-05-06', '2012--05-06', '6530', 'M')

