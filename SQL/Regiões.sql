USE AdventureWorksDW2022;

-- Margem de Lucro por País e Participação Percentual por Região Vendas.
SELECT T.SalesTerritoryCountry AS pais,
	FORMAT(SUM(S.SalesAmount), 'N0', 'pt-br') AS venda,
	FORMAT(SUM(S.TotalProductCost), 'N0', 'pt-br') AS custo,
	FORMAT(SUM(S.SalesAmount) - SUM(S.TotalProductCost), 'N0', 'pt-br') AS lucro,
	ROUND((SUM(S.SalesAmount) - SUM(S.TotalProductCost))/SUM(S.SalesAmount)*100, 2) AS margem_lucro,
	ROUND((SUM(S.SalesAmount) /
			(SELECT SUM(SalesAmount)
				FROM FactInternetSales))*100, 2) AS participacao --Subquery
FROM FactInternetSales S
LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
GROUP BY T.SalesTerritoryCountry
ORDER BY venda DESC;

-- Crescimento vendas anual Estados Unidos e Australia.
WITH VendaLY (pais, ano, venda, venda_ly) AS (
	SELECT
			T.SalesTerritoryCountry AS pais,
			YEAR(S.OrderDate) AS ano,
			SUM(S.SalesAmount) AS venda,
			ISNULL(LAG(SUM(S.SalesAmount), 1) OVER(PARTITION BY T.SalesTerritoryCountry
													ORDER BY YEAR(S.OrderDate)), 0) AS venda_ly
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	WHERE T.SalesTerritoryCountry IN ('United States', 'Australia')
	GROUP BY YEAR(S.OrderDate), T.SalesTerritoryCountry)
SELECT 
	ano,
	pais,
	FORMAT(venda, 'C0', 'pt-br') AS venda,
	CASE
		WHEN venda_ly = 0 THEN 0
		ELSE ROUND((((venda-venda_ly)*100)/venda_ly), 2)
	END AS yoy
	FROM VendaLY
	ORDER BY pais, ano;

-- Crescimento vendas trimestrais Estados Unidos.
WITH VendaLQ (ano, trimestre, venda, venda_lq) AS (
	SELECT
		YEAR(S.OrderDate) AS ano,
		DATEPART(QUARTER, S.OrderDate) AS trimestre,
		SUM(S.SalesAmount) AS venda,
		ISNULL(LAG(SUM(S.SalesAmount)) OVER(PARTITION BY DATEPART(QUARTER, S.OrderDate)
												ORDER BY YEAR(S.OrderDate)), 0) AS venda_lq
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	WHERE T.SalesTerritoryCountry = 'United States'
	GROUP BY DATEPART(QUARTER, S.OrderDate), YEAR(S.OrderDate), T.SalesTerritoryCountry)
SELECT
	ano,
	trimestre,
	FORMAT(venda, 'C0', 'pt-br') AS venda,
	CASE
		WHEN venda_lq = 0 THEN 0
		ELSE ROUND((((venda-venda_lq)*100)/venda_lq), 2)
	END AS qoq
FROM VendaLQ
ORDER BY ano, trimestre;


-- Vendas por País com promoções.
WITH VendaPais (pais, venda_total, venda_promocao) AS (
	SELECT 
		T.SalesTerritoryCountry AS pais,
		COUNT(S.PromotionKey) AS venda_total,
		COUNT(CASE
					WHEN S.PromotionKey != 1 THEN 1
				END) AS venda_promocao
	FROM FactInternetSales S
	LEFT JOIN DimSalesTerritory AS T ON S.SalesTerritoryKey = T.SalesTerritoryKey
	GROUP BY T.SalesTerritoryCountry)
SELECT 
	pais,
	venda_promocao AS venda_promocao,
	FORMAT(ROUND((venda_promocao * 1.0 / venda_total * 100), 2), 'N2') AS percentual_promocao
FROM VendaPais;
