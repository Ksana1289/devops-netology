### Домашнее задание к занятию "6.4. PostgreSQL"

#### Задача 1 Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```shell
docker run --rm --name postgresql-docker \
    -e POSTGRES_PASSWORD=admin \
    -v my_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    -d postgres:13

docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                    NAMES
0f1a8ab04779   postgres:13   "docker-entrypoint.s…"   11 seconds ago   Up 10 seconds   0.0.0.0:5432->5432/tcp   postgresql-docker
```
#### Подключитесь к БД PostgreSQL используя psql.
```shell
docker exec -it postgresql-docker bash
psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.
```
#### Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам. Найдите и приведите управляющие команды для:
##### •	вывода списка БД
```shell
\l+                                                         
                                                                    List of databases                           
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges  |  Size   | Tablespace |       Description
-----------+----------+----------+-------------+-------------+----------------------+---------+------------+---------------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |                      | 6501 kB | pg_default | default administrative 
                                                                                                             connection database
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres         +| 6385 kB | pg_default | unmodifiable empty database
           |          |          |             |             | postgres=CTc/postgres|         |            |                           
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres         +| 6393 kB | pg_default | default template for new   
                                                                                                             databases 
           |          |          |             |             | postgres=CTc/postgres|         |            |                  
(3 rows)              
```
##### •	подключения к БД
```shell
\c                                                                                                                                                                                           
You are now connected to database "postgres" as user "postgres".                
```
##### •	вывода списка таблиц
```shell
\dtS               
                    List of relations                                                                                         
   Schema   |          Name           | Type  |  Owner                                                                          
------------+-------------------------+-------+----------                                                     
 pg_catalog | pg_aggregate            | table | postgres                                                                    
 pg_catalog | pg_am                   | table | postgres                                                         
 pg_catalog | pg_amop                 | table | postgres                                                       
 pg_catalog | pg_amproc               | table | postgres                                                                      
 pg_catalog | pg_attrdef              | table | postgres                                                                              
 pg_catalog | pg_attribute            | table | postgres                                                                
 pg_catalog | pg_auth_members         | table | postgres                                                             
 pg_catalog | pg_authid               | table | postgres                                                           
 pg_catalog | pg_cast                 | table | postgres                                                
 pg_catalog | pg_class                | table | postgres                                                      
 pg_catalog | pg_collation            | table | postgres                                                 
 pg_catalog | pg_constraint           | table | postgres                                                   
 pg_catalog | pg_conversion           | table | postgres                                        
 pg_catalog | pg_database             | table | postgres        
```
##### •	вывода описания содержимого таблиц
```shell
\dS+                                                                                                      
                                     List of relations                                                                              
   Schema   |              Name               | Type  |  Owner   |    Size    | Description   
------------+---------------------------------+-------+----------+------------+-------------    
 pg_catalog | pg_aggregate                    | table | postgres | 40 kB      |                      
 pg_catalog | pg_am                           | table | postgres | 40 kB      |                    
 pg_catalog | pg_amop                         | table | postgres | 64 kB      |                
 pg_catalog | pg_amproc                       | table | postgres | 56 kB      |                
 pg_catalog | pg_attrdef                      | table | postgres | 8192 bytes |               
 pg_catalog | pg_attribute                    | table | postgres | 368 kB     |               
 pg_catalog | pg_auth_members                 | table | postgres | 0 bytes    |                  
 pg_catalog | pg_authid                       | table | postgres | 40 kB      |                               
 pg_catalog | pg_available_extension_versions | view  | postgres | 0 bytes    |                                 
 pg_catalog | pg_available_extensions         | view  | postgres | 0 bytes    |                                         
 pg_catalog | pg_cast                         | table | postgres | 48 kB      |                              
 pg_catalog | pg_class                        | table | postgres | 96 kB      |          
 pg_catalog | pg_collation                    | table | postgres | 264 kB     |                                                   
 pg_catalog | pg_constraint                   | table | postgres | 48 kB      |                                                    
 pg_catalog | pg_conversion                   | table | postgres | 56 kB      |                                                 
 pg_catalog | pg_cursors                      | view  | postgres | 0 bytes    |                                                 
 pg_catalog | pg_database                     | table | postgres | 8192 bytes |
```
##### •	выхода из psql
```shell
\q
```
#### Задача 2 Используя psql создайте БД test_database.
```shell
CREATE DATABASE test_database;                                                                                                                                                                      
CREATE DATABASE   
```
#### Изучите бэкап БД. Восстановите бэкап БД в test_database.
```shell
docker cp ../../vagrant_data/test_dump.sql postgresql-docker:/tmp
docker exec -it postgresql-docker bash
psql -U postgres -f /tmp/test_dump.sql  test_database

SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
#### Перейдите в управляющую консоль psql внутри контейнера.
```shell
psql -U postgres
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.
```
#### Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```shell
\c test_database
You are now connected to database "test_database" as user "postgres".
\dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
#### Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах. Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.
```shell
SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```
#### Задача 3 Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
#### Предложите SQL-транзакцию для проведения данной операции.
```shell
CREATE TABLE orders_more_499_price (CHECK (price > 499)) INHERITS (orders);                                                                                                                    
CREATE TABLE                                                                                                                                                                                                   
INSERT INTO orders_more_499_price SELECT * FROM orders WHERE price > 499;                                                                                                                      
INSERT 0 3                                                                                                                                                                                                     
CREATE TABLE orders_less_499_price (CHECK (price <= 499)) INHERITS (orders);                                                                                                                   
CREATE TABLE                                                                                                                                                                                                   
INSERT INTO orders_LESS_499_price SELECT * FROM orders WHERE price <= 499;                                                                                                                     
INSERT 0 5       

\dt;
                                                                   
                 List of relations                                                               
 Schema |         Name          | Type  |  Owner                                                                                      
--------+-----------------------+-------+----------                         
 public | orders                | table | postgres                       
 public | orders_less_499_price | table | postgres                      
 public | orders_more_499_price | table | postgres                       
(3 rows) 
```                       
#### Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

#### Можно, прописав правила вставки:
```shell
CREATE RULE orders_insert_to_more AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_more_499_price VALUES (NEW.*);
CREATE RULE orders_insert_to_less AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_less_499_price VALUES (NEW.*);
```
#### Задача 4 Используя утилиту pg_dump создайте бекап БД test_database.
```shell
export PGPASSWORD=admin && pg_dump -h localhost -U postgres test_database > /tmp/test_database_backup.sql
```
#### Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

#### Добавив свойство UNIQUE
```
--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer DEFAULT nextval('public.orders_id_seq'::regclass) NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```