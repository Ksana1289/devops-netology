### Домашнее задание к занятию "Введение в Terraform"
#### Цель задания
#### 1.	Установить и настроить Terrafrom.
#### 2.	Научиться использовать готовый код.
________________________________________
#### Чеклист готовности к домашнему заданию
#### 1.	Скачайте и установите актуальную версию terraform(не менее 1.3.7). Приложите скриншот вывода команды terraform --version
#### 2.	Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории 01/src.
#### 3.	Убедитесь, что в вашей ОС установлен docker

Репозиторий не скачивается 
```shell
[root@serv1 ~]# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
\Загружены модули: fastestmirror, product-id, subscription-manager

This system is not registered with an entitlement server. You can use subscription-manager to register.

adding repo from: https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
grabbing file https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo to /etc/yum.repos.d/hashicorp.repo
Could not fetch/save url https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo to file /etc/yum.repos.d/hashicorp.repo: [Errno 14] HTTPS Error 404 - Not Found
```
________________________________________
#### Задание 1
##### 1. Перейдите в каталог src. Скачайте все необходимые зависимости, использованные в проекте.
##### 2. Изучите файл .gitignore. В каком terraform файле допустимо сохранить личную, секретную информацию?
##### 3. Выполните код проекта. Найдите в State-файле секретное содержимое созданного ресурса random_password. Пришлите его в качестве ответа.
##### 4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла main.tf. Выполните команду terraform validate. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.
##### 5. Выполните код. В качестве ответа приложите вывод команды docker ps
##### 6. Замените имя docker-контейнера в блоке кода на hello_world, выполните команду terraform apply -auto-approve. Объясните своими словами, в чем может быть опасность применения ключа -auto-approve ?
##### 7. Уничтожьте созданные ресурсы с помощью terraform. Убедитесь, что все ресурсы удалены. Приложите содержимое файла terraform.tfstate.
##### 8. Объясните, почему при этом не был удален docker образ nginx:latest ?(Ответ найдите в коде проекта или документации)
