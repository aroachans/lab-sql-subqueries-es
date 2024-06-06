-- Desafio 1. ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?
-- no se si lo tiene en inglés, así que primero miro todos los titulos y filtro imp para acotar

SELECT title
FROM film;

-- ahora ya si puedo empezar: 
SELECT COUNT(*) AS total_copies
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'HUNCHBACK IMPOSSIBLE';

-- Desafio 2. Lista todas las películas cuya duración sea mayor que el promedio de todas las películas.
-- primero tengo que encontrar el promedio de todas
SELECT AVG(length) AS average_length
FROM film;

-- y ahora buscar cuales tienen una duracion superior

SELECT title, length
FROM film
WHERE length > 115.2720;

-- Desafio 3. Usa subconsultas para mostrar todos los actores que aparecen en la película Viaje Solo.
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    WHERE fa.film_id = (
        SELECT f.film_id
        FROM film f
        WHERE f.title = 'ALONE TRIP'
    )
);

-- Desafio 4. Las ventas han estado disminuyendo entre las familias jóvenes, y deseas dirigir todas las películas familiares a una promoción. Identifica todas las películas categorizadas como películas familiares.
-- identifico primero
SELECT category_id, name
FROM category;
-- y ahora busco en dicha categoria

SELECT f.film_id, f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

-- Desafio 5. Obtén el nombre y correo electrónico de los clientes de Canadá usando subconsultas. Haz lo mismo con uniones. Ten en cuenta que para crear una unión, tendrás que identificar las tablas correctas con sus claves primarias y claves foráneas, que te ayudarán a obtener la información relevante.
--  buscamos que sea solo canada
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address
    WHERE city_id IN (
        SELECT city_id
        FROM city
        WHERE country_id = (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Desafio 6. ¿Cuáles son las películas protagonizadas por el actor más prolífico? El actor más prolífico se define como el actor que ha actuado en el mayor número de películas. Primero tendrás que encontrar al actor más prolífico y luego usar ese actor_id para encontrar las diferentes películas en las que ha protagonizado.
-- primero tengo que ver cual s el actor

SELECT actor_id, COUNT(*) AS total_films
FROM film_actor
GROUP BY actor_id
ORDER BY total_films DESC
LIMIT 1;
-- ahora tengo que ver quien es ese actor, me sale el actor_id 107
SELECT first_name, last_name
FROM actor
WHERE actor_id = 107;

-- es gina degeneres!
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (107);

-- desafio 7. Películas alquiladas por el cliente más rentable. Puedes usar la tabla de clientes y la tabla de pagos para encontrar al cliente más rentable, es decir, el cliente que ha realizado la mayor suma de pagos.
-- primero encontrar el cliente que ha hecho mas pagos
SELECT customer_id, SUM(amount) AS total_payments
FROM payment
GROUP BY customer_id
ORDER BY total_payments DESC
LIMIT 1;
-- es el customer_id 526, ahroa quiero ver quien es
SELECT first_name, last_name
FROM customer
WHERE customer_id = 526;

-- es karl seal
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.customer_id = (526);

-- desafio 8.Obtén el client_id y el total_amount_spent de esos clientes que gastaron más que el promedio del total_amount gastado por cada cliente
-- primero tengo que calcular cual es el promedio, y luego aquellos que lo superan
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS average_amount
);
----- desafio extra
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount_spent
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS average_amount
);

 










