USE AdventureWorksDW2022;

-- Clientes por gênero.
SELECT
	COUNT(DISTINCT(C.CustomerKey)) AS clientes,
C.Gender AS genero
FROM FactInternetSales S
LEFT JOIN DimCustomer C ON S.CustomerKey = C.CustomerKey
GROUP BY C.Gender
ORDER BY 1;


-- Clientes Faixa Etária.
WITH FaixaEtariaClientes (CustomerKey, FaixaEtaria) AS (
	SELECT
		CustomerKey,
		CASE
			WHEN DATEDIFF(YEAR, BirthDate, '2014-01-01') < 18 THEN '0-17'
			WHEN DATEDIFF(YEAR, BirthDate,'2014-01-01') BETWEEN 18 AND 29 THEN '18-29'
			WHEN DATEDIFF(YEAR, BirthDate, '2014-01-01') BETWEEN 30 AND 44 THEN '30-44'
			WHEN DATEDIFF(YEAR, BirthDate, '2014-01-01') BETWEEN 45 AND 59 THEN '45-59'
			WHEN DATEDIFF(YEAR, BirthDate, '2014-01-01') >= 60 THEN '60+'
			ELSE 'desconhecido'
		END AS FaixaEtaria
	FROM DimCustomer
)
SELECT
	COUNT(DISTINCT(S.CustomerKey)) AS clientes,
	FaixaEtaria AS faixa_etaria
FROM FactInternetSales S
LEFT JOIN FaixaEtariaClientes F ON S.CustomerKey = F.CustomerKey
GROUP BY F.FaixaEtaria
ORDER BY 2;

-- Cliente novos por ano.
SELECT 
	YEAR(DateFirstPurchase) AS ano, 
	COUNT(DISTINCT CustomerKey) AS clientes_novos
FROM DimCustomer
WHERE DateFirstPurchase IS NOT NULL 
AND YEAR(DateFirstPurchase) NOT IN (2010, 2014)
GROUP BY YEAR(DateFirstPurchase)
ORDER BY Ano;
