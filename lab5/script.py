import psycopg2


def execute_query(cur, query):
    cur.execute(query)
    for i in cur.fetchall():
        print(i[0])
    print("--------------------")


con = psycopg2.connect(database="zakhar_yagudin_lab5", user="postgres", password="postgres", host="127.0.0.1",
                       port="5432")
cur = con.cursor()
query1 = "explain analyze select * from customer where age<19"
query2 = "explain analyze select * from customer where Name='John'"
execute_query(cur, query1)
execute_query(cur, query2)
cur.execute("create index age_index on customer (Age)")  # btree by default
cur.execute("create index name_index on customer using hash (Name)")
execute_query(cur, query1)
execute_query(cur, query2)
cur.close()
con.close()

# using indexes makes some querys' execution faster, for example, hash — only equality checks
