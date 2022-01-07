-- Cria tabela com lista de espécies do Parque .          


CREATE TABLE especies_colecao (
	id_especie serial PRIMARY KEY,                     -- Identificação do animal (FICTÍCIA)
	nome_comum varchar(50),                            -- Nome comum
	id_setor varchar(3),	                           -- Identificação do setor
	especie varchar(50),                               -- Nome científico
	familia varchar(30),                               -- Família
	ordem varchar(30),                                 -- Ordem 
	classe varchar(30),                                -- Classe 
	origem varchar(10),                                -- Origem (nativa ou exotica)
	status_conservacao varchar(2)                      -- Sigla status de conservação IUCN (FG KEY)

);


-- Criar tabela setores 

CREATE TABLE setores_parque (
	id_setor varchar(3) PRIMARY	KEY,                   --Código de identificação (FICTÍCIO) dos setores do parque
	nome_setor varchar(30)                             --Nome do setor 
);


-- Cria tabela categorias de conservação

CREATE TABLE categorias_conservacao (
	id_status varchar(2) PRIMARY KEY,                  --Sigla status de conservação IUCN
	legenda_status varchar(25)                         --Legenda do status de conservação
);

-- Cria tabela de indivíduos

CREATE TABLE individuos (
	id_individuo serial PRIMARY KEY,                   -- Identificação do animal 
	id_especie integer,                                -- Identificação da espécie (FG KEY)
	id_setor varchar(3)                                -- Identificação do setor (FG KEY)
	data_nascimento date,                              -- Data de nascimento real ou estimado
	data_entrada date,                                 -- Data de admissão no parque
	peso numeric(6,2),                                 -- Peso
	sexo varchar(1)                                    -- Sexo


);

-- NOTAS:
-- Tabelas para criar: Funcionários, Remédios, Alimentos, 