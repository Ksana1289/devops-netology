### Домашнее задание к занятию "Введение в Terraform"
#### Цель задания
#### 1.	Установить и настроить Terrafrom.
#### 2.	Научиться использовать готовый код.
________________________________________
#### Чеклист готовности к домашнему заданию
#### 1.	Скачайте и установите актуальную версию terraform(не менее 1.3.7). Приложите скриншот вывода команды terraform --version
#### 2.	Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории 01/src.
#### 3.	Убедитесь, что в вашей ОС установлен docker
image.png
________________________________________
#### Задание 1
##### 1. Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.
##### 2. Изучите файл .gitignore. В каком terraform файле допустимо сохранить личную, секретную информацию?
##### 3. Выполните код проекта. Найдите в State-файле секретное содержимое созданного ресурса random_password. Пришлите его в качестве ответа.
```shell
drwxrwxr-x. 9 ksana ksana 95 май  2 23:19 ter-homeworks
[root@serv1 ksana]# cd ter-homeworks/01
[root@serv1 01]# ll
итого 8
-rw-rw-r--. 1 ksana ksana 5196 май  2 23:19 hw-01.md
drwxrwxr-x. 2 ksana ksana   59 май  2 23:19 src
[root@serv1 01]# cd src
[root@serv1 src]# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding kreuzwerker/docker versions matching "~> 3.0.1"...
- Finding latest version of hashicorp/random...
╷
│ Error: Invalid provider registry host
│
│ The host "registry.terraform.io" given in in provider source address "registry.terraform.io/kreuzwerker/docker" does not offer a Terraform provider
│ registry.
╵

╷
│ Error: Invalid provider registry host
│
│ The host "registry.terraform.io" given in in provider source address "registry.terraform.io/hashicorp/random" does not offer a Terraform provider registry.
╵
```
##### 4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
##### 5. Выполните код. В качестве ответа приложите вывод команды docker ps
##### 6. Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?
##### 7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
##### 8. Объясните, почему при этом не был удален docker образ nginx:latest ?(Ответ найдите в коде проекта или документации)
