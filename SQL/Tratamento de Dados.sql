USE AdventureWorksDW2022;

-- Estátisticas Básicas
SELECT
	COUNT(*) AS Total_registros,
	SUM(SalesAmount) AS Soma,
	AVG(SalesAmount) AS Media,
	MIN(SalesAmount) AS Valor_minimo,
	MAX(SalesAmount) AS Valor_maximo,
	ROUND(STDEVP(SalesAmount), 2) AS Desvio_Padrao,
	ROUND(VARP(SalesAmount), 2) AS Variancia,
	MAX(SalesAmount) - MIN(TotalProductCost) AS Amplitude
FROM FactInternetSales; 

-- Distribuição ao longo do tempo
SELECT
	YEAR(OrderDate) AS Ano,
	COUNT(*) AS Total_registros,
	SUM(SalesAmount) AS Soma,
	AVG(SalesAmount) AS Media,
	MIN(SalesAmount) AS Valor_minimo,
	MAX(SalesAmount) AS Valor_maximo,
	ROUND(STDEVP(SalesAmount), 2) AS Desvio_Padrao,
	ROUND(VARP(SalesAmount), 2) AS Variancia,
	MAX(SalesAmount) - MIN(TotalProductCost) AS Amplitude
FROM FactInternetSales
GROUP BY YEAR(OrderDate)
ORDER BY 1;

-- Consulta Data
SELECT
	MIN(OrderDate) AS DataInicio,
	MAX(OrderDate) AS DataFim
FROM FactInternetSales;

-- Deletando Registros Incompletos SalesReason
DELETE
 FROM AdventureWorksDW2022.dbo.FactInternetSalesReason
 WHERE SalesOrderNumber IN (
        SELECT SalesOrderNumber
        FROM AdventureWorksDW2022.dbo.FactInternetSales
        WHERE YEAR(OrderDate) < 2011
            OR YEAR(OrderDate) > 2013
        );

-- Deletando Registros Incompletos InternetSales
DELETE
 FROM AdventureWorksDW2022.dbo.FactInternetSales
 WHERE YEAR(OrderDate) < 2011
    OR YEAR(OrderDate) > 2013;

-- Verificação de Nulos nas Chaves Estrangeiras
SELECT
	SUM(CASE WHEN ProductKey IS NULL THEN 1 ELSE 0 END) AS ProductKey_Null,
	SUM(CASE WHEN OrderDateKey IS NULL THEN 1 ELSE 0 END) AS OrderDateKey_Null,
	SUM(CASE WHEN DueDateKey IS NULL THEN 1 ELSE 0 END) AS DueDateKey_Null,
	SUM(CASE WHEN ShipDateKey IS NULL THEN 1 ELSE 0 END) AS ShipDateKey_Null,
	SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS CustomerKey_Null,
	SUM(CASE WHEN PromotionKey IS NULL THEN 1 ELSE 0 END) AS PromotionKey_Null,
	SUM(CASE WHEN CurrencyKey IS NULL THEN 1 ELSE 0 END) AS CurrencyKey_Null,
	SUM(CASE WHEN SalesTerritoryKey IS NULL THEN 1 ELSE 0 END) AS SalesTerritoryKey_Null
FROM FactInternetSales;

-- Valores Nulos Tabelas Relacionadas
SELECT
     SUM(CASE WHEN GeographyKey IS NULL THEN 1 ELSE 0 END) AS GeographyKey_Null
FROM DimCustomer;

SELECT
     SUM(CASE WHEN SalesTerritoryKey IS NULL THEN 1 ELSE 0 END) AS SalesTerritoryKey_Null
FROM DimGeography;

SELECT
     SUM(CASE WHEN ProductCategoryKey IS NULL THEN 1 ELSE 0 END) AS ProductCategoryKey_Null
FROM DimProductSubcategory;

SELECT
     SUM(CASE WHEN ProductSubcategoryKey IS NULL THEN 1 ELSE 0 END) AS ProductSubcategoryKey_Null
FROM DimProduct;

-- Verificando possíveis valores associados a nulos
WITH SubCategoriaNotNull (VendasNotNull) AS (
     SELECT SUM(S.SalesAmount) AS VendasNotNull
     FROM FactInternetSales S
     FULL JOIN DimProduct AS P
         ON S.ProductKey = P.ProductKey
     WHERE P.ProductSubcategoryKey IS NOT NULL
     ),
SubCategoriaNull (VendasNull) AS (
     SELECT SUM(S.SalesAmount) AS VendasNull
     FROM FactInternetSales S
     FULL JOIN DimProduct AS P
         ON S.ProductKey = P.ProductKey
     WHERE P.ProductSubcategoryKey IS NULL
     )
SELECT
     VendasNotNull,
     (SELECT * FROM SubCategoriaNull) AS VendasNull
FROM SubCategoriaNotNull;

-- Deletando Valores Nulos FactProductInventory
DELETE
 FROM AdventureWorksDW2022.dbo.FactProductInventory
 WHERE ProductKey IN (
        SELECT ProductKey
        FROM AdventureWorksDW2022.dbo.DimProduct
        WHERE ProductSubcategoryKey IS NULL
        );

-- Deletando Valores Nulos DimProduct
DELETE
 FROM AdventureWorksDW2022.dbo.DimProduct
 WHERE  ProductSubcategoryKey IS NULL;