# Introdução
No cenário atual, em um mundo cada vez mais digital, o e-commerce se tornou peça-chave de muitas empresas. A análise de desempenho de vendas pela internet é fundamental para empresas que busquem otimizar seus resultados.
O Data Warehouse ***AdventureWorksDW2022***, disponibilizado pela Microsoft, oferece um cenário ideal para o desenvolvimento de análises estratégicas e financeiras. Ele simula um ambiente corporativo com dados de uma empresa fictícia chamada Adventure Works, que opera no setor de varejo, com foco no e-commerce e operações globais.

# Objetivo
O projeto tem como finalidade realizar uma análise exploratória dos dados referente ao desempenho por região, características dos clientes e análise dos produtos.

Aqui você encontra a solução para essas questões utilizando a ferramenta [Power BI](https://app.powerbi.com/view?r=eyJrIjoiNzQyNmZhOTQtNjA4Yi00ZjliLWFjMTYtYWIwYTVhODQ2ODZiIiwidCI6IjYzZTE3ZmYzLWE1NjAtNGNhYS04ZTNlLTg0MjNjMzI4YzI5OCJ9).

# Ferramentas
<img
  src="https://64.media.tumblr.com/ec57a9abccbdfcfdd234a1d7ce60872e/1adc0a0257f98ada-4a/s540x810/dc16e674cca039859d5abecae9dbf71d1afbadd5.pnj" width="20" height="20" /> **Microsoft SQL Server**: A Linguagem de consulta estruturada (SQL)

# Desenvolvimento
## Tabelas Fato
O Data Warehouse AdventureWorksDW2022 é composto por tabelas do tipo fato que centralizam as informações e tabelas dimensão fornecem informações descritivas e categóricas que contextualizam as análises.

A análise ocorrerá utilizando a tabela [FactInternetSales](https://github.com/user-attachments/assets/1dba6612-453e-4744-982e-7504354b9dba), uma vez que ela é a mais indicada para explorar os indicadores financeiros associados às vendas online.

## [Modelo de Dados](https://github.com/user-attachments/assets/e067f97d-1379-4cd5-90eb-0883e5329079)
O modelo de dados do AdventureWorksDW2022, baseado na tabela FactInternetSales, segue o esquema estrela (Star Schema). Nesse modelo, a tabela fato centraliza os dados, enquanto as tabelas dimensão fornecem informações descritivas. Além disso, o modelo apresenta relacionamentos do tipo 1:N, indicando que cada registro das tabelas dimensão pode estar associado a múltiplos registros da tabela fato.

## [Limpeza e tratamento de Dados](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Tratamento%20de%20Dados.sql)
### Deletando Registros Incompletos de Venda
![image](https://github.com/user-attachments/assets/fb3c59d7-5e17-46a7-a99f-38fec07c29c0)
![image](https://github.com/user-attachments/assets/2390b843-cb1f-487b-beb8-f14eb48a81a3)

"Conforme constatado, os anos de 2010 e 2014 não possuem registros anuais completos, o que pode impactar análises futuras. Para garantir a consistência das análises, a abordagem adotada foi a remoção integral desses valores. No entanto, essa decisão está alinhada ao escopo proposto pelo projeto. Cada situação exige uma análise prévia e específica; neste caso, a abordagem adotada atende às necessidades imediatas, sem comprometer outras análises.

![image](https://github.com/user-attachments/assets/6d019de0-3ec6-4429-863c-975390573872)
![image](https://github.com/user-attachments/assets/ffe16b41-f817-4478-a414-c05ea080ec76)

A tabela FactInternetSalesReason possui uma chave estrangeira que faz referência à tabela FactInternetSales. Isso significa que não é possível excluir registros da tabela FactInternetSales enquanto houver registros associados na FactInternetSalesReason, devido à restrição de integridade referencial.
Portanto, é necessário excluir primeiro os registros na tabela FactInternetSalesReason que estão relacionados aos da FactInternetSales.
Após essa etapa, foi possível excluir os registros da tabela FactInternetSales com sucesso.

### Verificação de Nulos nas Chaves Estrangeiras
![image](https://github.com/user-attachments/assets/b0460f46-6749-42be-97ef-1579dabff5e3)
![image](https://github.com/user-attachments/assets/27ce43dc-a183-463f-9cc1-c3dc3e25a858)

Nenhuma chave estrangeira apresenta valores nulos.

### Valores Nulos Tabelas Relacionadas
![image](https://github.com/user-attachments/assets/13efd8c9-d36e-457a-b9a8-2626860d3fdd)
![image](https://github.com/user-attachments/assets/8864f8fc-7941-4970-89e2-7f40fae9da09)

A consulta identificou 209 registros com valores nulos na coluna 'ProductSubcategoryKey', o que pode indicar produtos não devidamente associados a uma subcategoria. Para preservar a consistência dos dados e assegurar a qualidade das análises, optou-se pela exclusão desses registros. No entanto, antes da remoção, foi realizada uma verificação para assegurar que tais registros não possuíam valores vinculados à métrica 'SalesAmount'.

![image](https://github.com/user-attachments/assets/6c64308b-747b-4ab4-9c94-e17f8ec6822f)
![image](https://github.com/user-attachments/assets/fba3ff0f-568f-4ef4-9c2c-50aa435ec1d9)

A análise realizada demonstrou que os registros com valores nulos na coluna 'ProductSubcategoryKey' não possuem valores associados na métrica 'SalesAmount'. Dessa forma, a exclusão desses registros foi considerada viável, uma vez que não comprometem a integridade das análises de vendas. Essa decisão visa garantir a consistência dos dados utilizados no processo analítico, eliminando potenciais ruídos causados por entradas incompletas.

### Deletando Registros Nulos
![image](https://github.com/user-attachments/assets/ef0fbee3-fe80-4672-aa9d-a404f3bcdee9)
![image](https://github.com/user-attachments/assets/6925db6a-b618-497a-a7d4-c9de90b3b693)

Novamente, para garantir a integridade referencial do banco de dados, é necessário realizar previamente a exclusão dos registros na tabela FactProductInventory. Após essa etapa, foi possível remover com sucesso os registros correspondentes na tabela DimProduct.

## [Análise Temporal](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/An%C3%A1lise%20Temporal.sql)
![image](https://github.com/user-attachments/assets/f3c67612-1332-4974-8000-9ad461bc0282)
![image](https://github.com/user-attachments/assets/8e02e628-8b59-441f-8abf-6e573266eadc)

Em 2013, houve um salto no volume de vendas, indicando expansão do e-commerce. A introdução de produtos de menor valor a partir de 2012 reduziu o ticket médio, mas aumentou significativamente a quantidade de transações. Apesar disso, o faturamento não cresceu na mesma proporção, sugerindo uma estratégia focada em volume. A alta variabilidade nos valores reforça a diversificação da oferta.

## [Regiões](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Regi%C3%B5es.sql)
![image](https://github.com/user-attachments/assets/1c33827a-9983-47ad-ba2c-3f96d3bf592d)
![image](https://github.com/user-attachments/assets/d14d494f-1f74-4678-a098-9b1e6877aeeb)

Estados Unidos e Austrália concentram cerca de 63% das vendas da empresa. A margem de lucro entre os países é estável, em torno de 41%, sugerindo equilíbrio entre custo e receita. França, Alemanha e Reino Unido sustentam participação relevante. O Canadá, embora com menor volume, mantém rentabilidade compatível com os demais mercados.

### Estados Unidos e Austrália
![image](https://github.com/user-attachments/assets/e412854d-c0d8-4b4d-b199-708f555feafa)
![image](https://github.com/user-attachments/assets/b1486160-1426-4043-9115-546b603e3893)

Após queda nas vendas em 2012, Austrália e Estados Unidos apresentaram forte recuperação em 2013. Os EUA cresceram +280%, enquanto a Austrália teve um aumento de +103%, indicando uma possível mudança de estratégia ou expansão comercial. O padrão reforça a importância de ambos no desempenho global do e-commerce.

### Estados Unidos Trimestral
![image](https://github.com/user-attachments/assets/dab5d310-bc37-40e6-9886-bd79e9293582)
![image](https://github.com/user-attachments/assets/0f865147-5b83-463e-9e1e-63486a48bff9)

As vendas nos EUA caíram acentuadamente ao longo de 2012, com quedas superiores a 50% a partir do 2º trimestre. A retomada ocorreu apenas em 2013, com crescimento expressivo e consistente ao longo dos trimestres, indicando uma virada estratégica ou recuperação do mercado.

### Promoções
![image](https://github.com/user-attachments/assets/ad92d1b1-699d-494d-b9aa-e1abad6c2cdb)
![image](https://github.com/user-attachments/assets/6fdd94d7-2de7-4bde-a4c6-6c9146541466)

As vendas promocionais representam cerca de 4% do total em todos os países, com baixa variação entre eles. Isso indica que promoções ainda não são amplamente utilizadas, abrindo espaço para estratégias mais agressivas nesse canal. Potencial de crescimento via campanhas promocionais.

## [Clientes](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Clientes.sql)
### Gênero
![image](https://github.com/user-attachments/assets/f4fc0cd9-fe13-496a-86c1-1709d0ff0055)
![image](https://github.com/user-attachments/assets/31faff53-d3e4-4feb-a7d9-ef34fdc87446)

A base de clientes está bem distribuída entre os gêneros, com 51% do público masculino e 49% feminino. Esse equilíbrio indica um mercado homogêneo, permitindo estratégias comerciais abrangentes com pequenas variações direcionadas.

### Faixa Etária
![image](https://github.com/user-attachments/assets/a9486ae3-b624-4acf-a952-957bec214d75)
![image](https://github.com/user-attachments/assets/fd6d4f40-218a-435d-aef9-e3f26d749bf0)

As faixas etárias de 30 a 44 anos e 45 a 59 anos concentram a maior parte da base de clientes, representando aproximadamente 83% do total. Isso sugere que o e-commerce atrai predominantemente um público adulto em fase economicamente ativa, o que pode direcionar estratégias de marketing, produto e comunicação mais assertivas.

### Clientes novos por ano
![image](https://github.com/user-attachments/assets/994f15c6-f6cf-4f0e-a01a-6c75ece241a4)
![image](https://github.com/user-attachments/assets/51a3f79e-ed03-47c6-8768-3821bba7c270)

Em 2013, observou-se um aumento significativo no número de novos clientes, passando de 3.225 em 2012 para 12.536 em 2013 — um acréscimo de 9.311 clientes, representando um crescimento de aproximadamente 289% em relação ao ano anterior. Esse avanço evidencia uma expansão agressiva da base de consumidores no período.

## [Vendas por categoria](https://github.com/OtavioBlini/SQL---AdventureWorksDW2022/blob/main/SQL/Produtos.sql)
![image](https://github.com/user-attachments/assets/2c2d7d87-e782-40a8-a701-b03b6161651d)
![image](https://github.com/user-attachments/assets/484880af-5e3d-4ef5-8ae3-0c424659b8c4)

A categoria "Accessories" apresenta a maior margem de lucro entre as três, com 62,6%, enquanto "Bikes" e "Clothing" registram margens próximas a 40%. Apesar da menor rentabilidade relativa, "Bikes" concentra cerca de 97% do faturamento total, configurando-se como o principal motor de receita da operação.

### Top 5 produtos por venda
![image](https://github.com/user-attachments/assets/817eb89a-1b95-4cc0-8eb4-0055ea4753f9)
![image](https://github.com/user-attachments/assets/619b58f1-9ac0-4c62-bc60-021556e67c53)

Os cinco produtos mais vendidos pertencem à linha Mountain-200, com variações de cor e tamanho. Além de liderarem o faturamento, todos apresentam margem de lucro próxima a 45,6%, destacando-se como os principais impulsionadores da receita no e-commerce.

### Top 5 produtos em compra conjunta
![image](https://github.com/user-attachments/assets/c262760d-e361-4515-9155-2ca1d50f97fa)
![image](https://github.com/user-attachments/assets/28b0cf0e-09bb-411f-a03d-ab9bbc006498)

Os produtos mais frequentemente adquiridos em pedidos com múltiplos itens são acessórios e itens de reposição, como garrafas, kits de reparo e câmaras de ar. Isso indica um padrão de compra complementar, sugerindo oportunidades para estratégias de cross-selling no e-commerce.

### Top 5 produtos primeira compra
![image](https://github.com/user-attachments/assets/8887d5fc-ef57-4f74-9094-3054f70064a4)
![image](https://github.com/user-attachments/assets/a085a2b9-910e-4a17-aedf-e25f9e64a200)

Os produtos mais recorrentes na primeira compra — como garrafas, câmaras de ar e kits de remendo — também aparecem entre os itens mais comuns em compras conjuntas, indicando uma forte tendência de entrada por meio de produtos de baixo custo e alta utilidade. Isso sugere que esses itens funcionam como porta de entrada no e-commerce e podem ser estratégicos para ações de aquisição e fidelização.

# Conclusão
### Desempenho por Região
- Estados Unidos e Austrália concentram 63% do faturamento total, com os EUA sendo o principal mercado da empresa.
- Em 2012 houve uma queda significativa nas vendas trimestrais nos EUA, com recuperação apenas em 2013, quando as vendas cresceram mais de 300% em relação ao ano anterior.
- Vendas com promoção são baixas em todos os países, representando apenas cerca de 4% das vendas totais, o que indica oportunidade de alavancar vendas com estratégias promocionais regionais.

### Características dos Clientes
- A base de clientes é bem distribuída entre os gêneros, com uma leve maioria masculina (51%).
- A faixa etária predominante dos clientes está entre 30 e 59 anos, representando aproximadamente 83% da base.
- A expansão de clientes em 2013 foi massiva, com mais de 12 mil novos clientes — um crescimento de 288% comparado ao ano anterior.

### Análise dos Produtos
- A categoria “Bikes” domina o faturamento, representando 97% das vendas totais.
- Os produtos da linha Mountain-200 são os mais vendidos individualmente, todos com margens acima de 45%.
- Produtos como garrafas, kits de remendo e câmaras de ar destacam-se tanto em compras conjuntas quanto em primeiras compras — ideais para estratégias de entrada.
