## 2. Joining Three Tables ##

/*1. Escreva uma consulta que reúna dados sobre a fatura com um invoice_id igual a 4. Inclua as seguintes colunas em ordem:
    O id do track, track_id;
    O nome do track, track_name.
    O name do tipo de midia da track, track_type;
    O preço que o cliente pagou pela track, unit_price.
    A quantidade da track que foi comprada, quantity.
*/
SELECT
    il.track_id,
    t.name track_name,
    mt.name track_type,
    il.unit_price,
    il.quantity
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
WHERE il.invoice_id = 4;

## 3. Joining More Than Three Tables ##

/*1. Adicione a coluna com nome do artista na query da tela anterior.
    A coluna deverá se chamar artist_name;
    A coluna deverá estar entre track_name e track_type.
*/
SELECT
    il.track_id,
    t.name track_name,
    ar.name artist_name,
    mt.name track_type,
    il.unit_price,
    il.quantity
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
INNER JOIN album al ON al.album_id = t.album_id
INNER JOIN artist ar on ar.artist_id = al.artist_id
WHERE il.invoice_id = 4;

## 4. Combining Multiple Joins with Subqueries ##

/* 1. Escreva uma query que retorne o top 5 albuns, calculando o número de vezes que a track do album foi comprada. Sua query deverá estar ordenada da track mais comprada a menos comprada e retorna as sequintes colunas, nesta oredem:
    album, o título do album;
    artist, o artista que produziu o album;
    tracks_purchased,o total de compras da track do album.
*/
SELECT
    ta.album_title album,
    ta.artist_name artist,
    COUNT(*) tracks_purchased
FROM invoice_line il
INNER JOIN (
            SELECT
                t.track_id,
                al.title album_title,
                ar.name artist_name
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta
           ON ta.track_id = il.track_id
GROUP BY 1, 2
ORDER BY 3 DESC LIMIT 5;
    
    

## 5. Recursive Joins ##

/*Escreva uma query que retorne as informações de cada empregado e seu supervisor.
    O relatório deve incluir funcionários, mesmo que não se reporte a outro funcionário.
    O relatório deve ser classificado em ordem alfabética pela coluna employee_name.
    Sua query deverá retorna as seguintes colunas, nesta ordem:
        employee_name - deve conter o nome completo que estão em conlunas separadas como first_name e last_name;
        employee_title - o cargo do empregado;
        supervisor_name - o nome completo do supervisor como na coluna employee_name;
        supervisor_title - o cargo da pessoa que o empregado deverá se reportar.
*/
SELECT
    e1.first_name || " " || e1.last_name employee_name,
    e1.title employee_title,
    e2.first_name || " " || e2.last_name supervisor_name,
    e2.title supervisor_title
FROM employee e1
LEFT JOIN employee e2 ON e1.reports_to = e2.employee_id
ORDER BY 1;

## 6. Pattern Matching Using Like ##

/*1. Escreva um query que encontre destalhes do contato da consumidora Belle que esteja no first_name da database. Sua query deverá conter as seguintes colunas, nesta ordem: first_name, last_name , phone.
*/
SELECT
    first_name,
    last_name,
    phone
FROM customer
WHERE first_name LIKE "%Belle%";

## 7. Generating Columns With The Case Statement ##

/*Escreva uma consulta que resuma as compras de cada cliente. Para os fins deste exercício, não temos dois clientes com o mesmo nome.
        Sua consulta deve incluir as seguintes colunas, em ordem:
            customer_name - contendo as colunas first_name e last_name separadas por um espaço, por exemplo, Luke Skywalker.
            number_of_purchases, contando o número de compras feitas por cada cliente.
            total_spent - a soma total de dinheiro gasto por cada cliente.
            customer_category - uma coluna que categoriza o cliente com base no total de compras. A coluna deve conter os seguintes valores:
                small spender - se o total de compras do cliente for inferior a US $ 40.
                big spender - se o total de compras do cliente for superior a US $ 100.
                regular - se o total de compras do cliente estiver entre US $ 40 e US $ 100 (inclusive).
Ordene seus resultados pela coluna customer_name.
*/
SELECT
   c.first_name || " " || c.last_name customer_name,
   COUNT(i.invoice_id) number_of_purchases,
   SUM(i.total) total_spent,
   CASE
       WHEN sum(i.total) < 40 THEN 'small spender'
       WHEN sum(i.total) > 100 THEN 'big spender'
       ELSE 'regular'
       END
       AS customer_category
FROM invoice i
INNER JOIN customer c ON i.customer_id = c.customer_id
GROUP BY 1 ORDER BY 1;