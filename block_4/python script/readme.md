### Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"
#### 1.	Есть скрипт:
```shell
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
o	Какое значение будет присвоено переменной c?
```shell
Traceback (most recent call last):
  File "./1.sh", line 4, in <module>
    c = a + b
TypeError: unsupported operand type(s) for +: 'int' and 'str'
```
o	Как получить для переменной c значение 12?
```shell
#!/usr/bin/env python3
a = 1
b = '2'
c = str(a) + b
print (c)
```
o	Как получить для переменной c значение 3?
```shell
#!/usr/bin/env python3
a = 1
b = '2'
c = a + int(b)
print (c)
```
#### 2.	Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?
```shell
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```
Ответ:
```shell
#!/usr/bin/env python3

import os

path = "~/netology/sysadm-homeworks"
bash_command = [f"cd {path}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        path_to_file = os.path.expanduser(path + '/' + prepare_result)
        print(path_to_file)
```
```shell
ksana@apache:~/python$ ./2.sh
/home/ksana/netology/sysadm-homeworks/03-sysadmin-07-net/README.md
/home/ksana/netology/sysadm-homeworks/04-script-02-py/README.md
```
#### 3.	Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.
```shell
#!/usr/bin/env python3

import os

print("Введите путь до репозитория или нажмите ENTER для использования адреса по умолчанию")
path = input("Путь до репозитория: ")
if not path:
    path = "~/netology/sysadm-homeworks"
bash_command = [f"cd {path}", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        path_to_file = os.path.expanduser(path + '/' + prepare_result)
        print(path_to_file)
```
```shell
ksana@apache:~/python$ ./3.sh
Введите путь до репозитория или нажмите ENTER для использования адреса по умолчанию
Путь до репозитория:
/home/ksana/netology/sysadm-homeworks/03-sysadmin-07-net/README.md
/home/ksana/netology/sysadm-homeworks/04-script-02-py/README.md
```
#### 4.	Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 
Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 
Мы хотим написать скрипт, который:
•	опрашивает веб-сервисы,
•	получает их IP,
•	выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

Ответ:
```shell
#!/usr/bin/env python3

import re
from sh import ping

url_list = ('drive.google.com', 'mail.google.com', 'google.com')

results_for_ping = {}

for url in url_list:
    output = ping("-c", 1, url)
    for line in output:
        if line.find('PING') != -1:
            urll = re.findall('PING \S*', line)
            url = urll[0].replace('PING ', '')
            ip = re.findall ('\d*[.]\d*[.]\d*[.]\d*', line)
            print(url, ' - ', ip[0])
            results_for_ping[url]=ip[0]

condition  = input("Напишите <+> если требуется проверка новых IP адресов: ")

if condition == '+':
    with open ('./4.txt', 'r') as file:
        lines = file.read().splitlines()
    for line in lines:
        key,value = line.split(' ')
        if value not in results_for_ping[key]:
            print(f'[ERROR] {key} IP mismatch: {value} {results_for_ping[key]}')

with open('./4.txt', 'w') as file:
    for key,value in results_for_ping.items():
        file.write(f'{key} {value}\n'))
```
```shell
ksana@apache:~/python$ ./4.sh
wide-docs.l.google.com  -  173.194.222.194
mail.google.com  -  64.233.161.17
google.com  -  173.194.73.102
Напишите <+> если требуется проверка новых IP адресов: +
[ERROR] mail.google.com IP mismatch: 64.233.163.19 64.233.161.17
[ERROR] google.com IP mismatch: 173.194.73.100 173.194.73.102
```