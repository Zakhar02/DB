--First Query not optimized
explain
select first_name, last_name, title
from customer,
     film f
         left join film_category on f.film_id = film_category.film_id
         left join category on film_category.category_id = category.category_id
where (rating = 'R' or rating = 'PG-13')
  and (name = 'Horror' or name = 'Sci-Fi')
  and not exists(select film_id, customer_id
                 from rental
                          left join inventory i on rental.inventory_id = i.inventory_id
                 where rental.customer_id = customer.customer_id
                   and f.film_id = i.film_id);

--First Query optimized
explain
select first_name, last_name, title
from customer,
     film f
         left join film_category on f.film_id = film_category.film_id
         left join category on film_category.category_id = category.category_id
where (rating = 'R' or rating = 'PG-13')
  and (name = 'Horror' or name = 'Sci-Fi')
  and (f.film_id, customer_id) not in (select film_id, customer_id
                                       from rental
                                                left join inventory i on rental.inventory_id = i.inventory_id);

--Second Query
create index payment_index on payment (payment_date);
explain
select subquery.address, max(sum)
from (select address.address, sum(amount) as sum
      from payment
               left join customer on payment.customer_id = customer.customer_id
               left join address on customer.address_id = address.address_id
               left join city on address.address_id = city.city_id
      where date_trunc('month', payment_date) in (select date_trunc('month', max(payment_date)) from payment)
      group by city.city, address.address) as subquery
group by subquery.address;
