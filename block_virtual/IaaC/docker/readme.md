### Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"
#### Задача 1
##### Сценарий выполения задачи:
###### •	создайте свой репозиторий на https://hub.docker.com;
###### •	выберете любой образ, который содержит веб-сервер Nginx;
###### •	создайте свой fork образа;
###### •	реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```shell
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
```shell
docker pull nginx
```
Dockerfile
```shell
FROM nginx
RUN echo '<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>' > /usr/share/nginx/html/index.html
```
```shell
docker build -f dockerfile -t ksana89roza/nginx-task-1:1 .
docker run -d -p 8081:80 ksana89roza/nginx-task-1:1
curl http://localhost:8081
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>
docker push ksana89roza/nginx-task-1:1
```
Ссылка на образ https://hub.docker.com/layers/ksana89roza/nginx-task-1/1/images/sha256-f2acb16831185cb091141e0a2f6055d87308e32e00d762521c9fb8a81a7c32b7?context=repo
#### Задача 2 Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?" Детально опишите и обоснуйте свой выбор.
--
##### Сценарий:
###### •	Высоконагруженное монолитное java веб-приложение;
###### •	Nodejs веб-приложение;
###### •	Мобильное приложение c версиями для Android и iOS;
###### •	Шина данных на базе Apache Kafka;
###### •	Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
###### •	Мониторинг-стек на базе Prometheus и Grafana;
###### •	MongoDB, как основное хранилище данных для java-приложения;
###### •	Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Решение
###### •	Высоконагруженное монолитное java веб-приложение - физическая машина, чтобы не расходовать ресурсы на виртуализацию, из-за монолитности не будет проблем с разворачиванием на разных машинах.
###### •	Nodejs веб-приложение – docker позволит быстро развернуть приложение со всеми необходимыми библиотеками.
###### •	Мобильное приложение c версиями для Android и iOS - виртуальные машины для эмуляции среды.
###### •	Шина данных на базе Apache Kafka – docker. Есть готовые образы для Apache Kafka. Но также подойдет и виртуальная машина.
###### •	Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana - docker, Elasticsearch доступен для установки как образ docker, проще удалять логи, при кластеризации меньше тратится времени на запуск контейнеров.
###### •	Мониторинг-стек на базе Prometheus и Grafana - docker. Есть готовые образы, удобно масштабировать и быстро разворачивать.
###### •	MongoDB, как основное хранилище данных для java-приложения - физическая машина как наиболее надежное, отказоустойчивое решение. Либо виртуальный сервер.
###### •	Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry - виртуальная машина, удобно делать бекапы и при необходимости мигрировать её в кластере.
#### Задача 3
###### •	Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
###### •	Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера;
###### •	Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data;
###### •	Добавьте еще один файл в папку /data на хостовой машине;
###### •	Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
```shell
docker run -it --rm -d --name centos -v $(pwd)/data:/data centos

docker run -it --rm -d --name debian -v $(pwd)/data:/data debian
```
В первом контейнере:
```shell
docker exec -it centos bash
echo "Hello CentOS!" > /data/centos.txt
exit
```
На хосте:
```shell
echo "Hellow host!" > data/host.txt
```
Во втором контейнере:
```shell
docker exec -it debian bash
ls -l /data
total 8
-rw-r--r-- 1 root root 14 Jan 16 21:42 centos.txt
-rw-r--r-- 1 root root 13 Jan 16 21:48 host.txt
```

#### Задача 4 (*) Воспроизвести практическую часть лекции самостоятельно.
#### Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
```shell
docker build -t ksana89roza/ansible-dev:2.9.24 .
```
При сборке контейнера выходит ошибкам
COPY failed: file not found in build context or excluded by .dockerignore: stat ansible.cfg: file does not exist
 
Закоментировала строку dockerfile
```shell
# COPY ansible.cfg /ansible/
```
```shell
docker run -i ksana89roza/ansible-dev:2.9.24
ansible-playbook [core 2.14.1]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.9/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible-playbook
  python version = 3.9.16 (main, Dec 10 2022, 13:47:19) [GCC 10.3.1 20210424] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = False
```
```shell
docker push ksana89roza/ansible-dev:2.9.24
```
Ссылка на образ https://hub.docker.com/layers/ksana89roza/ansible-dev/2.9.24/images/sha256-a6b73c5f77ba750e65bf35f98591791aeaeb8479e92774c9d1638976d9d275d5?context=repo
