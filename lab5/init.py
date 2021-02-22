import psycopg2
from faker import Faker

con = psycopg2.connect(database="postgres", user="postgres", password="postgres", host="127.0.0.1", port="5432")
con.autocommit = True
cur = con.cursor()
cur.execute("drop database if exists zakhar_yagudin_lab5")
cur.execute("create database zakhar_yagudin_lab5")
cur.close()
con.close()
con = psycopg2.connect(database="zakhar_yagudin_lab5", user="postgres", password="postgres", host="127.0.0.1",
                       port="5432")
cur = con.cursor()
cur.execute('''
    create table Customer(
    ID      int    primary key     not null,
    Name    text   not null,
    Address text   not null,
    Age     int    not null,
    Review  text   not null)''')
fake = Faker()
for i in range(100000):
    print(i)
    cur.execute(
        "insert into customer (ID, Name, Address, Age, Review) values (%s, %s, %s, %s, %s)",
        (i, fake.name(), fake.address(), fake.random.randint(18, 60), fake.text()))
con.commit()
cur.close()
con.close()
