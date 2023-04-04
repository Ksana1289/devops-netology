### Домашнее задание к занятию "6.3. MySQL"

#### Задача 1 Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```shell
docker run --rm --name mysql-docker \
    -e MYSQL_DATABASE=test_db \
    -e MYSQL_ROOT_PASSWORD=admin \
    -v $PWD/backup:/data/mysql/backup \
    -v my_data:/var/lib/mysql \
    -v $PWD/config/conf.d:/etc/mysql/conf.d \
    -p 3306:3306 \
    -d mysql:8.0
```
#### Изучите бэкап БД и восстановитесь из него.
```shell
docker cp test_dump.sql mysql-docker:/tmp
docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                               NAMES
559ae3e28d5c   mysql:8.0   "docker-entrypoint.s…"   4 minutes ago   Up 4 minutes   0.0.0.0:3306->3306/tcp, 33060/tcp   mysql-docker
docker exec -it mysql-docker bash
mysql -u root -p test_db < /tmp/test_dump.sql
Enter password:
```
#### Перейдите в управляющую консоль mysql внутри контейнера.
```shell
mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.32 MySQL Community Server - GPL

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
#### Используя команду \h получите список управляющих команд.
#### Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
```shell
\s
--------------
mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          10
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.32 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 25 min 39 sec

Threads: 2  Questions: 35  Slow queries: 0  Opens: 138  Flush tables: 3  Open tables: 56  Queries per second avg: 0.022
--------------
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
USE test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
```
#### Приведите в ответе количество записей с price > 300.
```shell
SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
#### Задача 2 Создайте пользователя test в БД c паролем test-pass, используя:
##### •	плагин авторизации mysql_native_password
##### •	срок истечения пароля - 180 дней
##### •	количество попыток авторизации - 3
##### •	максимальное количество запросов в час - 100
##### •	аттрибуты пользователя:
##### •	Фамилия "Pretty"
##### •	Имя "James"
```shell
CREATE USER 'test'@'localhost'
    ->     IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->     WITH MAX_CONNECTIONS_PER_HOUR 100
    ->     PASSWORD EXPIRE INTERVAL 180 DAY
    ->     FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
    ->     ATTRIBUTE '{"first_name":"James", "last_name":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)
```
#### Предоставьте привелегии пользователю test на операции SELECT базы test_db.
```shell
GRANT SELECT ON test_db.* TO test@localhost;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```
#### Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
```shell
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER = 'test';
+------+-----------+------------------------------------------------+
| USER | HOST      | ATTRIBUTE                                      |
+------+-----------+------------------------------------------------+
| test | localhost | {"last_name": "Pretty", "first_name": "James"} |
+------+-----------+------------------------------------------------+
1 row in set (0.00 sec)
```
#### Задача 3 Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;
#### Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
```shell
set profiling=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE();
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| test_db      | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.00 sec)
```
#### Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
##### •	на MyISAM
##### •	на InnoDB
```shell
ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                |
+----------+------------+------------------------------------------------------------------------------------------------------+
|        1 | 0.00190725 | SELECT table_schema,table_name,engine FROM information_schema.tables WHERE table_schema = DATABASE() |
|        2 | 0.00011925 | LTER TABLE orders ENGINE = MyISAM                                                                    |
|        3 | 0.01621700 | ALTER TABLE orders ENGINE = MyISAM                                                                   |
|        4 | 0.01888850 | ALTER TABLE orders ENGINE = InnoDB                                                                   |
+----------+------------+------------------------------------------------------------------------------------------------------+
4 rows in set, 1 warning (0.00 sec)
```
#### Задача 4 Изучите файл my.cnf в директории /etc/mysql.
#### Измените его согласно ТЗ (движок InnoDB):
##### •	Скорость IO важнее сохранности данных
##### •	Нужна компрессия таблиц для экономии места на диске
##### •	Размер буффера с незакомиченными транзакциями 1 Мб
##### •	Буффер кеширования 30% от ОЗУ
##### •	Размер файла логов операций 100 Мб
#### Приведите в ответе измененный файл my.cnf.
```shell
echo "innodb_flush_log_at_trx_commit = 0
    ->     innodb_file_per_table = ON
    ->     innodb_log_buffer_size = 1M
    ->     innodb_buffer_pool_size = 2G
    ->     innodb_log_file_size = 100M">> /etc/my.cnf
```
```shell
cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 0
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 2G
innodb_log_file_size = 100M
```