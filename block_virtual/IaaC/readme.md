### Домашнее задание к занятию "2. Применение принципов IaaC в работе с виртуальными машинами"
#### Задача 1
##### Опишите своими словами основные преимущества применения на практике IaaC паттернов.

•	Возможность автоматизировать рутинные операции.
•	Автоматизация инфраструктуры позволяет эффективнее использовать существующие ресурсы и минимизировать риск возникновения ошибки, связанной с человеческим фактором.

##### Какой из принципов IaaC является основополагающим?

•	Идемпотентность - возможность описать желаемое состояние того, что конфигурируется и получать идентичный результат.

#### Задача 2
•	Чем Ansible выгодно отличается от других систем управление конфигурациями?

В Ansible не нужно обладать большими навыками в разработке, чтобы им пользоваться. Не требуется установка агента, для доступа на клиент используется ssh 

•	Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

На мой взгляд push метод, потому что сервер инициирует отправку конфигурации тогда, когда нужно.


#### Задача 3 Установить на личный компьютер:
•	VirtualBox
•	Vagrant
•	Ansible
Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.

Vagrant
```shell
PS C:\Users\kagarkova> vagrant --version
Vagrant 2.3.1
```
VirtualBox
```shell
Графический интерфейс VirtualBox
Версия 6.1.34 r150636 (Qt5.6.2)
Copyright © 2022 Oracle Corporation and/or its affiliates. All rights reserved.
```
Ansible установлен внутри виртуально машины.
```shell
ansible --version
ansible 2.9.25
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /bin/ansible
  python version = 2.7.5 (default, Oct 14 2020, 14:45:30) [GCC 4.8.5 20150623 (Red Hat 4.8.5-44)]
```
#### Задача 4 (*) Воспроизвести практическую часть лекции самостоятельно.
•	Создать виртуальную машину.
•	Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
docker ps

###### Я создала виртуальную машину не через vagrant, так как приложенный Vagrantfile  у меня не заработал. Установила Ansible на виртуальную машину, добавила в файл /etc/ansible/hosts новый сервер.
```shell
ansible -m ping all
nginx-web-2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
Запустила playbook
```shell
ansible-playbook /etc/ansible/docker-pley.yml -kK
SSH password:
BECOME password[defaults to SSH password]:

PLAY [Playbook] **********************************************************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************************************************
ok: [nginx-web-2]

TASK [Installing tools] **************************************************************************************************************************************
[DEPRECATION WARNING]: Invoking "apt" only once while using a loop via squash_actions is deprecated. Instead of using a loop to supply multiple items and
specifying `package: "{{ item }}"`, please use `package: ['git', 'curl']` and remove the loop. This feature will be removed in version 2.11. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [nginx-web-2] => (item=[u'git', u'curl'])

TASK [Installing docker] *************************************************************************************************************************************
[WARNING]: Consider using the get_url or uri module rather than running 'curl'.  If you need to use command because get_url or uri is insufficient you can
add 'warn: false' to this command task or set 'command_warnings=False' in ansible.cfg to get rid of this message.
changed: [nginx-web-2]

TASK [Add the current user to docker group] ******************************************************************************************************************
changed: [nginx-web-2]

PLAY RECAP ***************************************************************************************************************************************************
nginx-web-2                : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
На сервере, на который производилась установка:
```shell
docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
```shell
docker version
Client: Docker Engine - Community
 Version:           20.10.22
 API version:       1.41
 Go version:        go1.18.9
 Git commit:        3a2c30b
 Built:             Thu Dec 15 22:28:08 2022
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.22
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.18.9
  Git commit:       42c8b31
  Built:            Thu Dec 15 22:25:58 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.15
  GitCommit:        5b842e528e99d4d4c1686467debf2bd4b88ecd86
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```