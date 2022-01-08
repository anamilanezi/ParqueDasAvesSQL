--Copia informações de espécies do arquivo CSV armazenado no diretório

COPY especies_colecao (
	nome_comum, 
	id_setor, 
	especie,
	genero, 
	familia, 
	ordem, 
	classe, 
	origem, 
	status_conservacao)
FROM 'C:\...\especies_colecao.csv'
WITH (FORMAT CSV, HEADER);

--Copia informações de setores do parque arquivo CSV armazenado no diretório

COPY setores_parque
FROM 'C:\...\setores_parque.csv'
WITH (FORMAT CSV, HEADER);

--Copia informações do arquivo CSV com categorias de conservação armazenado no diretório

COPY categorias_conservacao
FROM 'C:\...\categorias_conservacao.csv'
WITH (FORMAT CSV, HEADER);