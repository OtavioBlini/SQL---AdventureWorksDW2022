USE AdventureWorksDW2022;

-- Estátisticas Básicas
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) OVER () AS Mediana
    FROM FactInternetSales
)
SELECT
    COUNT(*) AS Total_registros,
    SUM(SalesAmount) AS Soma,
	(SELECT Mediana FROM MedianaCTE) AS Mediana, -- Inserção da CTE
    AVG(SalesAmount) AS Media,
    MIN(SalesAmount) AS Valor_minimo,
    MAX(SalesAmount) AS Valor_maximo,
    ROUND(STDEVP(SalesAmount), 2) AS Desvio_Padrao,
    ROUND(VARP(SalesAmount), 2) AS Variancia,
    MAX(SalesAmount) - MIN(SalesAmount) AS Amplitude
FROM FactInternetSales;

-- Distribuição ao longo do tempo.
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE(Ano, Mediana) AS (
	SELECT DISTINCT
		YEAR(OrderDate) AS Ano,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) 
			OVER (PARTITION BY YEAR(OrderDate)) AS Mediana -- Criar partições por ano
	FROM FactInternetSales
)
SELECT
	Ano,
	COUNT(*) AS Total_registros,
	SUM(S.SalesAmount) AS Soma,
	M.Mediana AS Mediana, -- Inserção da CTE
	AVG(S.SalesAmount) AS TicketMédio,
	MIN(S.SalesAmount) AS TicketMinímo,
	MAX(S.SalesAmount) AS TicketMaximo,
	ROUND(STDEVP(S.SalesAmount), 2) AS Desvio_Padrão,
	ROUND(VARP(S.SalesAmount), 2) AS Variância,
	MAX(S.SalesAmount) - MIN(S.SalesAmount) AS Amplitude
FROM FactInternetSales S
JOIN MedianaCTE M ON YEAR(S.OrderDate) = M.Ano
GROUP BY Ano, M.Mediana
ORDER BY Ano;