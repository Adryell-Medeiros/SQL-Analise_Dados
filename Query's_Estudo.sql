SELECT

-- (Exemplo 1) Seleção de uma coluna de uma tabela
-- Liste os e-mails dos clientes da tabela sales.customers
select email
from sales.customers

-- (Exemplo 2) Seleção de mais de uma coluna de uma tabela
-- Liste os emails e nomes dos clientes da tabela sales.customers
select email, first_name, last_name
from sales.customers

-- (Exemplo 3) Seleção de todas as colunas de uma tabela
-- Liste todos as informações dos clientes da tabela sales.customers
select *
from sales.customers


DISTINCT

-- (Exemplo 1) Seleção de uma coluna sem DISTINCT
-- Liste as marcas de carro que constam na tabela products
select brand from sales.products

-- (Exemplo 2) Seleção de uma coluna com DISTINCT
-- Liste as marcas de carro distintas que constam na tabela products
select distinct brand from sales.products

-- (Exemplo 3) Seleção de mais de uma coluna com DISTINCT
-- Liste as marcas e anos de modelo distintos que constam na tabela products
select distinct brand, model_year from sales.products


WHERE

-- (Exemplo 1) Filtro com condição única
-- Liste os emails dos clientes da nossa base que moram no estado de Santa Catarina
select email, state from sales.customers where state = 'SC'

-- (Exemplo 2) Filtro com mais de uma condição
-- Liste os emails dos clientes da nossa base que moram no estado de Santa Catarina
-- ou Mato Grosso do Sul
select email, state from sales.customers where state = 'SC' or state = 'MS'

-- (Exemplo 3) Filtro de condição com data
-- Liste os emails dos clientes da nossa base que moram no estado de Santa Catarina 
-- ou Mato Grosso do Sul e que tem mais de 30 anos
select email, state, birth_date from sales.customers where (state = 'SC' or state = 'MS') and birth_date <'1995-04-15'


ORDER BY

-- (Exemplo 1) Ordenação de valores numéricos
-- Liste produtos da tabela products na ordem crescente com base no preço
select *
from sales.products
order by price desc

-- (Exemplo 2) Ordenação de texto
-- Liste os estados distintos da tabela customers na ordem crescente
select distinct state
from sales.customers
order by state


LIMIT

-- (Exemplo 1) Seleção das N primeiras linhas usando LIMIT
-- Liste as 10 primeiras linhas da tabela funnel utilizando o LIMIT
select *
from sales.funnel
limit 10

-- (Exemplo 2) Seleção das N primeiras linhas usando LIMIT e ORDER BY
-- Liste os 10 produtos mais caros da tabela products com o comando LIMIT
select *
from sales.products
order by price desc
limit 10

OPERADORES ARITMÉTICOS

-- (Exemplo 1) Criação de coluna calculada
-- Crie uma coluna contendo a idade do cliente da tabela sales.customers
select email, birth_date, (current_date - birth_date)/365 as "idade do cliente"
from sales.customers


-- (Exemplo 2) Utilização da coluna calculada nas queries
-- Liste os 10 clientes mais novos da tabela customers
select email, birth_date, (current_date - birth_date)/365 as "idade do cliente"
from sales.customers
order by "idade do cliente"
limit 10

-- (Exemplo 3) Criação de coluna calculada com strings 
-- Crie a coluna "nome_completo" contendo o nome completo do cliente
select first_name || ' ' || last_name as nome_completo
from sales.customers


OPERADORES DE COMPARAÇÃO

-- (Exemplo 1) Uso de operadores como flag
-- Crie uma coluna que retorne TRUE sempre que um cliente for um profissional clt 
select
    customer_id,
    first_name,
    professional_status,
	(professional_status = 'clt') as professional_clt
from sales.customers


OPERADORES LÓGICOS

-- (Exemplo 1) Uso do comando BETWEEN 
-- Selecione veículos que custam entre 100k e 200k na tabela products
select *
from sales.products
where price >= 100000 and price <= 200000

select *
from sales.products
where price between 100000 and 200000

