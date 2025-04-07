USE AdventureWorksDW2022;

-- Clientes por genero.
SELECT
	COUNT(DISTINCT(C.CustomerKey)) AS clientes,
	C.Gender AS genero
FROM FactInternetSales S
LEFT JOIN DimCustomer C ON S.CustomerKey = C.CustomerKey
GROUP BY C.Gender
ORDER BY 1;


-- Clientes Faixa Etaria.
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
WITH ClientesPrimeiraCompra (ano, cliente_id)  AS (
	SELECT
		DATEPART(YEAR, MIN(S.OrderDate)) AS ano,
		S.CustomerKey AS cliente_id
	FROM FactInternetSales S
	GROUP BY S.CustomerKey
)
SELECT
	ano,
	COUNT(cliente_id) AS cliente_novo,
	CASE
		WHEN LAG(COUNT(cliente_id), 1) OVER(ORDER BY ano) IS NULL THEN 0
		ELSE COUNT(cliente_id) - LAG(COUNT(cliente_id), 1) OVER(ORDER BY ano)
	END AS cliente_deltaly
FROM ClientesPrimeiraCompra
GROUP BY ano;
