## 1. Introducing Joins ##

/*Escreva uma query que retorne todas as colunas das tabelas facts e cities.
    Use o INNER JOIN para juntar as tabelas cities e facts;
    Junte as tabelas onde os valores são iguais facts_id e cities.facts_id;
    Limite na query apenas as 10 primeiras linhas.
*/
SELECT * FROM facts
INNER JOIN cities ON cities.facts_id = facts.id
LIMIT 10;

## 2. Understanding Inner Joins ##

/* Escreva uma query que:
    Junte as tabels cities e facts usando o INNER JOIN;
    Use o aliases para nomear as tabelas;
    Inclua, nestao ordem:
        Todas as colunas da cities;
        A coluna name do facts com o nome de country_name.
    Inclua apenas as 5 primeiras linhas.
*/
SELECT c.*, f.name as country_name from cities as c INNER JOIN facts as f ON c.facts_id = f.id limit 5;

## 3. Practicing Inner Joins ##

/* Escreva uma query que use o INNER JOIN para junta as 2 tabelas e retorne, nesta ordem:
    A coluna com os nomes dos paises, como country;
    A coluna com as capitais de cada país, como capital_city.
*/
SELECT f.name as country, c.name as capital_city from facts as f INNER JOIN cities as c ON c.facts_id = f.id WHERE c.capital = 1;

## 4. Left Joins ##

/* Escreva uma query que retorne os países que não exist na tabela cities:
    Sua query deverá retornar 2 colunas:
        O nome dos países, com nome country;
        A população do país.
    Use LEFT JOIN para juntas cities e facts.
    Inclua apenas os países do facts que não tem valor correspondente em cities.
*/
SELECT f.name as country, f.population 
FROM facts as f LEFT JOIN cities as c 
on c.facts_id = f.id
WHERE c.name is NULL;

## 6. Finding the Most Populous Capital Cities ##

/* Escreva uma query que retorne as 10 capitais com maior população em um rank do maior para o menor.
    Você deverá incluir as seguintes colunas, nesta odem:
        capital_city, o nome de city;
        country, o país a que a cidade pertece;
        population, a populção da cidade;
*/
SELECT c.name as capital_city, f.name as country, c.population 
FROM facts as f INNER JOIN cities c 
on c.facts_id = f.id WHERE c.capital = 1
ORDER BY 3 DESC LIMIT 10;

## 7. Combining Joins with Subqueries ##

SELECT c.name capital_city, f.name country, c.population population
FROM facts f
INNER JOIN (
            SELECT * FROM cities
            WHERE capital = 1
            AND population > 10000000
           ) c ON c.facts_id = f.id
ORDER BY 3 DESC;

## 8. Challenge: Complex Query with Joins and Subqueries ##

SELECT
    f.name country,
    c.urban_pop,
    f.population total_pop,
    (c.urban_pop / CAST(f.population AS FLOAT)) urban_pct
FROM facts f
INNER JOIN (
            SELECT
                facts_id,
                SUM(population) urban_pop
            FROM cities
            GROUP BY 1
           ) c ON c.facts_id = f.id
WHERE urban_pct > .5
ORDER BY 4 ASC;