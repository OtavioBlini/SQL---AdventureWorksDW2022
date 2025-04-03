USE AdventureWorksDW2022;

-- Vendas por categoria.
SELECT C.EnglishProductCategoryName AS categoria,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS venda,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS custo,
	((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS margem_lucro
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
LEFT JOIN DimProductSubcategory AS SC ON P.ProductSubcategoryKey = SC.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS C ON SC.ProductCategoryKey = C.ProductCategoryKey
GROUP BY C.EnglishProductCategoryName
ORDER BY 2;

-- Top 5 mais vendidos.
SELECT TOP 5
	P.EnglishProductName AS produto,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS venda,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS custo,
	((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS margem_lucro
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
GROUP BY P.EnglishProductName
ORDER BY SUM(S.SalesAmount) DESC;

-- Produtos em Pedidos com Múltiplos Itens.
SELECT TOP 5
	P.EnglishProductName AS produto,
	COUNT(S.ProductKey) AS compra_conjunta
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
WHERE SalesOrderNumber IN (
		SELECT SalesOrderNumber
		FROM FactInternetSales
		GROUP BY SalesOrderNumber
		HAVING COUNT(SalesOrderNumber) > 1
		)
GROUP BY P.EnglishProductName
ORDER BY 2 DESC;

-- Top 5 produtos primeira compra.
WITH OrdemCompra (CustomerKey, SalesOrderNumber, OrderDate, ProductKey, RN) AS (
	SELECT
		CustomerKey,
		SalesOrderNumber,
		OrderDate,
		ProductKey,
		RANK() OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS RN -- Número da compra
	FROM FactInternetSales
)
SELECT TOP 5
	P.EnglishProductName AS produto,
	COUNT(OC.ProductKey) AS primeira_compra
FROM OrdemCompra OC
LEFT JOIN DimProduct AS P ON OC.ProductKey = P.ProductKey
WHERE RN = 1
GROUP BY P.EnglishProductName
ORDER BY 2 DESC;
