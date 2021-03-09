create or replace function retrieve_customers(int, int)
returns setof  customer as
$$
begin
if $1 < 0 or $2 < 0 or $1 > 600 or $2 > 600 then raise exception 'invalid index'; end if;
return query select * from customer order by address_id offset $1 - 1 limit $2-$1 + 1;
end;
$$
language plpgsql;

select * from retrieve_customers(10, 40);
