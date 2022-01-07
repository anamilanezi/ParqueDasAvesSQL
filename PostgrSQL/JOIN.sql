-- Consulta Utilizando INNER JOIN:
-- Seleciona espécies criticamente ameaçadas, espécies em perigo e vulneráveis, classifica em ordem ASC. 

SELECT
	especies_colecao.nome_comum,
	especies_colecao.especie,
	especies_colecao.status_conservacao,
	categorias_conservacao.legenda_status
FROM especies_colecao
JOIN categorias_conservacao
	ON especies_colecao.status_conservacao = categorias_conservacao.id_status
WHERE status_conservacao IN ('CR', 'EN', 'VU')
ORDER BY status_conservacao;