-- (Exemplo 2)  Uso do comando NOT
-- Selecione veículos que custam abaixo de 100k ou acima 200k 
select *
from sales.products
where price < 100000 or price > 200000

select *
from sales.products
where price not between 100000 and 200000

-- (Exemplo 3) Uso do comando IN
-- Selecionar produtos que sejam da marca HONDA, TOYOTA ou RENAULT
select *
from sales.products
where brand = 'HONDA' or brand = 'TOYOTA' or brand = 'RENAULT'

select *
from sales.products
where brand in ('HONDA', 'TOYOTA', 'RENAULT')

-- (Exemplo 4) Uso do comando LIKE (matchs imperfeitos)
-- Selecione os primeiros nomes distintos da tabela customers que começam
-- com as iniciais ANA
select distinct first_name
from sales.customers
where first_name = 'ANA'

select distinct first_name
from sales.customers
where first_name like 'ANA%'

-- (Exemplo 5) Uso do comando ILIKE (ignora letras maiúsculas e minúsculas)
-- Selecione os primeiros nomes distintos com iniciais 'ana'
select distinct first_name
from sales.customers
where first_name ilike 'ana%'


-- (Exemplo 6) Uso do comando IS NULL
-- Selecionar apenas as linhas que contém nulo no campo "population" na tabela
-- temp_tables.regions
select *
from temp_tables.regions
where population is null


FUNÇÕES AGREGADAS

-- (Exemplo 1) Contagem de todas as linhas de uma tabela
-- Conte todas as visitas realizadas ao site da empresa fictícia
select count(*)
from sales.funnel

-- (Exemplo 2) Contagem das linhas de uma coluna
-- Conte todos os pagamentos registrados na tabela sales.funnel 
select count(paid_date)
from sales.funnel


-- (Exemplo 3) Contagem distinta de uma coluna
-- Conte todos os produtos distintos visitados em jan/21
select count(distinct product_id)
from sales.funnel
where visit_page_date between '2021-01-01' and '2021-01-31'

-- (Exemplo 4) Calcule o preço mínimo, máximo e médio dos productos da tabela products
select min(price), max(price), avg(price)
from sales.products

-- (Exemplo 5) Informe qual é o veículo mais caro da tabela products
select max(price) from sales.products

select *
from sales.products
where price = (select max(price) from sales.products)


GROUP BY

-- (Exemplo 1) Contagem agrupada de uma coluna
-- Calcule o nº de clientes da tabela customers por estado
select state, count(*) as contagem
from sales.customers
group by state
order by contagem

-- (Exemplo 2) Contagem agrupada de várias colunas
-- Calcule o nº de clientes por estado e status profissional 
select state, professional_status, count(*) as contagem
from sales.customers
group by state, professional_status
order by state, contagem desc

-- (Exemplo 3) Seleção de valores distintos
-- Selecione os estados distintos na tabela customers utilizando o group by
select distinct state
from sales.customers

select state
from sales.customers
group by state


HAVING

-- (Exemplo 1) seleção com filtro no HAVING 
-- Calcule o nº de clientes por estado filtrando apenas estados acima de 100 clientes
select 
    state, 
    count(*)
from sales.customers
group by state
having count(*) > 100


JOIN

-- (Exemplo 1) Utilize o LEFT JOIN para fazer join entre as tabelas
-- temp_tables.tabela_1 e temp_tables.tabela_2
select * from temp_tables.tabela_1
select * from temp_tables.tabela_2

select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 t1
left join temp_tables.tabela_2 t2 on t1.cpf = t2.cpf

-- (Exemplo 2) Utilize o INNER JOIN para fazer join entre as tabelas
-- temp_tables.tabela_1 e temp_tables.tabela_2

select t1.cpf, t1.name, t2.state
from temp_tables.tabela_1 t1
inner join temp_tables.tabela_2 t2 on t1.cpf = t2.cpf

-- (Exemplo 3) Utilize o RIGHT JOIN para fazer join entre as tabelas
-- temp_tables.tabela_1 e temp_tables.tabela_2

select t2.cpf, t1.name, t2.state
from temp_tables.tabela_1 t1
right join temp_tables.tabela_2 t2 on t1.cpf = t2.cpf

