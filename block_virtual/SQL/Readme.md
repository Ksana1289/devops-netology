### Домашнее задание к занятию "6.2. SQL"

#### Задача 1 Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы. Приведите получившуюся команду или docker-compose манифест.

#### docker-compose.yml:
```shell
version: '3.6'

volumes:
  data: {}
  backup: {}

services:

  postgres:
    image: postgres:12
    container_name: psql
    ports:
      - "0.0.0.0:5432:5432"
    volumes:
      - data:/var/lib/postgresql/data
      - backup:/db/postgresql/backup
    environment:
      POSTGRES_USER: "test-admin-user"
      POSTGRES_PASSWORD: "admin"
      POSTGRES_DB: "test_db"
    restart: always
```
```shell
docker-compose up -d
docker exec -it psql bash
export PGPASSWORD=admin && psql -h localhost -U test-admin-user test_db
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.
```

#### Задача 2 В БД из задачи 1:
##### •	создайте пользователя test-admin-user и БД test_db
##### •	в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
##### •	предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
##### •	создайте пользователя test-simple-user
##### •	предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
#### Таблица orders:
##### •	id (serial primary key)
##### •	наименование (string)
##### •	цена (integer)
#### Таблица clients:
##### •	id (serial primary key)
##### •	фамилия (string)
##### •	страна проживания (string, index)
##### •	заказ (foreign key orders)
#### Приведите:
##### •	итоговый список БД после выполнения пунктов выше,
##### •	описание таблиц (describe)
##### •	SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
##### •	список пользователей с правами над таблицами test_db
```shell
CREATE DATABASE test_db;
CREATE USER "test-admin-user" WITH PASSWORD 'admin'; 
CREATE TABLE orders (
    id SERIAL,
    наименование VARCHAR, 
    цена INTEGER,
    PRIMARY KEY (id)
);
CREATE TABLE clients (
    id SERIAL,
    фамилия VARCHAR,
    "страна проживания" VARCHAR, 
    заказ INTEGER,
    PRIMARY KEY (id),
    CONSTRAINT fk_заказ
      FOREIGN KEY(заказ) 
	    REFERENCES orders(id)
);
GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";  
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "test-admin-user";   
CREATE USER "test-simple-user" WITH PASSWORD 'pass1234';
GRANT CONNECT ON DATABASE test_db TO "test-simple-user";
GRANT USAGE ON SCHEMA public TO "test-simple-user";
GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
```
#### Итоговый список БД:
```shell
\l+     
                                                                        List of databases                                                                                                                      
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |       Access privileges        |  Size   | Tablespace |    Description
-----------+----------+----------+-------------+-------------+--------------------------------+---------+-------+--------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                                | 7367 kB | pg_default | default administrative connection database 
 sql1      | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres                  +| 7487 kB | pg_default |             
           |          |          |             |             | postgres=CTc/postgres         +|         |            |     
           |          |          |             |             | adm=CTc/postgres              +|         |            | 
           |          |          |             |             | readonly=c/postgres           +|         |            |  
           |          |          |             |             | "wriуonly"=c/postgres         +|         |            |   
           |          |          |             |             | admin=CTc/postgres             |         |            |   
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                   +| 7177 kB | pg_default | unmodifiable empty database 
           |          |          |             |             | postgres=CTc/postgres          |         |            |            
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                   +| 7177 kB | pg_default | default template for new databases                                                      
           |          |          |             |             | postgres=CTc/postgres          |         |            |                
 test_db   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres                  +| 7463 kB | pg_default |   
           |          |          |             |             | postgres=CTc/postgres         +|         |            |                
           |          |          |             |             | "test-admin-user"=CTc/postgres+|         |            |    
           |          |          |             |             | "test-simple-user"=c/postgres  |         |            |          
(5 rows)      
```                                                                                                                                                                                              
#### Описание таблиц:
```shell
\d+ clients                                                                                                                     
                                                           Table "public.clients"                                
  Column       |       Type        | Collation | Nullable |               Default               | Storage  | Stats target | Description 
-------------------+-------------------+-----------+----------+-------------------------------------+----------+--------------+---------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |  
 фамилия           | character varying |           |          |                                     | extended |              |         
 страна проживания | character varying |           |          |                                     | extended |              |     
 заказ             | integer           |           |          |                                     | plain    |              |      
Indexes:                                                                                                                                                                                                       
    "clients_pkey" PRIMARY KEY, btree (id)                                                   
Foreign-key constraints:                                                           
    "fk_заказ" FOREIGN KEY ("заказ") REFERENCES orders(id)                                                            
                                                                                                                                                                                                               
\d+ orders                                                                                                    
                                                        Table "public.orders"                                
Column    |       Type        | Collation | Nullable |              Default               | Storage  | Stats target | Description 
--------------+-------------------+-----------+----------+------------------------------------+----------+--------------+----------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |  
 наименование | character varying |           |          |                                    | extended |              |         
 цена         | integer           |           |          |                                    | plain    |              |      
Indexes:                                                                                                                                                                                                       
    "orders_pkey" PRIMARY KEY, btree (id)                                  
Referenced by:                                                                                    
    TABLE "clients" CONSTRAINT "fk_заказ" FOREIGN KEY ("заказ") REFERENCES orders(id)          
```                                                                                                         
#### SQL-запрос для выдачи списка пользователей с правами над таблицами test_db:
```shell
SELECT 
    grantee, table_name, privilege_type 
FROM 
    information_schema.table_privileges 
WHERE 
    grantee in ('test-admin-user','test-simple-user')
    and table_name in ('clients','orders')
order by 
    1,2,3;
    grantee      | table_name | privilege_type                                                                                                                      
```
```shell                                        
------------------+------------+----------------                                                                               
 test-admin-user  | clients    | DELETE                                                                                
 test-admin-user  | clients    | INSERT                                                                 
 test-admin-user  | clients    | REFERENCES                                                     
 test-admin-user  | clients    | SELECT                                                            
 test-admin-user  | clients    | TRIGGER                                                               
 test-admin-user  | clients    | TRUNCATE                                                                                           
 test-admin-user  | clients    | UPDATE                                                                                
 test-admin-user  | orders     | DELETE                                                                                
 test-admin-user  | orders     | INSERT                                                                                     
 test-admin-user  | orders     | REFERENCES                                                                               
 test-admin-user  | orders     | SELECT                                                                                        
 test-admin-user  | orders     | TRIGGER                                                                                      
 test-admin-user  | orders     | TRUNCATE                                                                                           
 test-admin-user  | orders     | UPDATE                                                                      
 test-simple-user | clients    | DELETE                                                                                
 test-simple-user | clients    | INSERT                                                                     
 test-simple-user | clients    | SELECT                                                                                          
 test-simple-user | clients    | UPDATE                                                                           
 test-simple-user | orders     | DELETE                                                                       
 test-simple-user | orders     | INSERT                                                                           
 test-simple-user | orders     | SELECT                                                                             
 test-simple-user | orders     | UPDATE                                                     
(22 rows)                                                    
```
#### Задача 3 Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

