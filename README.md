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
![image](https://github.com/user-attachments/assets/37ec0f99-7c3c-4aac-a5f3-14eaaba3b789)


Essa consulta retorna informações detalhadas sobre a tabela ***FactInternetSales***.
![image](https://github.com/user-attachments/assets/1dba6612-453e-4744-982e-7504354b9dba)

## Relacionamentos
O modelo de dados do AdventureWorksDW2022, baseado na tabela FactInternetSales, segue o esquema estrela (Star Schema).
Nesse modelo, a tabela fato centraliza os dados, enquanto as tabelas dimensão fornecem informações descritivas. Além disso o modelo tem característica de relacionamento 1:N, indicando que cada registro das tabelas dimensão podem estar associadas a múltiplos registros da tabela fato.
![image](https://github.com/user-attachments/assets/e067f97d-1379-4cd5-90eb-0883e5329079)

## Limpeza e tratamento de Dados
### Estatísticas Descritivas
![image](https://github.com/user-attachments/assets/aa5717b8-ef55-4e05-8423-008ee026e740)
![image](https://github.com/user-attachments/assets/5b93cfb6-7143-4c35-884e-935c9ba60d90)

A consulta tem como objetivo uma visão geral sobre os dados da coluna **SalesAmount.**

**As colunas representam:**

**Total_registros** (*Quantidade Total de Vendas*)

**Media** (*Média das vendas*)

**Soma** (*Soma das vendas*)

**Valor_minimo** (*Valor mínimo de venda*)

**Valor_maximo** (*Valor máximo de venda*)

**Desvio_padrao** (*Desvio padrão*)

**Variancia** (*Variância*)

**Amplitude** (*Diferença entre o valor mínimo e máximo*)
![image](https://github.com/user-attachments/assets/98f8c3b0-b1f7-41d5-8175-a09d212b393f)
![image](https://github.com/user-attachments/assets/fe621e1a-f60e-4330-bc60-cc2fb24b20b2)
Com esta consulta, se constata que os anos de 2010 e 2014 não possuem registros completos de vendas.

### Análise de Registros
![image](https://github.com/user-attachments/assets/23b0a308-a527-499b-8ede-4b7e45c7c31a)
Com esta consulta, se constata que os anos de 2010 e 2014 não possuem registros completos de vendas.

### Deletando Registros Incompletos de Venda
Conforme constatado os anos de 2010 e 2014 não possuem registros completos anuais, sendo assim podendo impactar em possíveis análises futuras. Para garantir a consistência das analises a abordagem adotada foi de remoção integral dos valores, entretanto essa decisão se baseia no escopo proposto pelo projeto. Cada situação requer uma análise prévia e singular, a abordagem adotada satisfaz as necessidades imediatas, sem comprometer outras análises.
![image](https://github.com/user-attachments/assets/1dc8893a-62d3-45f9-8073-5dbb06cfa76d)
****A tabela ***FactInternetSalesReason*** possui uma chave estrangeira que faz referência a tabela *FactInternetSales*. Isso significa que não é possível excluir registros na tabela *FactInternetSales* enquanto houver registros associados na *FactInternetSalesReason*, devido à restrição de integridade.

Portanto, é necessário excluir os registros na tabela *FactInternetSalesReason* que estão relacionados aos registros da tabela *FactInternetSales*.

![image](https://github.com/user-attachments/assets/1dae82b4-374f-415e-8673-3cf89be11996)
Após realizar esta consulta, foi possível excluir os registros da tabela FactInternetSales.