-- (Exemplo 4) Utilize o FULL JOIN para fazer join entre as tabelas
-- temp_tables.tabela_1 e temp_tables.tabela_2

select t2.cpf, t1.name, t2.state
from temp_tables.tabela_1 t1
full join temp_tables.tabela_2 t2 on t1.cpf = t2.cpf

-- (Exemplo 5) Identifique qual é o status profissional mais frequente nos clientes 
-- que compraram automóveis no site

select c.professional_status, count(f.paid_date) as pagamentos
from sales.funnel f
left join sales.customers c on f.customer_id = c.customer_id
group by c.professional_status
order by pagamentos desc

-- (Exemplo 6) Identifique qual é o gênero mais frequente nos clientes que compraram
-- automóveis no site. Obs: Utilizar a tabela temp_tables.ibge_genders
select * from temp_tables.ibge_genders limit 10

select ibge.gender, count(f.paid_date)
from sales.funnel f
left join sales.customers c on f.customer_id = c.customer_id
left join temp_tables.ibge_genders ibge on lower(c.first_name) = ibge.first_name
group by ibge.gender

-- (Exemplo 7) Identifique de quais regiões são os clientes que mais visitam o site
-- Obs: Utilizar a tabela temp_tables.regions
select * from sales.customers limit 10
select * from temp_tables.regions limit 10

select r.region, count(f.visit_page_date) as visitas
from sales.funnel f
left join sales.customers c on f.customer_id = c.customer_id
left join temp_tables.regions r on lower(c.city) = lower(r.city) and lower(c.state) = lower(r.state)
group by r.region
order by visitas desc


UNION

-- (Exemplo 1) União simples de duas tabelas
-- Una a tabela sales.products com a tabela temp_tables.products_2

select * from sales.products
union all
select * from temp_tables.products_2


SUBQUERIES

-- (Exemplo 1) Subquery no WHERE
-- Informe qual é o veículo mais barato da tabela products

select *
from sales.products
where price = menor_preco

select *
from sales.products
where price = (select min(price) from sales.products)

-- (Exemplo 2) Subquery com WITH
-- Calcule a idade média dos clientes por status profissional

with tabela_idade as (
select professional_status, (current_date - birth_date)/365 as idade
from sales.customers
)

select professional_status, avg(idade) as idade_media
from tabela_idade
group by professional_status

-- (Exemplo 3) Subquery no FROM
-- Calcule a média de idades dos clientes por status profissional

select professional_status, avg(idade) as idade_media
from (select professional_status, (current_date - birth_date)/365 as idade
	from sales.customers) as tabela_idade
group by professional_status

-- (Exemplo 4) Subquery no SELECT
-- Na tabela sales.funnel crie uma coluna que informe o nº de visitas acumuladas 
-- que a loja visitada recebeu até o momento

select
	fun.visit_id,
	fun.visit_page_date,
	sto.store_name,
	(
		select count(*)
		from sales.funnel as fun2
		where fun2.visit_page_date <= fun.visit_page_date
			and fun2.store_id = fun.store_id
	) as visitas_acumuladas
from sales.funnel as fun
left join sales.stores as sto
	on fun.store_id = sto.store_id
order by sto.store_name, fun.visit_page_date

-- (Exemplo 5) Análise de recorrência dos leads
-- Calcule o volume de visitas por dia ao site separado por 1ª visita e demais visitas

with primeira_visita as (

	select customer_id, min(visit_page_date) as visita_1
	from sales.funnel
	group by customer_id

)

select
	fun.visit_page_date,
	(fun.visit_page_date <> primeira_visita.visita_1) as lead_recorrente,
	count(*)

from sales.funnel as fun
left join primeira_visita
	on fun.customer_id = primeira_visita.customer_id
group by fun.visit_page_date, lead_recorrente
order by fun.visit_page_date desc, lead_recorrente

-- (Exemplo 6) Análise do preço versus o preço médio
-- Calcule, para cada visita ao site, quanto o preço do um veículo visitado pelo cliente
-- estava acima ou abaixo do preço médio dos veículos daquela marca 
-- (levar em consideração o desconto dado no veículo)

