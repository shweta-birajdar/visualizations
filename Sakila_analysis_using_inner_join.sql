use sakila;

-- 1.1 Contribution of Countries & Cities by rental amount

select count(r.rental_id) as 'No.of rentals', ci.city as 'CITY', co.country as 'COUNTRY', sum(p.amount) as 'Rental Amount'
from customer c 
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
group by ci.city, co.country;

-- 1.2 Rental amounts by countries for PG & PG-13 rated films

select count(r.rental_id) as 'No.of rentals', co.country, sum(p.amount) as 'Rental Amount',
f.rating
from customer c 
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
-- where rating = 'PG' or rating ='PG-13'
group by co.country;

-- 1.3 Top 20 cities by number of customers who rented

select count(r.rental_id) as 'No.of rentals', ci.city, sum(p.amount) as 'Rental Amount',
count(c.customer_id) as 'No. of customers'
from  address a 
inner join customer c on c.address_id = a.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
group by ci.city
order by count(c.customer_id) desc
limit 20;

-- 1.4  Top 20 cities by number of films rented

select count(r.rental_id) as 'No.of rentals', ci.city, sum(p.amount) as 'Rental Amount'
from customer c 
inner join address a on a.address_id = c.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
group by ci.city
order by count(rental_id) desc
limit 20;

-- 1.5 Rank cities by average rental cost

select count(r.rental_id) as 'No.of rentals', ci.city, avg(p.amount) as 'AVG Rental Amount'
from address a 
inner join customer c on c.address_id = a.address_id
inner join city ci on ci.city_id = a.city_id
inner join country co on co.country_id = ci.country_id
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
group by ci.city
order by avg(p.amount) desc;



-- 2.1 Film categories by rental amount (ranked) & rental quantity

select f.title, f.rental_rate, count(r.rental_id) as 'No. of Rentals', c1.name
from film_category c
inner join film f on f.film_id = c.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join category c1 on c1.category_id = c.category_id
group by c1.name
order by f.rental_rate desc;

-- 2.2 Film categories by rental amount (ranked)

select c1.name as 'Category',f.title, f.rental_rate
from film_category c
inner join film f on f.film_id = c.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join category c1 on c1.category_id = c.category_id
group by c1.name, f.title
order by f.rental_rate desc;

-- 2.3 Film categories by average rental amount (ranked)

select c1.name as 'Category', avg(f.rental_rate)
from film_category c
inner join film f on f.film_id = c.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join category c1 on c1.category_id = c.category_id
group by c1.name
order by avg(f.rental_rate) desc;

-- 2.4 Contribution of Film Categories by number of customers

select c1.name as 'Category', f.rental_rate, count(r.rental_id) as 'No. of customers'
from film_category c
inner join film f on f.film_id = c.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join category c1 on c1.category_id = c.category_id
group by c1.name
order by count(r.rental_id) desc;

-- 2.5 Contribution of Film Categories by rental amount

select c1.name as 'Category', f.rental_rate
from film_category c
inner join film f on f.film_id = c.film_id
inner join inventory i on i.film_id = f.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join category c1 on c1.category_id = c.category_id
group by c1.name
order by f.rental_rate desc;



-- 3.1 List Films with rental amount, rental quantity, rating, rental rate, replacement cost and category name

Select r1.film_id, r1.title, sum(p.amount), COUNT(r.rental_id), 
r1.rating, r1.rental_rate, r1.replacement_cost,r4.name
from film r1
inner join inventory i on i.film_id = r1.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join film_category c1 on c1.film_id = r1.film_id
inner join category r4 on r4.category_id = c1.category_id 
GROUP BY r1.film_id, r1.title;

-- 3.2 List top 10 Films by rental amount (ranked)

Select r1.film_id, r1.title, sum(p.amount), COUNT(r.rental_id), 
r1.rating, r1.rental_rate, r1.replacement_cost,r4.name
from film r1
inner join inventory i on i.film_id = r1.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join film_category c1 on c1.film_id = r1.film_id
inner join category r4 on r4.category_id = c1.category_id 
GROUP BY r1.film_id, r1.title
order by sum(p.amount) desc
limit 10;

-- 3.3 List top 20 Films by number of customers (ranked)

