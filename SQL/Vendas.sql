USE AdventureWorksDW2022;

-- Analise Exploratória Vendas
SELECT
	FORMAT(COUNT(*), 'N0', 'pt-br') AS Qtd_Vendas,
	FORMAT(SUM(SalesAmount), 'C0', 'pt-br') AS TotalVendas,
	FORMAT(MIN(SalesAmount), 'C0', 'pt-br') AS MinVenda,
	FORMAT(MAX(SalesAmount), 'C0', 'pt-br') AS MaxVenda,
	FORMAT(AVG(SalesAmount), 'C0', 'pt-br') AS Ticket_Medio,
	FORMAT(STDEVP(SalesAmount), 'N0', 'pt-br') AS Desvio_Padrao,
	FORMAT(SUM(SalesAmount) - SUM(TotalProductCost), 'C0', 'pt-br') AS Lucro
FROM FactInternetSales;

-- Analise Exploratória Vendas por Ano
SELECT
	YEAR(OrderDate) AS Ano,
	FORMAT(COUNT(*), 'N0', 'pt-br') AS Qtd_Vendas,
	FORMAT(SUM(SalesAmount), 'C0', 'pt-br') AS TotalVendas,
	FORMAT(MIN(SalesAmount), 'C0', 'pt-br') AS MinVenda,
	FORMAT(MAX(SalesAmount), 'C0', 'pt-br') AS MaxVenda,
	FORMAT(AVG(SalesAmount), 'C0', 'pt-br') AS Ticket_Medio,
	FORMAT(STDEVP(SalesAmount), 'N0', 'pt-br') AS Desvio_Padrao,
	FORMAT(SUM(SalesAmount) - SUM(TotalProductCost), 'C0', 'pt-br') AS Lucro
FROM FactInternetSales
GROUP BY YEAR(OrderDate)
ORDER BY 1;

-- Crescimento anual
WITH Faturamento_Ano (Ano, Faturamento, Faturamento_ano_anterior) AS
(
	SELECT
		YEAR(OrderDate) AS Ano,
		SUM(SalesAmount) AS Faturamento,
		LAG(SUM(SalesAmount)) OVER(ORDER BY YEAR(OrderDate)) AS Faturamento_ano_anterior
	FROM FactInternetSales
	GROUP BY YEAR(OrderDate)
)
SELECT
	Ano,
	FORMAT(Faturamento, 'C0', 'pt-br') AS Faturamento_Anual,
	ROUND((((Faturamento-Faturamento_ano_anterior)*100)/Faturamento_ano_anterior), 2) AS YoY
FROM Faturamento_Ano;

-- Crescimento trimestral
WITH Faturamento_Trim (Ano, Trimestre, Faturamento_trim, Faturamento_trim_anterior) AS
(
	SELECT
		YEAR(OrderDate) AS Ano,
		DATEPART(QUARTER, OrderDate) AS Trimestre,
		SUM(SalesAmount) AS Faturamento_trim,
		LAG(SUM(SalesAmount)) OVER(PARTITION BY DATEPART(QUARTER, OrderDate) ORDER BY YEAR(OrderDate)) AS Faturamento_trim_anterior
	FROM FactInternetSales
	GROUP BY DATEPART(QUARTER, OrderDate), YEAR(OrderDate)
)
SELECT
	Ano,
	Trimestre,
	FORMAT(Faturamento_trim, 'C0', 'pt-br') AS Faturamento_trim,
	ROUND((((Faturamento_trim-Faturamento_trim_anterior)*100)/Faturamento_trim_anterior), 2) AS QoQ
FROM Faturamento_Trim
ORDER BY 2;

-- Faturamento por categoria
SELECT C.EnglishProductCategoryName AS Categorias,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS Faturamento,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS Custo,
	((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS MargemDeLucro
FROM FactInternetSales S
LEFT JOIN DimProduct AS P
	ON S.ProductKey = P.ProductKey
LEFT JOIN DimProductSubcategory AS SC
	ON P.ProductSubcategoryKey = SC.ProductSubcategoryKey
LEFT JOIN DimProductCategory AS C
	ON SC.ProductCategoryKey = C.ProductCategoryKey
GROUP BY C.EnglishProductCategoryName
ORDER BY 1;

-- Top 10 mais vendidos por faturamento
SELECT TOP 10
	P.EnglishProductName AS Produtos,
	FORMAT(SUM(S.SalesAmount), 'C0', 'pt-br') AS Faturamento,
	FORMAT(SUM(S.TotalProductCost), 'C0', 'pt-br') AS Custo,
    ((SUM(S.SalesAmount) - SUM(S.TotalProductCost)) / SUM(S.SalesAmount)) * 100 AS MargemDeLucro
FROM FactInternetSales S
LEFT JOIN DimProduct AS P ON S.ProductKey = P.ProductKey
GROUP BY P.EnglishProductName
ORDER BY SUM(S.SalesAmount) DESC;

-- Top 10 itens de vendas em conjunto
SELECT TOP 10
	P.EnglishProductName AS Produto,
	COUNT(S.ProductKey) AS ItensConjunto
FROM FactInternetSales S
LEFT JOIN DimProduct AS P
	ON S.ProductKey = P.ProductKey
WHERE SalesOrderNumber IN (
		SELECT SalesOrderNumber
		FROM FactInternetSales
		GROUP BY SalesOrderNumber
		HAVING COUNT(SalesOrderNumber) > 1
		)
GROUP BY P.EnglishProductName
ORDER BY 2 DESC;

-- Top 10 produtos primeira compra
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
SELECT TOP 10
	P.EnglishProductName AS Produto,
	COUNT(PC.ProductKey) AS PrimeiraCompra
FROM primeira_compra PC
LEFT JOIN DimProduct AS P
	ON PC.ProductKey = P.ProductKey
WHERE RN = 1
GROUP BY P.EnglishProductName
ORDER BY 2 DESC;