#### Таблица orders
```shell
Наименование	цена
Шоколад	10
Принтер	3000
Книга	500
Монитор	7000
Гитара	4000
```
#### Таблица clients
```shell
ФИО	Страна проживания
Иванов Иван Иванович	USA
Петров Петр Петрович	Canada
Иоганн Себастьян Бах	Japan
Ронни Джеймс Дио	Russia
Ritchie Blackmore	Russia
```
#### Используя SQL синтаксис:
##### •	вычислите количество записей для каждой таблицы
##### •	приведите в ответе:
##### •	запросы
##### •	результаты их выполнения.
```shell
INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);

INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
```
```shell
SELECT * FROM orders;                                                                                                               
 id | наименование | цена                                                        
----+--------------+------                                                                                                   
  1 | Шоколад      |   10                                                                                                           
  2 | Принтер      | 3000                                                                                                         
  3 | Книга        |  500                                                                                                        
  4 | Монитор      | 7000                                                                                                  
  5 | Гитара       | 4000                                                                                                 
(5 rows)                                                
```                                                                
```shell                                                                
SELECT * FROM clients;                                                                                        
 id |       фамилия        | страна проживания | заказ                                                     
----+----------------------+-------------------+-------                    
  1 | Иванов Иван Иванович | USA               |                                                                    
  2 | Петров Петр Петрович | Canada            |                                                                   
  3 | Иоганн Себастьян Бах | Japan             |                                                                                     
  4 | Ронни Джеймс Дио     | Russia            |                                    
  5 | Ritchie Blackmore    | Russia            |                                                  
(5 rows)
```
```shell
SELECT count(1) FROM orders;                                                                                         
 count                                                                         
-------                                                                                                                                 
     5                                                                             
(1 row) 
```

