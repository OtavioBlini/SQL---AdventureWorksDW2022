# Introdução
No cenário atual, em um mundo cada vez mais digital, o e-commerce se tornou peça-chave de muitas empresas. A analise de desempenho de vendas pela internet é fundamental para empresas que busquem otimizar seus resultados. Compreender o comportamento dos consumidores, desempenho dos produtos por região e sazonalidade permite que gestores vislumbrem oportunidades e tomem decisões orientadas por dados.

O Data Warehouse ***AdventureWorksDW2022***, disponibilizado pela Microsoft, oferece um cenário ideal para o desenvolvimento de análises estratégicas e financeiras. Ele simula um ambiente corporativo com dados de uma empresa fictícia chamada Adventure Works, que opera no setor de varejo, com foco no e-commerce e operações globais.

# Ferramenta
<img
  src="https://64.media.tumblr.com/ec57a9abccbdfcfdd234a1d7ce60872e/1adc0a0257f98ada-4a/s540x810/dc16e674cca039859d5abecae9dbf71d1afbadd5.pnj" width="20" height="20" /> **Microsoft SQL Server**: A Linguagem de consulta estruturada (SQL) é uma linguagem de programação para armazenar e processar informações em um banco de dados relacional. Um banco de dados relacional armazena informações em formato tabular, com linhas e colunas representando diferentes atributos de dados e as várias relações entre os valores dos dados

# Desenvolvimento
## Tabelas Fato
O Data Warehouse AdventureWorksDW2022 é composto por tabelas do tipo fato que centralizam as informações e tabelas dimensão fornecem informações descritivas e categóricas que contextualizam as analises.

As principais tabelas fato são: FactInternetSales e FactResellerSales.

Sendo a primeira responsável pelas informações referentes ao canal de venda do e-commerce, enquanto a segunda é referente as vendas por revendedores.
A analise ocorrerá na tabela FactInternetSales, uma vez que ela é a mais indicada para explorar os indicadores financeiros associados às vendas online.

## Estrutura da Tabela
`USE AdventureWorksDW2022`

`EXEC sp_help 'FactInternetSales';`

Essa consulta retorna informações detalhadas sobre a tabela ***FactInternetSales***.
![image](https://github.com/user-attachments/assets/1dba6612-453e-4744-982e-7504354b9dba)

## Relacionamentos
O modelo de dados do AdventureWorksDW2022, baseado na tabela FactInternetSales, segue o esquema estrela (Star Schema).
Nesse modelo, a tabela fato centraliza os dados, enquanto as tabelas dimensão fornecem informações descritivas. Além disso o modelo tem característica de relacionamento 1:N, indicando que cada registro das tabelas dimensão podem estar associadas a múltiplos registros da tabela fato.
![image](https://github.com/user-attachments/assets/e067f97d-1379-4cd5-90eb-0883e5329079)

