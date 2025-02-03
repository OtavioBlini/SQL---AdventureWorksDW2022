# Introdução
No cenário atual, em um mundo cada vez mais digital, o e-commerce se tornou peça-chave de muitas empresas. A análise de desempenho de vendas pela internet é fundamental para empresas que busquem otimizar seus resultados. Compreender o comportamento dos consumidores, desempenho dos produtos por região e sazonalidade permite que gestores vislumbrem oportunidades e tomem decisões orientadas por dados.

O Data Warehouse ***AdventureWorksDW2022***, disponibilizado pela Microsoft, oferece um cenário ideal para o desenvolvimento de análises estratégicas e financeiras. Ele simula um ambiente corporativo com dados de uma empresa fictícia chamada Adventure Works, que opera no setor de varejo, com foco no e-commerce e operações globais.

# Ferramenta
<img
  src="https://64.media.tumblr.com/ec57a9abccbdfcfdd234a1d7ce60872e/1adc0a0257f98ada-4a/s540x810/dc16e674cca039859d5abecae9dbf71d1afbadd5.pnj" width="20" height="20" /> **Microsoft SQL Server**: A Linguagem de consulta estruturada (SQL) é uma linguagem de programação para armazenar e processar informações em um banco de dados relacional. Um banco de dados relacional armazena informações em formato tabular, com linhas e colunas representando diferentes atributos de dados e as várias relações entre os valores dos dados

# Desenvolvimento
## Tabelas Fato
O Data Warehouse AdventureWorksDW2022 é composto por tabelas do tipo fato que centralizam as informações e tabelas dimensão fornecem informações descritivas e categóricas que contextualizam as análises.

As principais tabelas fato são: FactInternetSales e FactResellerSales.

Sendo a primeira responsável pelas informações referentes ao canal de venda do e-commerce, enquanto a segunda é referente as vendas por revendedores.
A análise ocorrerá na tabela FactInternetSales, uma vez que ela é a mais indicada para explorar os indicadores financeiros associados às vendas online.

