-- The Basics of SQL

/* 1) Selecting data based on criteria (aka constraints)
	
    "We need to understand the special features in our films. Could you pull a list of films which include
    a 'Behind the Scenes' special feature?"
*/
	SELECT *
	FROM film
	WHERE special_features LIKE '%Behind the Scenes%'
    
/* 2) Aggregation functions and grouping
	
    "I'm wondering if we charge more for a rental when the replacement cost is higher. Will you pull me a
    list of some basic stats about our movies grouped by replacement cost?
*/
	SELECT
		replacement_cost,
		COUNT(film_id) AS title_count,
		MIN(rental_rate) AS cheapest_rate,
		MAX(rental_rate) AS most_expensive_rate,
		AVG(rental_rate) AS average_rate
	FROM film
	GROUP BY
		replacement_cost
	ORDER BY
		replacement_cost

/* 3) Narrowing aggregation results based on criteria

	"I'd like to talk to customers that have not rented much from us to understand if there is something
    we could be doing better. Could you pull a list of customer_ids with less than 15 rentals all-time?
*/
	SELECT
		customer_id,
		COUNT(rental_id) AS rental_count
	FROM rental
	GROUP BY
		customer_id
	HAVING COUNT(rental_id) < 15

-- Intermediate to Advanced SQL

/* 4) Using the CASE statement to "bucket" data into customized groups

	"I'd like to know which store each customer goes to, and whether or not they are active. Could you
    pull me something like this?"
*/
	SELECT
		first_name,
		last_name,
		CASE
			WHEN store_id = 1 AND active = 1 THEN 'S1 Active'
			WHEN store_id = 1 AND active = 0 THEN 'S1 Inactive'
			WHEN store_id = 2 AND active = 1 THEN 'S2 Active'
			WHEN store_id = 2 AND active = 0 THEN 'S2 Inactive'
		END AS store_and_status
	FROM customer
 
 /* 5) Or, if our uncle prefers, using CASE + COUNT to aggregate our data into categorized counts.
*/
	SELECT
		CASE
			WHEN store_id = 1 AND active = 1 THEN 'S1 Active'
			WHEN store_id = 1 AND active = 0 THEN 'S1 Inactive'
			WHEN store_id = 2 AND active = 1 THEN 'S2 Active'
			WHEN store_id = 2 AND active = 0 THEN 'S2 Inactive'
		END AS store_and_status,
		COUNT(customer_id) AS num_of_customers
	FROM customer
	GROUP BY
		store_and_status
        
/* 6) BONUS: Pivoting to more efficiently present our aggregation.
*/
	SELECT
		store_id,
		COUNT(CASE WHEN active = 1 THEN customer_id ELSE NULL END) AS active,
        COUNT(CASE WHEN active = 0 THEN customer_id ELSE NULL END) AS inactive
	FROM customer
    GROUP BY
		store_id

/* 7) Using left join to query two tables at once, wishing to include results
	from our first that don't have matching results in our second.

	"One of our investors is interested in the films we carry and how many actors are listed for each
    title. Can you pull a list of all titles, and figure out how many actors are associated with each
    one?"
*/
	-- STEP ONE
    SELECT
		film.title,
		film_actor.actor_id
	FROM film
		LEFT JOIN film_actor
			ON film_actor.film_id = film.film_id
	-- STEP TWO
    SELECT
		film.title,
		COUNT(film_actor.actor_id) AS num_actors
	FROM film
		LEFT JOIN film_actor
			ON film_actor.film_id = film.film_id
	GROUP BY
		film.title

/* 8) Joining a first table to a third table via an intermediary "bridge" table in order to join data
	from tables without common keys
    
    "Customers often ask which films their favorite actors appear in. It would be great to have a list
    of all actors, with each title that they appear in. Could you pull that for me?"
*/
	SELECT
		actor.first_name,
		actor.last_name,
		film.title
	FROM actor
		JOIN film_actor
			ON actor.actor_id = film_actor.actor_id
		JOIN film
			ON film_actor.film_id = film.film_id
	ORDER BY
		last_name, first_name







