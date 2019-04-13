USE sakila;
SELECT first_name, last_name from actor;
SELECT * from actor;
UPDATE actor 
SET Actor_Name = (UPPER(CONCAT(first_name, ' ', last_name)) ) ;
SELECT actor_id, first_name, last_name FROM actor 
Where first_name='Joe';
SELECT * FROM actor WHERE last_name LIKE '%GEN%';
SELECT last_name, first_name FROM actor WHERE last_name LIKE '%li%';

SELECT country_id, country FROM country 
WHERE country in ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor
DROP COLUMN description;

SELECT last_name, count(*) as last_name_count FROM  actor
GROUP BY last_name;

SELECT last_name, count(*) as last_name_count FROM  actor
GROUP BY last_name
HAVING last_name_count>1;

UPDATE actor
SET first_name='Harpo'
WHERE first_name = 'Groucho' and  last_name='Williams';
UPDATE actor
SET first_name='Groucho'
WHERE first_name = 'Harpo';

SHOW CREATE TABLE address;

SELECT * FROM address;
SELECT * FROM staff;
SELECT staff.first_name, staff.last_name, address.address
FROM staff
LEFT JOIN address
ON staff.address_id=address.address_id

SELECT * FROM payment;
SELECT staff.staff_id, staff.first_name, staff.last_name,
SUM(amount) as total_amount
FROM staff JOIN payment ON staff.staff_id=payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.staff_id;

SELECT film.film_id, film.title,count(film_actor.actor_id) as n_actors
FROM film INNER JOIN film_actor ON film.film_id=film_actor.film_id
GROUP BY film.film_id;

SELECT film.title, film.film_id, count(inventory.inventory_id) as n_inventory
FROM inventory LEFT JOIN film ON inventory.film_id=film.film_id
WHERE film.title='Hunchback Impossible'
GROUP BY film.film_id;

SELECT c.first_name, c.last_name, c.customer_id, 
sum(p.amount) as total_payment
FROM customer c JOIN payment p ON c.customer_id= p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

SELECT f.title, f.language_id
FROM film f
WHERE f.title like 'K%' or f.title like 'Q%' AND f.language_id=1;


SELECT film_actor.actor_id, film_actor.film_id, actor.first_name,actor.last_name
FROM film_actor LEFT JOIN actor ON film_actor.actor_id=actor.actor_id
WHERE film_actor.film_id=(SELECT film_id FROM film WHERE title='Alone Trip');



SELECT city.city_id,country.country_id,country.country
FROM country RIGHT JOIN city ON country.country_id=city.country_id
WHERE country.country='Canada';

SELECT address_id, city_id
FROM address;

SELECT b.address_id, b.customer_id, b.first_name, b.last_name, b.email, b.city_id, d.country, d.country_id
FROM (SELECT c.address_id, c.customer_id, c.first_name, c.last_name, c.email, a.city_id
FROM customer c LEFT JOIN (SELECT address_id, city_id
FROM address) AS a ON a.address_id=c.address_id) AS b LEFT JOIN
(SELECT city.city_id,country.country_id,country.country
FROM country RIGHT JOIN city ON country.country_id=city.country_id
WHERE country.country='Canada') as d ON b.city_id=d.city_id ;

SELECT category_id,name FROM category WHERE name='family';

SELECT a.film_id, a.category_id, film.title from 
(SELECT film_id, category_id FROM film_category WHERE category_id=8) as a
LEFT JOIN film ON film.film_id=a.film_id;

CREATE VIEW film_a as 
	SELECT r.inventory_id,r.rental_id, i.film_id 
	FROM rental r LEFT JOIN inventory i ON i.inventory_id=r.inventory_id;
CREATE VIEW film_b as 
SELECT count(film_id) as freq, film_id FROM film_a
GROUP BY film_id
ORDER BY freq DESC;
SELECT b.film_id,b.freq,t.title FROM film_b b 
LEFT JOIN film_text t ON b.film_id=t.film_id;

CREATE VIEW pp as 
SELECT p.staff_id, s.store_id , p.amount FROM payment p 
LEFT JOIN staff s ON s.staff_id=p.staff_id;

SELECT sum(amount) as total, store_id FROM pp
GROUP BY store_id

CREATE VIEW aa as
SELECT c.address_id, c.store_id, a.city_id FROM customer c
LEFT JOIN address a ON a.address_id=c.address_id;
CREATE VIEW bb as
SELECT city.country_id, country.country,city.city_id,city.city
FROM city LEFT JOIN country ON city.country_id=country.country_id;

SELECT aa.store_id, aa.city_id , bb.country, bb.city FROM aa
LEFT JOIN bb ON aa.city_id=bb.city_id;

CREATE VIEW fc as 
SELECT c.category_id, c.name , f.film_id FROM category c
LEFT JOIN film_category f ON f.category_id=c.category_id;
CREATE VIEW fi as 
SELECT fc.category_id, fc.film_id, fc.name , inventory.inventory_id FROM fc
RIGHT JOIN inventory ON fc.film_id=inventory.film_id;
CREATE VIEW fp as 
SELECT r.inventory_id, r.rental_id, p.payment_id , p.amount FROM rental r
LEFT JOIN payment p ON p.payment_id=r.rental_id;
CREATE VIEW ft as 
SELECT fp.inventory_id, fp.rental_id, fp.amount, fi.name FROM fp
LEFT JOIN fi ON fi.inventory_id=fp.inventory_id;

CREATE VIEW top_5_genres as
SELECT name, sum(amount) as total FROM ft
GROUP BY name
ORDER BY total DESC LIMIT 5;

DROP VIEW top_5_genres