with preco_medio as (

	select brand, avg(price) as preco_medio_da_marca
	from sales.products
	group by brand

)

select
	fun.visit_id,
	fun.visit_page_date,
	pro.brand,
	(pro.price * (1+fun.discount)) as preco_final,
	preco_medio.preco_medio_da_marca,
	((pro.price * (1+fun.discount)) - preco_medio.preco_medio_da_marca) as preco_vs_media

from sales.funnel as fun
left join sales.products as pro
	on fun.product_id = pro.product_id
left join preco_medio
	on pro.brand = preco_medio.brand


TRATAMENTO DE DADOS

-- (Exemplo 1) Agrupamento de dados com CASE WHEN
-- Calcule o nº de clientes que ganham abaixo de 5k, entre 5k e 10k, entre 10k e 
-- 15k e acima de 15k

with faixa_de_renda as (
	select
		income,
		case
			when income < 5000 then '0-5000'
			when income >= 5000 and income < 10000 then '5000-10000'
			when income >= 10000 and income < 15000 then '10000-15000'
			else '15000+'
			end as faixa_renda
	from sales.customers
)

select faixa_renda, count(*)
from faixa_de_renda
group by faixa_renda


-- (Exemplo 2) Tratamento de dados nulos com COALESCE
-- Crie uma coluna chamada populacao_ajustada na tabela temp_tables.regions e
-- preencha com os dados da coluna population, mas caso esse campo estiver nulo, 
-- preencha com a população média (geral) das cidades do Brasil
select * from temp_tables.regions limit 10

-- Opção 1
select
	*,
	case
		when population is not null then population
		else (select avg(population) from temp_tables.regions)
		end as populacao_ajustada

from temp_tables.regions

-- Opção 2
select
	*,
	coalesce(population, (select avg(population) from temp_tables.regions)) as populacao_ajustada
	
from temp_tables.regions


TRATAMENTO DE TEXTO

-- (Exemplo 1) Corrija o primeiro elemento das queries abaixo utilizando os comandos 
-- de tratamento de texto para que o resultado seja sempre TRUE 

select 'São Paulo' = 'SÃO PAULO'
select upper('São Paulo') = 'SÃO PAULO'


select 'São Paulo' = 'são paulo'
select lower('São Paulo') = 'são paulo'


select 'SÃO PAULO     ' = 'SÃO PAULO'
select trim('SÃO PAULO     ') = 'SÃO PAULO'


select 'SAO PAULO' = 'SÃO PAULO'
select replace('SAO PAULO', 'SAO', 'SÃO') = 'SÃO PAULO'


TRATAMENTO DE DATAS

-- (Exemplo 1) Soma de datas utilizando INTERVAL
-- Calcule a data de hoje mais 10 unidades (dias, semanas, meses, horas)

select current_date + 10
select (current_date + interval '10 weeks')::date
select (current_date + interval '10 months')::date
select current_date + interval '10 hours'



-- (Exemplo 2) Truncagem de datas utilizando DATE_TRUNC
-- Calcule quantas visitas ocorreram por mês no site da empresa

select visit_page_date, count(*)
from sales.funnel
group by visit_page_date
order by visit_page_date desc

select
	date_trunc('month', visit_page_date)::date as visit_page_month,
	count(*)
from sales.funnel
group by visit_page_month
order by visit_page_month desc


-- (Exemplo 3) Extração de unidades de uma data utilizando EXTRACT
-- Calcule qual é o dia da semana que mais recebe visitas ao site


select
	extract('dow' from visit_page_date) as dia_da_semana,
	count(*)
from sales.funnel
group by dia_da_semana
order by dia_da_semana


-- (Exemplo 4) Diferença entre datas com operador de subtração (-) 
-- Calcule a diferença entre hoje e '2018-06-01', em dias, semanas, meses e anos.

select (current_date - '2018-06-01')
select (current_date - '2018-06-01')/7
select (current_date - '2018-06-01')/30
select (current_date - '2018-06-01')/365


FUNÇÕES

