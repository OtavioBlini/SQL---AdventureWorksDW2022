USE AdventureWorksDW2022;

-- Estrutura Tabela FactInternetSales
EXEC sp_help 'FactInternetSales';

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
WITH SubCategoriaNotNull(VendasNotNull, TotalRegistrosNotNull) AS (
    SELECT 
        SUM(S.SalesAmount) AS VendasNotNull,
        COUNT(*) AS TotalRegistrosNotNull
    FROM FactInternetSales S
    FULL JOIN DimProduct AS P
        ON S.ProductKey = P.ProductKey
    WHERE P.ProductSubcategoryKey IS NOT NULL
),
SubCategoriaNull(VendasNull, TotalRegistrosNull) AS (
    SELECT 
        SUM(S.SalesAmount) AS VendasNull,
        COUNT(*) AS TotalRegistrosNull
    FROM FactInternetSales S
    FULL JOIN DimProduct AS P
        ON S.ProductKey = P.ProductKey
    WHERE P.ProductSubcategoryKey IS NULL
)
SELECT
    VendasNotNull,
    TotalRegistrosNotNull,
    VendasNull,
    TotalRegistrosNull
FROM SubCategoriaNotNull, SubCategoriaNull;

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