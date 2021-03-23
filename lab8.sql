drop table if exists accounts;

create table accounts
(
    id     serial primary key,
    name   char(10) not null,
    credit int
);

insert into accounts(id, name, credit)
values (1, 'A', 1000),
       (2, 'B', 1000),
       (3, 'C', 1000);

start transaction;

update accounts
set credit = 1500
where id = 3;

update accounts
set credit = 500
where id = 1;

update accounts
set credit = 300
where id = 2;

update accounts
set credit = 1200
where id = 1;

update accounts
set credit = 200
where id = 2;

update accounts
set credit = 1600
where id = 3;

select *
from accounts;

rollback;

select *
from accounts;

alter table accounts
    add column bankname char(20);

update accounts
set bankname = 'SpearBank'
where id = 1
   or id = 3;

update accounts
set bankname = 'Tinkoff'
where id = 2;

insert into accounts(id, name, credit)
values (4, 'Fee', 0);

create or replace function send_(from_ int, to_ int, amount int) returns void as
$$
Begin
    if (select bankname from accounts where id = from_) = (select bankname from accounts where id = to_) then
        update accounts set credit = (select credit from accounts where id = from_) - amount where id = from_;
    else
        update accounts set credit = (select credit from accounts where id = from_) - amount - 30 where id = from_;
        update accounts set credit = (select credit from accounts where id = 4) + 30 where id = 4;
    end if;
    update accounts set credit = (select credit from accounts where id = to_) + amount where id = to_;
End;
$$
    language plpgsql;

start transaction;

select *
from send_(1, 3, 500);
select *
from send_(2, 1, 700);
select *
from send_(2, 3, 100);

select *
from accounts;

rollback;

select *
from accounts;

drop table if exists ledger;

create table ledger
(
    id     serial primary key,
    from_  int,
    to_    int,
    fee    int,
    amount int,
    time   timestamp
);

create or replace function send_(from_ int, to_ int, amount int)
    returns void as
$$
begin
    if (select bankname from accounts where id = from_) = (select bankname from accounts where id = to_) then
        update accounts set credit = (select credit from accounts where id = from_) - amount where id = from_;
        insert into ledger(from_, to_, fee, amount, time) values (from_, to_, 0, amount, now());
    else
        update accounts set credit = (select credit from accounts where id = from_) - amount - 30 where id = from_;
        update accounts set credit = (select credit from accounts where id = 4) + 30 where id = 4;
        insert into ledger(from_, to_, fee, amount, time) values (from_, to_, 30, amount, now());
    end if;
    update accounts set credit = (select credit from accounts where id = to_) + amount where id = to_;
end;
$$
    language plpgsql;

start transaction;

select *
from send_(1, 3, 500);
select *
from send_(2, 1, 700);
select *
from send_(2, 3, 100);

select *
from accounts;

select *
from ledger;

rollback;

select *
from accounts;

select *
from ledger;