-- (Exemplo 1) Crie uma função chamada DATEDIFF para calcular a diferença entre
-- duas datas em dias, semanas, meses, anos

select (current_date - '2018-06-01')
select (current_date - '2018-06-01')/7
select (current_date - '2018-06-01')/30
select (current_date - '2018-06-01')/365

select datediff('weeks', '2018-06-01', current_date)

create function datediff(unidade varchar, data_inicial date, data_final date)
returns integer
language sql

as

$$

	select
		case
			when unidade in ('d', 'day', 'days') then (data_final - data_inicial)
			when unidade in ('w', 'week', 'weeks') then (data_final - data_inicial)/7
			when unidade in ('m', 'month', 'months') then (data_final - data_inicial)/30
			when unidade in ('y', 'year', 'years') then (data_final - data_inicial)/365
			end as diferenca

$$

select datediff('years', '2021-02-04', current_date)



-- (Exemplo 2) Delete a função DATEDIFF criada no exercício anterior

drop function datediff


MANIPULAÇÃO DE TABELAS

-- (Exemplo 1) Criação de tabela a partir de uma query
-- Crie uma tabela chamada customers_age com o id e a idade dos clientes. 
-- Chame-a de temp_tables.customers_age

select
	customer_id,
	datediff('years', birth_date, current_date) idade_cliente
	into temp_tables.customers_age
from sales.customers

select *
from temp_tables.customers_age



-- (Exemplo 2) Criação de tabela a partir do zero
-- Crie uma tabela com a tradução dos status profissionais dos clientes. 
-- Chame-a de temp_tables.profissoes

select distinct professional_status
from sales.customers

create table temp_tables.profissoes (
	professional_status varchar,
	status_profissional varchar
)

insert into temp_tables.profissoes
(professional_status, status_profissional)

values
('freelancer', 'freelancer'),
('retired', 'aposentado(a)'),
('clt', 'clt'),
('self_employed', 'autônomo(a)'),
('other', 'outro'),
('businessman', 'empresário(a)'),
('civil_servant', 'funcionário público(a)'),
('student', 'estudante')

select * from temp_tables.profissoes



-- (Exemplo 3) Deleção de tabelas
-- Delete a tabela temp_tables.profissoes

drop table temp_tables.profissoes

-- (Exemplo 4) Inserção de linhas
-- Insira os status 'desempregado(a)' e 'estagiário(a)' na temp_table.profissoes

create table temp_tables.profissoes (
	professional_status varchar,
	status_profissional varchar
);

insert into temp_tables.profissoes
(professional_status, status_profissional)

values
('freelancer', 'freelancer'),
('retired', 'aposentado(a)'),
('clt', 'clt'),
('self_employed', 'autônomo(a)'),
('other', 'outro'),
('businessman', 'empresário(a)'),
('civil_servant', 'funcionário público(a)'),
('student', 'estudante')

select * from temp_tables.profissoes

insert into temp_tables.profissoes
(professional_status, status_profissional)

values
('unemployed', 'desempregado(a)'),
('trainee', 'estagiario(a)')



-- (Exemplo 5) Atualização de linhas
-- Corrija a tradução de 'estagiário(a)' de 'trainee' para 'intern' 

update temp_tables.profissoes
set professional_status = 'intern'
where status_profissional = 'estagiario(a)'

select * from temp_tables.profissoes



-- (Exemplo 6) Deleção de linhas
-- Delete as linhas dos status 'desempregado(a)' e 'estagiário(a)'

delete from temp_tables.profissoes
where status_profissional = 'desempregado(a)'
or status_profissional = 'estagiario(a)'

select * from temp_tables.profissoes

-- (Exemplo 7) Inserção de Colunas
-- Insira uma coluna na tabela sales.customers com a idade do cliente
alter table sales.customers
add customer_age int

select * from sales.customers limit 10

update sales.customers
set customer_age = datediff('years', birth_date, current_date)
where true


-- (Exemplo 8) Alteração do tipo da coluna
-- Altere o tipo da coluna customer_age de inteiro para varchar
alter table sales.customers
alter column customer_age type varchar

