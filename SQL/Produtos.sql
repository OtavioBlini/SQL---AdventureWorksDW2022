USE AdventureWorksDW2022;

	-- Faturamento por categoria
SELECT C.EnglishProductCategoryName AS Categorias,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS Faturamento,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS Custo,
	((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS MargemDeLucro
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
LEFT JOIN DimProductSubcategory AS SC ON P.ProductSubcategoryKey = SC.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS C ON SC.ProductCategoryKey = C.ProductCategoryKey
GROUP BY C.EnglishProductCategoryName
ORDER BY 2;

-- Top 5 mais vendidos
SELECT TOP 5
	P.EnglishProductName AS Produtos,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS Faturamento,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS Custo,
	((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS 'Margem de Lucro'
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
GROUP BY P.EnglishProductName
ORDER BY SUM(S.SalesAmount) DESC;

-- Produtos em Pedidos com Múltiplos Itens
	SELECT TOP 5
		P.EnglishProductName AS Produto,
		COUNT(S.ProductKey) AS 'Produtos frequentemente comprados em conjunto'
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

-- Top 5 produtos primeira compra
WITH primeira_compra (CustomerKey, SalesOrderNumber, OrderDate, ProductKey,	RN) AS
(
	SELECT
		CustomerKey,
		SalesOrderNumber,
		OrderDate,
		ProductKey,
		RANK() OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS RN
	FROM FactInternetSales
)
SELECT TOP 5
	P.EnglishProductName AS Produto,
	COUNT(PC.ProductKey) AS 'Primeira Compra'
FROM primeira_compra PC
LEFT JOIN DimProduct AS P ON PC.ProductKey = P.ProductKey
WHERE RN = 1
GROUP BY P.EnglishProductName
ORDER BY 2 DESC;