```shell                                                                      
SELECT count(1) FROM clients;                                                                                   
 count                                                                                      
-------                                                                                                                                 
     5    
(1 row)                    
```
#### Задача 4 Часть пользователей из таблицы clients решили оформить заказы из таблицы orders. Используя foreign keys свяжите записи из таблиц, согласно таблице:
```shell
ФИО	Заказ
Иванов Иван Иванович	Книга
Петров Петр Петрович	Монитор
Иоганн Себастьян Бах	Гитара
```
#### Приведите SQL-запросы для выполнения данных операций.
#### Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
#### Подсказк - используйте директиву UPDATE.
```shell
UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименование"='Книга') WHERE "фамилия"='Иванов Иван Иванович';
UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименование"='Монитор') WHERE "фамилия"='Петров Петр Петрович';
UPDATE clients SET "заказ" = (SELECT id FROM orders WHERE "наименование"='Гитара') WHERE "фамилия"='Иоганн Себастьян Бах';
```
```shell
SELECT c.* FROM clients c JOIN orders o ON c.заказ = o.id;

id |       фамилия        | страна проживания | заказ      
----+----------------------+-------------------+-------                                                                          
  1 | Иванов Иван Иванович | USA               |     3                                                                                
  2 | Петров Петр Петрович | Canada            |     4                                                     
  3 | Иоганн Себастьян Бах | Japan             |     5                                                              
(3 rows)                                   
```            

#### Задача 5 Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN). Приведите получившийся результат и объясните что значат полученные значения.
```shell
EXPLAIN SELECT c.* FROM clients c JOIN orders o ON c.заказ = o.id;  
                                                                                                                                 
                               QUERY PLAN                                                   
------------------------------------------------------------------------                                                                                                                                       
 Hash Join  (cost=37.00..57.24 rows=810 width=72)                                           
   Hash Cond: (c."заказ" = o.id)                                              
   ->  Seq Scan on clients c  (cost=0.00..18.10 rows=810 width=72)                
   ->  Hash  (cost=22.00..22.00 rows=1200 width=4)                                                                           
         ->  Seq Scan on orders o  (cost=0.00..22.00 rows=1200 width=4)                                                               
(5 rows)                                          
```
##### 1. Построчно прочитана таблица orders
##### 2. Создан кеш по полю id для таблицы orders
##### 3. Прочитана таблица clients
##### 4. Для каждой строки по полю "заказ" будет проверено, соответствует ли она чему-то в кеше orders
##### - если соответствия нет - строка будет пропущена
##### - если соответствие есть, то на основе этой строки и всех подходящих строках кеша СУБД сформирует вывод

##### При запуске просто explain, Postgres напишет только примерный план выполнения запроса и для каждой операции предположит:
##### - сколько процессорного времени уйдёт на поиск первой записи и сбор всей выборки: cost=первая_запись..вся_выборка
##### - сколько примерно будет строк: rows
##### - какой будет средняя длина строки в байтах: width
##### Postgres делает предположения на основе статистики, которую собирает периодический выполня analyze запросы на выборку данных из служебных таблиц.
##### Если запустить explain analyze, то запрос будет выполнен и к плану добавятся уже точные данные по времени и объёму данных.
##### explain verbose и explain analyze verbose - для каждой операции выборки будут написаны поля таблиц, которые в выборку попали.


#### Задача 6 Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
#### Остановите контейнер с PostgreSQL (но не удаляйте volumes).
#### Поднимите новый пустой контейнер с PostgreSQL.
#### Восстановите БД test_db в новом контейнере.
#### Приведите список операций, который вы применяли для бэкапа данных и восстановления.
```shell
export PGPASSWORD=admin && pg_dump -h localhost -d test_db -U bkpuser > /db/postgresql/backup/test_db.sql 
ls /db/postgresql/backup/
test_db.sql
docker-compose stop
Stopping psql ... done
docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                     PORTS     NAMES
a540c2d91831   postgres:12   "docker-entrypoint.s…"   30 minutes ago   Exited (0) 9 seconds ago             psql
docker run --rm -d -e POSTGRES_USER=test-admin-user -e POSTGRES_PASSWORD=admin -e POSTGRES_DB=test_db -v backup:/db/postgresql/backup --name psql2 postgres:12
docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                          PORTS      NAMES
d82a1de7ffc4   postgres:12   "docker-entrypoint.s…"   8 seconds ago    Up 7 seconds                    5432/tcp   psql2
a540c2d91831   postgres:12   "docker-entrypoint.s…"   31 minutes ago   Exited (0) About a minute ago              psql
docker exec -it psql2  bash
ls /db/postgresql/backup/
test_db.sql
export PGPASSWORD=admin && psql -h localhost -U test-admin-user -f /db/postgresql/backup/test_db.sql test_db
psql -h localhost -U test-admin-user test_db
psql (12.10 (Debian 12.10-1.pgdg110+1))
Type "help" for help.
```