select * from sales.customers limit 10

-- (Exemplo 9) Alteração do nome da coluna
-- Renomeie o nome da coluna "customer_age" para "age"
alter table sales.customers
rename column customer_age to age

select * from sales.customers limit 10

-- (Exemplo 10) Deleção de coluna
-- Delete a coluna "age"

alter table sales.customers
drop column age


select * from sales.customers limit 10


#DESAFIO
-- (Exercício 1) Selecione os nomes de cidade distintas que existem no estado de
-- Minas Gerais em ordem alfabética (dados da tabela sales.customers)
select distinct city
from sales.customers
where state = 'MG'
order by city

-- (Exercício 2) Selecione o visit_id das 10 compras mais recentes efetuadas
-- (dados da tabela sales.funnel)
select visit_id 
from sales.funnel 
where paid_date is not null
order by paid_date desc
limit 10

-- (Exercício 3) Selecione todos os dados dos 10 clientes com maior score nascidos
-- após 01/01/2000 (dados da tabela sales.customers)
select *
from sales.customers
where birth_date >= '2000-01-01'
order by score desc
limit 10

-- (Exercício 4) Calcule quantos salários mínimos ganha cada cliente da tabela 
-- sales.customers. Selecione as colunas de: email, income e a coluna calculada "salários mínimos"
-- Considere o salário mínimo igual à R$1200
select email,
		income,
		(income / 1200) as "salarios minimos"
from sales.customers


-- (Exercício 5) Na query anterior acrescente uma coluna informando TRUE se o cliente
-- ganha acima de 5 salários mínimos e FALSE se ganha 4 salários ou menos.
-- Chame a nova coluna de "acima de 4 salários"
select email,
		income,
		(income / 1200) as "salarios minimos",
		((income/1200) > 4) as "acima de 4 salarios"
from sales.customers


-- (Exercício 6) Na query anterior filtre apenas os clientes que ganham entre
-- 4 e 5 salários mínimos. Utilize o comando BETWEEN
select email,
		income,
		(income / 1200) as "salarios minimos",
		((income/1200) > 4) as "acima de 4 salarios"
from sales.customers
where (income/1200) between 4 and 5


-- (Exercício 7) Selecine o email, cidade e estado dos clientes que moram no estado de 
-- Minas Gerais e Mato Grosso. 
select email,
		city,
		state
from sales.customers
where state in ('MG','MS')

select email,
		city,
		state
from sales.customers
where state = 'MG' or state = 'MS'


-- (Exercício 8) Selecine o email, cidade e estado dos clientes que não 
-- moram no estado de São Paulo.
select email, city, state
from sales.customers
where state not in ('SP')


-- (Exercício 9) Selecine os nomes das cidade que começam com a letra Z.
-- Dados da tabela temp_table.regions
select city
from temp_tables.regions
where city ilike 'z%'

-- (Exercício 10) Identifique quais as marcas de veículo mais visitada na tabela sales.funnel

select p.brand, count(visit_id) as visitas
from sales.funnel f 
left join sales.products p on f.product_id = p.product_id
group by p.brand
order by visitas desc

-- (Exercício 11) Identifique quais as lojas de veículo mais visitadas na tabela sales.funnel

select s.store_name, count(visit_id) as visitas
from sales.funnel f
left join sales.stores s on f.store_id = s.store_id
group by s.store_name
order by visitas desc

-- (Exercício 12) Identifique quantos clientes moram em cada tamanho de cidade (o porte da cidade
-- consta na coluna "size" da tabela temp_tables.regions)

select r.size, count(c.customer_id) as clientes
from sales.customers c
left join temp_tables.regions r on lower(c.city) = lower(r.city)
group by r.size
order by clientes

-- (Exercício 13) Crie uma coluna calculada com o número de visitas realizadas por cada
-- cliente da tabela sales.customers

with numero_de_visitas as (

	select customer_id, count(*) as n_visitas
	from sales.funnel
	group by customer_id

)

select
	cus.*,
	n_visitas

from sales.customers as cus
left join numero_de_visitas as ndv
	on cus.customer_id = ndv.customer_id


