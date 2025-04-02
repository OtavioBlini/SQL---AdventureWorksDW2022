USE AdventureWorksDW2022;

-- Est�tisticas B�sicas
-- PERCENTILE_CONT � windows function requerindo uma CTE.
WITH MedianaCTE AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) OVER () AS Mediana
    FROM FactInternetSales
)
SELECT
    COUNT(*) AS Total_registros,
    SUM(SalesAmount) AS Soma,
	(SELECT Mediana FROM MedianaCTE) AS Mediana, -- Inser��o da CTE
    AVG(SalesAmount) AS Media,
    MIN(SalesAmount) AS Valor_minimo,
    MAX(SalesAmount) AS Valor_maximo,
    ROUND(STDEVP(SalesAmount), 2) AS Desvio_Padrao,
    ROUND(VARP(SalesAmount), 2) AS Variancia,
    MAX(SalesAmount) - MIN(SalesAmount) AS Amplitude
FROM FactInternetSales;

-- Distribui��o ao longo do tempo.
-- PERCENTILE_CONT � windows function requerindo uma CTE.
WITH MedianaCTE(Ano, Mediana) AS (
	SELECT DISTINCT
		YEAR(OrderDate) AS Ano,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) 
			OVER (PARTITION BY YEAR(OrderDate)) AS Mediana -- Criar parti��es por ano
	FROM FactInternetSales
)
SELECT
	Ano,
	COUNT(*) AS Total_registros,
	SUM(S.SalesAmount) AS Soma,
	M.Mediana AS Mediana, -- Inser��o da CTE
	AVG(S.SalesAmount) AS TicketM�dio,
	MIN(S.SalesAmount) AS TicketMin�mo,
	MAX(S.SalesAmount) AS TicketMaximo,
	ROUND(STDEVP(S.SalesAmount), 2) AS Desvio_Padr�o,
	ROUND(VARP(S.SalesAmount), 2) AS Vari�ncia,
	MAX(S.SalesAmount) - MIN(S.SalesAmount) AS Amplitude
FROM FactInternetSales S
JOIN MedianaCTE M ON YEAR(S.OrderDate) = M.Ano
GROUP BY Ano, M.Mediana
ORDER BY Ano;