--Ordering countries
select * from country order by country_id offset 11 limit 6;

--Listing countries starting from 'A'
select a.* from city
	left join address a on city.city_id=a.city_id
where upper(city.city) like 'A%';

--Listing all customers' names and cities
select first_name, last_name, c.city from customer
	left join address a on customer.address_id=a.address_id
	left join city c on a.city_id=c.city_id;

--Listing all customers with payment>11
select customer.* from customer
	join payment p on customer.customer_id=p.customer_id
where p.amount > 11;

--Listing duplicates names
select s.first_name from (
	select first_name, count(first_name) as count from customer group by first_name
) as s where s.count > 1;

--Delete view
drop view from_12_to_17;

--Create view for relation for ordering countries
create view from_12_to_17 as
select * from country order by country_id offset 11 limit 6;

--Delete view
drop view check_payment;

--Create view for relation for checking customers with payment>11
create view check_payment as
select customer.* from customer
	join payment p on customer.customer_id=p.customer_id
where p.amount > 11;

--Using view in query
select * from from_12_to_17;

--Function that updates inventory table
create function update_()
	returns trigger
	language plpgsql
	as
$$
begin
	NEW.last_update = now();
	return NEW;
end;
$$;

--Trigger that updates inventory after updating category
create trigger update_inventory
before update on category for each row
execute procedure update_();
