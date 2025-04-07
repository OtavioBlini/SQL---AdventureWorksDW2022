USE AdventureWorksDW2022;

-- Análise temporal.
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE (mediana) AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) OVER () AS mediana
    FROM FactInternetSales
)
SELECT
    COUNT(*) AS produtos,
    SUM(SalesAmount) AS vendas,
	(SELECT Mediana FROM MedianaCTE) AS mediana, -- Inserção da CTE
	MIN(SalesAmount) AS ticket_minimo,
    AVG(SalesAmount) AS ticket_medio,
    MAX(SalesAmount) AS ticket_maximo,
    ROUND(STDEVP(SalesAmount), 2) AS desvio_padrao,
    ROUND(VARP(SalesAmount), 2) AS variancia,
    MAX(SalesAmount) - MIN(SalesAmount) AS amplitude
FROM FactInternetSales;

-- Distribuição ao longo do tempo.
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE (ano, mediana) AS (
	SELECT DISTINCT
		YEAR(OrderDate) AS ano,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) 
			OVER (PARTITION BY YEAR(OrderDate)) AS mediana -- Criar partições por ano
	FROM FactInternetSales
)
SELECT
	ano,
	COUNT(*) AS produtos,
	SUM(S.SalesAmount) AS vendas,
	M.Mediana AS Mediana, -- Inserção da CTE
	MIN(SalesAmount) AS ticket_minimo,
	AVG(S.SalesAmount) AS ticket_medio,
	MAX(S.SalesAmount) AS ticket_maximo,
	ROUND(STDEVP(S.SalesAmount), 2) AS desvio_padrao,
	ROUND(VARP(S.SalesAmount), 2) AS variancia,
	MAX(S.SalesAmount) - MIN(S.SalesAmount) AS amplitude
FROM FactInternetSales S
JOIN MedianaCTE M ON YEAR(S.OrderDate) = M.Ano
GROUP BY ano, M.mediana
ORDER BY ano;
