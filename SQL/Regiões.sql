USE AdventureWorksDW2022;

-- Margem de Lucro por País e Participação Percentual por Região Vendas.
SELECT T.SalesTerritoryCountry AS Pais,
		FORMAT(SUM(S.SalesAmount), 'N0', 'pt-br') AS Vendas,
		FORMAT(SUM(S.TotalProductCost), 'N0', 'pt-br') AS Custos,
		FORMAT(SUM(S.SalesAmount) - SUM(S.TotalProductCost), 'N0', 'pt-br') AS Lucro,
		ROUND((SUM(S.SalesAmount) - SUM(S.TotalProductCost))/SUM(S.SalesAmount)*100, 2) AS 'Margem de Lucro',
		ROUND((SUM(S.SalesAmount) /
				(SELECT SUM(SalesAmount)
					FROM FactInternetSales))*100, 2) AS 'Vendas por Participação Percentual por Região' --Subquery
FROM FactInternetSales S
LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
GROUP BY T.SalesTerritoryCountry
ORDER BY Vendas DESC;

-- Crescimento vendas anual Estados Unidos e Australia.
WITH Vendas_Ano (Pais, Ano, Vendas, Vendas_ano_anterior) AS (
	SELECT
			T.SalesTerritoryCountry AS Pais,
			YEAR(S.OrderDate) AS Ano,
			SUM(S.SalesAmount) AS Vendas,
			ISNULL(LAG(SUM(S.SalesAmount), 1) OVER(PARTITION BY T.SalesTerritoryCountry
													ORDER BY YEAR(S.OrderDate)), 0) AS Vendas_ano_anterior
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	WHERE T.SalesTerritoryCountry IN ('United States', 'Australia')
	GROUP BY YEAR(S.OrderDate), T.SalesTerritoryCountry)
SELECT 
		Ano,
		Pais,
		FORMAT(Vendas, 'C0', 'pt-br') AS Vendas,
		CASE
			WHEN Vendas_ano_anterior = 0 THEN 0
			ELSE ROUND((((Vendas-Vendas_ano_anterior)*100)/Vendas_ano_anterior), 2)
		END AS YoY
FROM Vendas_Ano
ORDER BY Pais, Ano;

-- Crescimento vendas trimestrais Estados Unidos.
WITH Vendas_Ano (Ano, Trimestre, Vendas, Vendas_trimestre_anterior) AS (
SELECT
		YEAR(S.OrderDate) AS Ano,
		DATEPART(QUARTER, S.OrderDate) AS Trimestre,
		SUM(S.SalesAmount) AS Vendas,
		ISNULL(LAG(SUM(S.SalesAmount)) OVER(PARTITION BY DATEPART(QUARTER, S.OrderDate)
												ORDER BY YEAR(S.OrderDate)), 0) AS Vendas_trimestre_anterior
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	WHERE T.SalesTerritoryCountry = 'United States'
	GROUP BY DATEPART(QUARTER, S.OrderDate), YEAR(S.OrderDate), T.SalesTerritoryCountry)
SELECT Ano,
		Trimestre,
		FORMAT(Vendas, 'C0', 'pt-br') AS Vendas,
		CASE
			WHEN Vendas_trimestre_anterior = 0 THEN 0
			ELSE ROUND((((Vendas-Vendas_trimestre_anterior)*100)/Vendas_trimestre_anterior), 2)
		END AS QoQ
FROM Vendas_Ano
ORDER BY Ano, Trimestre;


-- Vendas por País com promoções.
WITH VendasPorPais (Pais, TotalVendas, VendasPromocao) AS (
SELECT 
		T.SalesTerritoryCountry AS Pais,
		COUNT(S.PromotionKey) AS TotalVendas,
		COUNT(CASE
					WHEN S.PromotionKey != 1 THEN 1
				END) AS VendasPromocao
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	GROUP BY T.SalesTerritoryCountry)
SELECT 
		Pais,
		VendasPromocao AS 'Vendas em Promoção',
		FORMAT(ROUND((VendasPromocao * 1.0 / TotalVendas * 100), 2), 'N2') AS 'Vendas em Promoção %'
FROM VendasPorPais;