Select r1.film_id, r1.title, p.amount, COUNT(r.rental_id), count(c.customer_id),
r1.rating, r1.rental_rate, r1.replacement_cost,r4.name
from film r1
inner join inventory i on i.film_id = r1.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join customer c on c.customer_id = p.customer_id
inner join film_category c1 on c1.film_id = r1.film_id
inner join category r4 on r4.category_id = c1.category_id 
GROUP BY r1.film_id, r1.title
order by count(c.customer_id) desc
limit 20;

-- 3.4 List Films with the word “punk” in title with rental amount and number of customers

Select r1.film_id, r1.title, p.amount, COUNT(r.rental_id), 
r1.rating, r1.rental_rate, r1.replacement_cost,r4.name
from film r1
inner join inventory i on i.film_id = r1.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join film_category c1 on c1.film_id = r1.film_id
inner join category r4 on r4.category_id = c1.category_id 
where r1.title like '%punk%'
GROUP BY r1.film_id, r1.title;

-- 3.5 Contribution by rental amount for films with a documentary category 

Select r1.film_id, r1.title, sum(p.amount) as 'Rental amount', COUNT(r.rental_id) as 'No. of Rentals', 
r1.rating as 'Movie Rating', r1.replacement_cost,r4.name as 'Category'
from film r1
inner join inventory i on i.film_id = r1.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id = r.rental_id
inner join film_category c1 on c1.film_id = r1.film_id
inner join category r4 on r4.category_id = c1.category_id 
where r4.name = 'Documentary'
GROUP BY r1.film_id, r1.title
order by sum(p.amount) desc;




-- 4.1 List Customers (Last name, First Name) with rental amount, rental quantity, active status, country and city

Select c.first_name, c.last_name, p.amount, COUNT(r.rental_id), c.active, c1.city, c2.country
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join address a on a.address_id = c.address_id
inner join city c1 on a.city_id = c1.city_id
inner join country c2 on c2.country_id = c1.country_id
GROUP BY c.first_name, c.last_name;

-- 4.2 List top 10 Customers (Last name, First Name) by rental amount (ranked) for PG & PG-13 rated films

Select c.first_name, c.last_name, p.amount, COUNT(r.rental_id), c.active, c1.city, c2.country,
f.rating
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f on f.film_id = i.film_id
inner join address a on c.address_id = a.address_id
inner join city c1 on a.city_id = c1.city_id
inner join country c2 on c2.country_id = c1.country_id
where f.rating = 'PG' or f.rating = 'PG-13'
GROUP BY c.first_name, c.last_name
order by p.amount desc
limit 10;


-- 4.3 Contribution by rental amount for customers from France, Italy or Germany

Select c.first_name, c.last_name, p.amount, COUNT(r.rental_id), c.active, c1.city, c2.country
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join address a on c.address_id = a.address_id
inner join city c1 on a.city_id = c1.city_id
inner join country c2 on c2.country_id = c1.country_id
where c2.country = 'France' or c2.country = 'Italy' or c2.country = 'Germany' 
GROUP BY c.first_name, c.last_name;

-- 4.4 List top 20 Customers (Last name, First Name) by rental amount (ranked) for comedy films

Select c.first_name, c.last_name, max(p.amount), COUNT(r.rental_id), c.active, c1.city, c2.country,
f.name
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film f1 on f1.film_id = i.film_id
inner join film_category f2 on f2.film_id = f1.film_id
inner join category f on f.category_id = f2.category_id  
inner join address a on c.address_id = a.address_id
inner join city c1 on a.city_id = c1.city_id
inner join country c2 on c2.country_id = c1.country_id
where f.name = 'comedy'
GROUP BY c.first_name, c.last_name;

-- 4.5 List top 10 Customers (Last name, First Name) from China by rental amount (ranked) 
-- for films that have replacement costs greater than $24

Select c.first_name, c.last_name, sum(p.amount), COUNT(r.rental_id), c.active, c1.city, c2.country,
rc.replacement_cost
from customer c
inner join payment p on p.customer_id = c.customer_id
inner join rental r on r.rental_id = p.rental_id
inner join inventory i on i.inventory_id = r.inventory_id
inner join film rc on rc.film_id = i.film_id
inner join address a on c.address_id = a.address_id
inner join city c1 on a.city_id = c1.city_id
inner join country c2 on c2.country_id = c1.country_id
where c2.country = 'China' and  rc.replacement_cost > 24
GROUP BY c.first_name, c.last_name
order by sum(p.amount) desc
limit 10;