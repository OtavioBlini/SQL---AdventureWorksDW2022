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

![image](https://github.com/user-attachments/assets/214bb3f8-4e60-464c-8f5a-16942e4c53b8)

Com esta consulta, se constata que os anos de 2010 e 2014 não possuem registros completos de vendas.

### Deletando Registros Incompletos de Venda
Conforme constatado os anos de 2010 e 2014 não possuem registros completos anuais, sendo assim podendo impactar em possíveis análises futuras. Para garantir a consistência das analises a abordagem adotada foi de remoção integral dos valores, entretanto essa decisão se baseia no escopo proposto pelo projeto. Cada situação requer uma análise prévia e singular, a abordagem adotada satisfaz as necessidades imediatas, sem comprometer outras análises.

![image](https://github.com/user-attachments/assets/1dc8893a-62d3-45f9-8073-5dbb06cfa76d)

![image](https://github.com/user-attachments/assets/9e2beb7c-9f11-4d80-b62b-1d4bd223f150)

****A tabela ***FactInternetSalesReason*** possui uma chave estrangeira que faz referência a tabela *FactInternetSales*. Isso significa que não é possível excluir registros na tabela *FactInternetSales* enquanto houver registros associados na *FactInternetSalesReason*, devido à restrição de integridade.

Portanto, é necessário excluir os registros na tabela *FactInternetSalesReason* que estão relacionados aos registros da tabela *FactInternetSales*.

![image](https://github.com/user-attachments/assets/1dae82b4-374f-415e-8673-3cf89be11996)

![image](https://github.com/user-attachments/assets/af8caf38-cabb-4cc6-914f-057bf243d141)

Após realizar esta consulta, foi possível excluir os registros da tabela FactInternetSales.

### Verificação de Nulos nas Chaves Estrangeiras
![image](https://github.com/user-attachments/assets/909f0a75-d166-469c-9172-1546ec095272)

![image](https://github.com/user-attachments/assets/27ce43dc-a183-463f-9cc1-c3dc3e25a858)

Nenhuma Chave Estrangeira apresenta valores nulos.

### Valores Nulos Tabelas Relacionadas
![image](https://github.com/user-attachments/assets/a26e341f-8878-4f6d-b5b8-071f5690121d)

![image](https://github.com/user-attachments/assets/8864f8fc-7941-4970-89e2-7f40fae9da09)

A consulta indicou que o campo 'ProductSubcategoryKey' possui  209 registros com valores nulos. Esses valores podem indicar produtos que não estão corretamente associados a uma subcategoria
A solução adotada nesse projeto foi de exclusão desses registros nulos, entretanto antes é necessário entender se há algum valor associado a venda com eles.

![image](https://github.com/user-attachments/assets/bc29a77e-25b8-4af8-8739-c7d628542362)

![image](https://github.com/user-attachments/assets/12a9bf57-fa45-4226-aad8-ceb3e7026cbd)


A consulta indicou que não há valores na coluna SalesAmount associados a produtos nulos. Sendo assim possível a exclusão desses registros sem nenhum prejuízo as análises.

### Deletando Registros Nulos
![image](https://github.com/user-attachments/assets/f37c962c-cc42-4f0a-b542-2f488b17aa56)

![image](https://github.com/user-attachments/assets/b9240366-4e53-4e9c-a86d-bfd0b8f56ca8)


Novamente, para garantir a integridade é necessário realizar a exclusão primeiro na tabela FactProductInventory.

![image](https://github.com/user-attachments/assets/6925db6a-b618-497a-a7d4-c9de90b3b693)

![image](https://github.com/user-attachments/assets/521abeef-7015-4b64-aa9e-79cd3b28569b)

Após realizar esta consulta, foi possível excluir os registros da tabela DimProduct.

## Análise de Vendas
### Analise Exploratória de Vendas
![image](https://github.com/user-attachments/assets/1793849b-7c96-4288-9bf7-dcb636bbeaba)

![image](https://github.com/user-attachments/assets/804bdbc4-05f1-4ec4-b4fa-95a18ebec514)

### Análise de Vendas por Ano
![image](https://github.com/user-attachments/assets/467e3655-a7e4-4dad-80e0-e7e1056bfd80)

![image](https://github.com/user-attachments/assets/2b0b9038-b0a3-4452-a261-363cd57e1e17)

### Crescimento Anual
![image](https://github.com/user-attachments/assets/f3033a98-d889-4620-a325-46c88f8f162e)

![image](https://github.com/user-attachments/assets/f2851748-3a85-48b7-8ce0-0548906e3379)

### Crescimento Trimestral
![image](https://github.com/user-attachments/assets/19828e98-e659-43ce-9329-737ac08d49ab)

![image](https://github.com/user-attachments/assets/0a9dfa8b-5d8a-498b-be40-535eaeb5ac95)

### Faturamento por Categoria
![image](https://github.com/user-attachments/assets/b833bcf1-ac98-40a1-bf65-5084aa510cd7)

![image](https://github.com/user-attachments/assets/9887b72b-e14a-4c8f-81ac-b9344395c29c)

### Top 10 mais Vendidos
![image](https://github.com/user-attachments/assets/bb9680d8-f8fa-4bd9-a692-e3604ac244e6)

![image](https://github.com/user-attachments/assets/d0ac585f-d675-4531-9c9e-44f5b143146b)

### Top 10 Vendidos em Conjunto
![image](https://github.com/user-attachments/assets/c923829f-59c0-4754-9fc2-205c05d3a3a0)

![image](https://github.com/user-attachments/assets/e3fe2471-5d78-4776-b3cd-4cc1ade1c81d)

### Top 10 produtos Primeira Compra
![image](https://github.com/user-attachments/assets/f1c4ce0d-ee27-473f-84be-6f7e89cc4c34)

![image](https://github.com/user-attachments/assets/f56197a4-5845-4239-ad3e-d77ccc8debd9)

