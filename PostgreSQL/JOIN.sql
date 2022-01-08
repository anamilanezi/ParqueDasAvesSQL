-- Consulta Utilizando INNER JOIN:
-- Seleciona espécies criticamente ameaçadas, espécies em perigo e vulneráveis, classifica em ordem ASC. 

SELECT
	lista_especies.nome_comum,
	lista_especies.especie,
	lista_especies.status_conservacao,
	categorias_conservacao.legenda_status
FROM lista_especies
JOIN categorias_conservacao
	ON lista_especies.status_conservacao = categorias_conservacao.id_status
WHERE status_conservacao IN ('CR', 'EN', 'VU')
ORDER BY status_conservacao;
