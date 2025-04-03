USE AdventureWorksDW2022;

-- Análise temporal.
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE (Mediana) AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) OVER () AS Mediana
    FROM FactInternetSales
)
SELECT
    COUNT(*) AS Produtos,
    SUM(SalesAmount) AS Vendas,
	(SELECT Mediana FROM MedianaCTE) AS Mediana, -- Inserção da CTE
    MIN(SalesAmount) AS TicketMínimo,
    AVG(SalesAmount) AS TicketMédio,
    MAX(SalesAmount) AS TicketMáximo,
    ROUND(STDEVP(SalesAmount), 2) AS DesvioPadrão,
    ROUND(VARP(SalesAmount), 2) AS Variância,
    MAX(SalesAmount) - MIN(SalesAmount) AS Amplitude
FROM FactInternetSales;

-- Distribuição ao longo do tempo.
-- PERCENTILE_CONT é windows function requerindo uma CTE.
WITH MedianaCTE (Ano, Mediana) AS (
	SELECT DISTINCT
		YEAR(OrderDate) AS Ano,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY SalesAmount) 
			OVER (PARTITION BY YEAR(OrderDate)) AS Mediana -- Criar partições por ano
	FROM FactInternetSales
)
SELECT
	Ano,
	COUNT(*) AS Produtos,
	SUM(S.SalesAmount) AS Vendas,
	M.Mediana AS Mediana, -- Inserção da CTE
	MIN(SalesAmount) AS TicketMínimo,
	AVG(S.SalesAmount) AS TicketMédio,
	MAX(S.SalesAmount) AS TicketMaximo,
	ROUND(STDEVP(S.SalesAmount), 2) AS Desvio_Padrão,
	ROUND(VARP(S.SalesAmount), 2) AS Variância,
	MAX(S.SalesAmount) - MIN(S.SalesAmount) AS Amplitude
FROM FactInternetSales S
JOIN MedianaCTE M ON YEAR(S.OrderDate) = M.Ano
GROUP BY Ano, M.Mediana
ORDER BY Ano;
