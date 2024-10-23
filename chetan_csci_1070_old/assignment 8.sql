--Question 1
alter table rental
add column status VARCHAR(10);

update rental
set status = case
    when return_date > rental_date + INTERVAL '1 day' * (
        select rental_duration from film 
        join inventory on film.film_id = inventory.film_id
        where inventory.inventory_id = rental.inventory_id) then 'Late'
    when return_date < rental_date + INTERVAL '1 day' * (
        select rental_duration from film 
        join inventory on film.film_id = inventory.film_id
        where inventory.inventory_id = rental.inventory_id) then 'Early'
    else 'On time'
end;


--Question 2
select city_id , sum(amount) as total_spent
from address 
join customer on address.address_id = customer.address_id
join payment on customer.customer_id = payment.customer_id
where city_id = 314 and city_id = 975
group by city_id;

--Question 3
select category.name , count(film.film_id) as total_per_category
from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
group by category.name;

--Question 4

The are two different tables for catgory and film_category , because their need to be a way to connect the film and category tables attaching the category to the film.;

--Question 5

select film.film_id , film.title,film.length 
from film
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
where return_date between '05-15-2005' and '05-31-2005'; 

--Question 6

select film.title , avg(amount) as below_avg
from payment 
join rental on payment.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on inventory.film_id = film.film_id
where payment.amount < (select avg(amount)from payment)
group by film.title;

--Question 7

select status , count(film.film_id) as film_count
from rental 
join inventory on rental.inventory_id = inventory.inventory_id
join film on inventory.film_id = film.film_id
group by status;

--Question 8

select film.title,film.length, percent_rank() over (order by film.length) as percentile_rank
from film;

--Question 9
explain analyze
select city, sum(amount) as total_payments
from payment
join customer on payment.customer_id = customer.customer_id
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
where city.city in ('Kansas City', 'Saint Louis')
group by city;

explain analyze
select film.film_id, film.title, film.rental_rate
from where film.rental_rate < (select avg(rental_rate) from film);

--extra credit
-- staff_id is what is the wrong relatioship because it doesnt have a connection with rental 
--Set-based programming deals with large sets of data at a time. SQL is a set-based programming language where one operation can work on many rows of data. Procedural Programming: program style in which problems are solved in a step-by-step fashion, often operating over and over with small items of information or repeated iterations of over data. Examples include Python where, by the use of procedures or functions, a program explicitly defines the program logic as in procedural programming.