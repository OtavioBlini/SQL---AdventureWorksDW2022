# Introdução
No cenário atual, em um mundo cada vez mais digital, o e-commerce se tornou peça-chave de muitas empresas. A análise de desempenho de vendas pela internet é fundamental para empresas que busquem otimizar seus resultados. Compreender o comportamento dos consumidores, desempenho dos produtos por região e sazonalidade permite que gestores vislumbrem oportunidades e tomem decisões orientadas por dados.

O Data Warehouse ***AdventureWorksDW2022***, disponibilizado pela Microsoft, oferece um cenário ideal para o desenvolvimento de análises estratégicas e financeiras. Ele simula um ambiente corporativo com dados de uma empresa fictícia chamada Adventure Works, que opera no setor de varejo, com foco no e-commerce e operações globais.

# Objetivo
O projeto tem como finalidade realizar uma análise exploratória dos dados referente ao desempenho por região, caracteristicas do clientes e análise dos produtos. 

Aqui você encontra a solução para essas questões utilizando a ferramenta [Power BI](https://app.powerbi.com/view?r=eyJrIjoiNzQyNmZhOTQtNjA4Yi00ZjliLWFjMTYtYWIwYTVhODQ2ODZiIiwidCI6IjYzZTE3ZmYzLWE1NjAtNGNhYS04ZTNlLTg0MjNjMzI4YzI5OCJ9).

# Ferramentas
<img
  src="https://64.media.tumblr.com/ec57a9abccbdfcfdd234a1d7ce60872e/1adc0a0257f98ada-4a/s540x810/dc16e674cca039859d5abecae9dbf71d1afbadd5.pnj" width="20" height="20" /> **Microsoft SQL Server**: A Linguagem de consulta estruturada (SQL)

# Desenvolvimento
## Tabelas Fato
O Data Warehouse AdventureWorksDW2022 é composto por tabelas do tipo fato que centralizam as informações e tabelas dimensão fornecem informações descritivas e categóricas que contextualizam as análises.

A análise ocorrerá utilizando a tabela [FactInternetSales](https://github.com/user-attachments/assets/1dba6612-453e-4744-982e-7504354b9dba), uma vez que ela é a mais indicada para explorar os indicadores financeiros associados às vendas online.

## [Modelo de Dados](https://github.com/user-attachments/assets/e067f97d-1379-4cd5-90eb-0883e5329079)
O modelo de dados do AdventureWorksDW2022, baseado na tabela FactInternetSales, segue o esquema estrela (Star Schema).
Nesse modelo, a tabela fato centraliza os dados, enquanto as tabelas dimensão fornecem informações descritivas. Além disso o modelo tem característica de relacionamento 1:N, indicando que cada registro das tabelas dimensão pode estar associadas a múltiplos registros da tabela fato.

## [Limpeza e tratamento de Dados](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Tratamento%20de%20Dados.sql)
### Deletando Registros Incompletos de Venda
![image](https://github.com/user-attachments/assets/fb3c59d7-5e17-46a7-a99f-38fec07c29c0)
![image](https://github.com/user-attachments/assets/2390b843-cb1f-487b-beb8-f14eb48a81a3)

Conforme constatado os anos de 2010 e 2014 não possuem registros completos anuais, sendo assim podendo impactar em possíveis análises futuras. Para garantir a consistência das analises a abordagem adotada foi de remoção integral dos valores, entretanto essa decisão se baseia no escopo proposto pelo projeto. Cada situação requer uma análise prévia e singular, a abordagem adotada satisfaz as necessidades imediatas, sem comprometer outras análises.

![image](https://github.com/user-attachments/assets/6d019de0-3ec6-4429-863c-975390573872)
![image](https://github.com/user-attachments/assets/ffe16b41-f817-4478-a414-c05ea080ec76)

A tabela ***FactInternetSalesReason*** possui uma chave estrangeira que faz referência a tabela ***FactInternetSales***. Isso significa que não é possível excluir registros na tabela ***FactInternetSales*** enquanto houver registros associados na ***FactInternetSalesReason***, devido à restrição de integridade.

Portanto, é necessário excluir os registros na tabela ***FactInternetSalesReason*** que estão relacionados aos registros da tabela *FactInternetSales*.

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

![image](https://github.com/user-attachments/assets/6c64308b-747b-4ab4-9c94-e17f8ec6822f)
![image](https://github.com/user-attachments/assets/fba3ff0f-568f-4ef4-9c2c-50aa435ec1d9)

A consulta indicou que não há valores na coluna SalesAmount associados a produtos nulos. Sendo assim possível a exclusão desses registros sem nenhum prejuízo as análises.

### Deletando Registros Nulos
![image](https://github.com/user-attachments/assets/ef0fbee3-fe80-4672-aa9d-a404f3bcdee9)
![image](https://github.com/user-attachments/assets/6925db6a-b618-497a-a7d4-c9de90b3b693)

Novamente, para garantir a integridade é necessário realizar a exclusão primeiro na tabela FactProductInventory.


Após realizar esta consulta, foi possível excluir os registros da tabela DimProduct.

## [Análise Temporal](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/An%C3%A1lise%20Temporal.sql)
![image](https://github.com/user-attachments/assets/f3c67612-1332-4974-8000-9ad461bc0282)
![image](https://github.com/user-attachments/assets/8e02e628-8b59-441f-8abf-6e573266eadc)

Analisando anualmente é possível identificar pontos importantes sobre o e-commerce. O ano de 2013 se destacada dos demais, indicando um maior número de vendas em relação aos demais anos. Observando o valor mínimo de venda a partir de 2012 ele passa a ser R$ 2,29 indicando que a gama de produtos foi expandida, o que poderia ser uma explicação do motivo pelo qual há uma maior quantidade de registros de vendas em relação ao período anterior de 2011, porém o faturamento é significativamente menor.

## [Regiões](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Regi%C3%B5es.sql)
![image](https://github.com/user-attachments/assets/1c33827a-9983-47ad-ba2c-3f96d3bf592d)
![image](https://github.com/user-attachments/assets/d14d494f-1f74-4678-a098-9b1e6877aeeb)

Os dois países com maior participação nas vendas da empresa são Estados Unidos e Austrália, juntos somam aproximadamente 63% das vendas no e-commerce.

### Estados Unidos e Austrália
![image](https://github.com/user-attachments/assets/e412854d-c0d8-4b4d-b199-708f555feafa)
![image](https://github.com/user-attachments/assets/b1486160-1426-4043-9115-546b603e3893)

Analisando os dois países mais importantes para o e-commerce se observa uma queda na receita durante o ano de 2012 e um crescimento acentuado em 2013, chegando ao patamar de 280%

### Estados Unidos Trimestral
![image](https://github.com/user-attachments/assets/dab5d310-bc37-40e6-9886-bd79e9293582)
![image](https://github.com/user-attachments/assets/0f865147-5b83-463e-9e1e-63486a48bff9)

Analisando os trimestres dos Estados Unidos se verifica que a partir do segundo trimestre de 2012 ocorre uma queda nas Vendas que só é superada em 2013.

### Promoções
![image](https://github.com/user-attachments/assets/ad92d1b1-699d-494d-b9aa-e1abad6c2cdb)
![image](https://github.com/user-attachments/assets/6fdd94d7-2de7-4bde-a4c6-6c9146541466)

As vendas promocionais representam aproximidademente 4% das vendas totais, indicando que há um espaço para melhora.

## [Clientes](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Clientes.sql)
### Gênero
![image](https://github.com/user-attachments/assets/f4fc0cd9-fe13-496a-86c1-1709d0ff0055)
![image](https://github.com/user-attachments/assets/31faff53-d3e4-4feb-a7d9-ef34fdc87446)

A base de clientes é bem distribuída entre os gêneros Masculino e Feminino, sendo 51% e 49% respectivamente.

### Faixa Etária
![image](https://github.com/user-attachments/assets/a9486ae3-b624-4acf-a952-957bec214d75)
![image](https://github.com/user-attachments/assets/fd6d4f40-218a-435d-aef9-e3f26d749bf0)

A faixa etária entre 30-44 e 45-59 representa aproximadamente 83% da base de clientes.

### Clientes novos por ano
![image](https://github.com/user-attachments/assets/994f15c6-f6cf-4f0e-a01a-6c75ece241a4)
![image](https://github.com/user-attachments/assets/51a3f79e-ed03-47c6-8768-3821bba7c270)

A base de clientes foi expandida em 2013 cerca de 288%.

## [Vendas por categoria](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Produtos.sql)
![image](https://github.com/user-attachments/assets/2c2d7d87-e782-40a8-a701-b03b6161651d)
![image](https://github.com/user-attachments/assets/484880af-5e3d-4ef5-8ae3-0c424659b8c4)

A categoria "Accessories" representa a maior margem de lucro com 63%. As demais categorias, "Bikes" e "Clothing" possuem uma margem de 40%.
É interessante observar que entre as categorias o faturamento de "Bikes" representa um total de 97% do faturamento total.

### Top 5 produtos por venda
![image](https://github.com/user-attachments/assets/817eb89a-1b95-4cc0-8eb4-0055ea4753f9)
![image](https://github.com/user-attachments/assets/619b58f1-9ac0-4c62-bc60-021556e67c53)

Os produtos que elevaram o faturamento da empresa no e-commerce são modelos da Mountain-200.

### Top 5 produtos em compra conjunta
![image](https://github.com/user-attachments/assets/c262760d-e361-4515-9155-2ca1d50f97fa)
![image](https://github.com/user-attachments/assets/28b0cf0e-09bb-411f-a03d-ab9bbc006498)

Essa consulta retorna produtos que são comprados junto de outros, bens complementares.

### Top 5 produtos primeira compra
![image](https://github.com/user-attachments/assets/8887d5fc-ef57-4f74-9094-3054f70064a4)
![image](https://github.com/user-attachments/assets/a085a2b9-910e-4a17-aedf-e25f9e64a200)

Os produtos frequentemente escolhidos na primeira compra, ao comparar com os produtos que são comprados juntos indica que há uma possível relação entre eles. Mostrando que são produtos.

# Conclusão
A empresa Adventure Works possuí operações em seis países, dos quais dois se destacam no ambito de vendas. Estados Unidos e Austrália que juntos somam aproximadamente 63% das vendas da empresa. Analisando as compras realizadas em promoção fica evidente o baixo volume, cerca de apenas 4% das compras de todos os países foram utilizando descontos. Há uma oportunidade de aumentar o volume de vendas nos países ativando promoções mais atrativas aos clientes.
A base de clientes se expandiu no ano de 2013 ultrapassando a marca dos 10 mil novos clientes, atualmente é bem distribuída entre os gêneros e a maior concentração de faixa etária está entre os 30-44 anos. A menor faixa etária está entre 19-29 anos, caso se invista em marketing para essa faixa etária há uma possibilidade de fidelização dos clientes pelos próximos anos.
O carro chefe dos produtos é a categoria Bikes. Com as análises de produtos vendidos juntos e primeira majoritamente da caterogiria Accessories, que possuí uma margem elevada de 63%, promoções envolvendo esses itens podem fomentar novas compras e alavancar as vendas da empresa no e-commerce.
