--1
select *
from customer
where last_name like 'T%'
order by last_name ASC;

--2
select *
from rental
where return_date between '2005-05-28' and '2005-06-01';

--3
--I would use this query to determine which movies are rented the most :
select title, count(rental.rental_id) as rental_count
from film
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
group by title
order by rental_count desc;
--3 part 2 
select title, count(rental.rental_id) as rental_count
from film
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
group by title
order by rental_count desc
limit 10;

--4 
select customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as total_payed
from customer
join rental on customer.customer_id = rental.customer_id
join payment on rental.rental_id = payment.rental_id 
group by customer.customer_id ,customer.first_name , customer.last_name 
order by total_payed desc;

--5
select actor.actor_id, actor.first_name, actor.last_name , COUNT(film.film_id) AS movie_count
join actor
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
where film.release_year = 2006
group by actor.actor_id, actor.first_name, actor.last_name
order by movie_count desc;

--6
explain analyze
select customer.customer_id, sum(amount)
from payment
inner join customer on customer.customer_id = payment.cusromer_id
group by customer.customer_id
order by sum(amount);
--Sorts results by total spending (sum(payment.amount)), 
--processing 599 rows in 5.969–5.986 ms using quicksort (memory: 48kB).
--HashAggregate: Aggregates total spending per customer,
--grouped by customer.customer_id with a memory usage of 297kB (5.794–5.851 ms).
--Hash Join: Joins payment and customer tables based on customer_id,
--processing 14596 rows (0.132–3.412 ms).
--Sequential Scans:
--Scans the payment table (14596 rows) (0.009–0.881 ms).
--Scans the customer table (599 rows) (0.004–0.057 ms).
--Planning and Execution: Planning took 0.307 ms, with a total execution time of 6.068 ms.

explain analyze
select actor.first_name ||' '|| actor.last_name as actor_name, count(actor.actor_id) as total_movies
from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
where film.release_year = 2006
group by actor_name
order by total_movies desc
limit 1;
-- Only 1 result is returned after sorting (actual time: 1.590 ms).
--Actors are sorted by the count of movies they appeared in,
--using top-N heapsort (25kB memory).
--HashAggregate: Aggregates actor names and counts how many movies each appeared 
--in (actual time: 1.571 ms). Hash Join: Joins film_actor and film tables to get
--the list of actors and films released in 2006, using sequential scans 
--on both tables.
--Planning and Execution: The query completed in 1.609 ms.

—7 
select category.name  , avg(film.rental_rate) as avg_rental_rate
from category
join film_category on category.category_id = film_category.category_id 
join film on film_category.film_id = film.film_id 
group by category.name;


—8
select category.name , count(rental.rental_id) as rental_count , sum(payment.amount) as total_sales
from category
join film_category on category.category_id = film_category.category_id 
join film on film_category.film_id = film.film_id 
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
order by total_sales desc;


—extra credit
select category.name as category_name, 
       TO_CHAR(rental.rental_date, 'Month') as month, 
       count(rental.rental_id) as rental_count
from category
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
group by category.name, TO_CHAR(rental.rental_date, 'Month')
order by month, category_name 