## Estrutura da Tabela
![image](https://github.com/user-attachments/assets/37ec0f99-7c3c-4aac-a5f3-14eaaba3b789)


Essa consulta retorna informações detalhadas sobre a tabela ***FactInternetSales***.
![image](https://github.com/user-attachments/assets/1dba6612-453e-4744-982e-7504354b9dba)

## Relacionamentos
O modelo de dados do AdventureWorksDW2022, baseado na tabela FactInternetSales, segue o esquema estrela (Star Schema).
Nesse modelo, a tabela fato centraliza os dados, enquanto as tabelas dimensão fornecem informações descritivas. Além disso o modelo tem característica de relacionamento 1:N, indicando que cada registro das tabelas dimensão pode estar associadas a múltiplos registros da tabela fato.
![image](https://github.com/user-attachments/assets/e067f97d-1379-4cd5-90eb-0883e5329079)

## [Limpeza e tratamento de Dados](https://github.com/OtavioBlini/AdventureWorksDW2022/blob/main/SQL/Tratamento%20de%20Dados.sql)
### Estatísticas Descritivas
![image](https://github.com/user-attachments/assets/557525c3-be09-4e0d-8bb3-4f1a1f0dbbab)

![image](https://github.com/user-attachments/assets/5b93cfb6-7143-4c35-884e-935c9ba60d90)

A consulta tem como objetivo uma visão geral sobre os dados da coluna **SalesAmount.**

As colunas representam:
Total_registros (*Quantidade Total de Vendas*)

Media (*Média das vendas*)

Soma (*Soma das vendas*)

Valor_minimo (*Valor mínimo de venda*)

Valor_maximo (*Valor máximo de venda*)

Desvio_padrao (*Desvio padrão*)

Variancia (*Variância*)

Amplitude (*Diferença entre o valor mínimo e máximo*)

Analisando a distribuição ao longo do tempo.

![image](https://github.com/user-attachments/assets/498e179e-72bb-43fb-876c-061ff15ab4d4)


![image](https://github.com/user-attachments/assets/fe621e1a-f60e-4330-bc60-cc2fb24b20b2)

Com esta consulta, se constata que os anos de 2010 e 2014 possuem alguma inconsistência com os demais anos.

### Análise de Registros
![image](https://github.com/user-attachments/assets/e30a7c2e-4bcd-43a2-b15a-d6e139a7c85c)


![image](https://github.com/user-attachments/assets/214bb3f8-4e60-464c-8f5a-16942e4c53b8)

Com esta consulta, se constata que os anos de 2010 e 2014 não possuem registros completos de vendas.

### Deletando Registros Incompletos de Venda
Conforme constatado os anos de 2010 e 2014 não possuem registros completos anuais, sendo assim podendo impactar em possíveis análises futuras. Para garantir a consistência das analises a abordagem adotada foi de remoção integral dos valores, entretanto essa decisão se baseia no escopo proposto pelo projeto. Cada situação requer uma análise prévia e singular, a abordagem adotada satisfaz as necessidades imediatas, sem comprometer outras análises.

![image](https://github.com/user-attachments/assets/6d019de0-3ec6-4429-863c-975390573872)

![image](https://github.com/user-attachments/assets/9e2beb7c-9f11-4d80-b62b-1d4bd223f150)

A tabela ***FactInternetSalesReason*** possui uma chave estrangeira que faz referência a tabela *FactInternetSales*. Isso significa que não é possível excluir registros na tabela *FactInternetSales* enquanto houver registros associados na *FactInternetSalesReason*, devido à restrição de integridade.

Portanto, é necessário excluir os registros na tabela *FactInternetSalesReason* que estão relacionados aos registros da tabela *FactInternetSales*.

![image](https://github.com/user-attachments/assets/ffe16b41-f817-4478-a414-c05ea080ec76)

![image](https://github.com/user-attachments/assets/af8caf38-cabb-4cc6-914f-057bf243d141)

Após realizar esta consulta, foi possível excluir os registros da tabela FactInternetSales.

### Verificação de Nulos nas Chaves Estrangeiras
![image](https://github.com/user-attachments/assets/b0460f46-6749-42be-97ef-1579dabff5e3)

![image](https://github.com/user-attachments/assets/27ce43dc-a183-463f-9cc1-c3dc3e25a858)

Nenhuma Chave Estrangeira apresenta valores nulos.

### Valores Nulos Tabelas Relacionadas
![image](https://github.com/user-attachments/assets/13efd8c9-d36e-457a-b9a8-2626860d3fdd)

![image](https://github.com/user-attachments/assets/8864f8fc-7941-4970-89e2-7f40fae9da09)

A consulta indicou que o campo 'ProductSubcategoryKey' possui  209 registros com valores nulos. Esses valores podem indicar produtos que não estão corretamente associados a uma subcategoria
A solução adotada nesse projeto foi de exclusão desses registros nulos, entretanto antes é necessário entender se há algum valor associado a venda com eles.

![image](https://github.com/user-attachments/assets/fe80c621-156e-4173-aea5-3df4c7d46acc)

![image](https://github.com/user-attachments/assets/12a9bf57-fa45-4226-aad8-ceb3e7026cbd)

A consulta indicou que não há valores na coluna SalesAmount associados a produtos nulos. Sendo assim possível a exclusão desses registros sem nenhum prejuízo as análises.

### Deletando Registros Nulos
![image](https://github.com/user-attachments/assets/ef0fbee3-fe80-4672-aa9d-a404f3bcdee9)

![image](https://github.com/user-attachments/assets/b9240366-4e53-4e9c-a86d-bfd0b8f56ca8)

Novamente, para garantir a integridade é necessário realizar a exclusão primeiro na tabela FactProductInventory.

![image](https://github.com/user-attachments/assets/6925db6a-b618-497a-a7d4-c9de90b3b693)

![image](https://github.com/user-attachments/assets/521abeef-7015-4b64-aa9e-79cd3b28569b)

Após realizar esta consulta, foi possível excluir os registros da tabela DimProduct.

## [Análise de Vendas](https://github.com/OtavioBlini/AdventureWorksDW2022/blob/main/SQL/Vendas.sql)
### Análise Exploratória de Vendas
![image](https://github.com/user-attachments/assets/5795a7df-5a61-4bad-8fa7-ab553dd202ac)

![image](https://github.com/user-attachments/assets/e57c2368-097e-4fd9-a79a-f921568c9893)

A consulta retorna valores balizadores a respeito do funcionamento do e-commerce da empresa.
A quantidade total de vendas (Qtd_Vendas) com 58.414 vendas realizadas, obtendo um Faturamento de R$ 29.269.561, que gerou um lucro de R$ 12.037.482.
A menor venda realizada foi de R$2 e a maior de R$ 3.578, obtendo um ticket médio (Ticket_Medio) de R$ 501 e um desvio padrão (Desvio_Padrao) de 939.


### Análise de Vendas por Ano
![image](https://github.com/user-attachments/assets/47dd089d-ee38-4297-b499-cc10a28e167b)

![image](https://github.com/user-attachments/assets/461bd088-b606-4471-a748-5ea243b5f07f)

Analisando anualmente é possível identificar pontos importantes sobre o e-commerce. O ano de 2013 se destacada dos demais, indicando um maior número de vendas (Qtd_Vendas) em relação aos demais anos, o faturamento e lucro são um destaque nessa série temporal. Observando o valor mínimo de venda a partir de 2012 ele passa a ser R$ 2 indicando que a gama de produtos foi expandida, o que poderia ser uma explicação do motivo pelo qual há uma maior quantidade de vendas em relação ao período anterior de 2011, porém o faturamento é significativamente menor.

### Crescimento Anual
![image](https://github.com/user-attachments/assets/f3033a98-d889-4620-a325-46c88f8f162e)

![image](https://github.com/user-attachments/assets/f2851748-3a85-48b7-8ce0-0548906e3379)

O faturamento do ano de 2012 apresenta uma queda em relação ao período anterior de 17%.
Em 2013 o faturamento, em comparação com 2012, cresce aproximadamente 180%.

### Crescimento Trimestral
![image](https://github.com/user-attachments/assets/19828e98-e659-43ce-9329-737ac08d49ab)

![image](https://github.com/user-attachments/assets/0a9dfa8b-5d8a-498b-be40-535eaeb5ac95)

O faturamento entre os trimestres mostra o constante aumento em 2013, tendo como auge o quarto trimestre com crescimento de 214%.

### Faturamento por Categoria
![image](https://github.com/user-attachments/assets/b833bcf1-ac98-40a1-bf65-5084aa510cd7)

![image](https://github.com/user-attachments/assets/9887b72b-e14a-4c8f-81ac-b9344395c29c)

A categoria "Accessories" representa a maior margem de lucro com 63%. As demais categorias, "Bikes" e "Clothing" possuem uma margem de 40%.
É interessante observar que dás três categorias o faturamento de "Bikes" representa um total de 97% do faturamento total.

### Top 10 mais Vendidos (maior faturamento)
![image](https://github.com/user-attachments/assets/bb9680d8-f8fa-4bd9-a692-e3604ac244e6)

![image](https://github.com/user-attachments/assets/d0ac585f-d675-4531-9c9e-44f5b143146b)

Os dez produtos com maior faturamento na história da empresa são modelos de bicicletas, sendo o mais popular a "Mountain-200" e a "Road-150".

### Top 10 Vendidos em Conjunto
![image](https://github.com/user-attachments/assets/c923829f-59c0-4754-9fc2-205c05d3a3a0)

![image](https://github.com/user-attachments/assets/e3fe2471-5d78-4776-b3cd-4cc1ade1c81d)

Essa consulta retorna produtos que são comprados junto de outros, bens complementares. O item com maior venda é a "Water Bottle - 30 oz."

### Top 10 produtos Primeira Compra
![image](https://github.com/user-attachments/assets/f1c4ce0d-ee27-473f-84be-6f7e89cc4c34)

![image](https://github.com/user-attachments/assets/f56197a4-5845-4239-ad3e-d77ccc8debd9)

A consulta retorna os produtos que mais são vendidos na primeira compra do cliente. Observando os dez itens com maior saída na primeira compra se compreende que muitos clientes optam por adquirir itens da categoria "Accessories".

