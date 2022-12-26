### Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"
#### Задание 1
Есть скрипт:
```shell
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```
Какие значения переменным c,d,e будут присвоены? Почему?

###### c = a+b - потому что переменным может быть присвоено целое число либо строка. a+b не целое число, значит присвоилась строка. А так как нет знака $, то выводится просто строка, а не переменные a и b,
###### d = 1+2 - переменная d не целочисленная, соответственно присвоилась строка значений a и b,
###### e = 3 - потому что благодаря $(( )) происходит арифметическое действие над целыми числами переменных a и b.

#### Задание 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```shell
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		    date >> curl.log
	fi
done
```
Ваш скрипт:
Не хватает скобки в ((1==1). Я добавила else exit для того, чтобы вывод прекратился. Sleep 3 для задержки опроса в 3 секунды.
```shell
while ((1==1))
do
        curl https://localhost:4757
        if (($? != 0))
        then
                date >> curl.log
                sleep 3
        else
                exit

        fi
done
```
#### Задание 3
Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.
Ваш скрипт:
```shell
#!/bin/bash
declare -i test=1
while (($test<=5))
do
    for host in 192.168.0.1 173.194.222.113 87.250.250.242; do
        nc -zw1 $host 80
        echo $? $host `date` >> nc_host.log
    done
test+=1
sleep 1
done
```
#### Задание 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.
Ваш скрипт:
```shell
#!/bin/bash
declare -i test=1
while (($test==1))
do
    for host in 192.168.0.1 173.194.222.113 87.250.250.242; do
        nc -zw1 $host 80
        if (($?!=0))
        then
            echo $? $host `date` >> error.log
            exit 0
        else
            echo $? $host `date` >> nc_host.log
        fi
    done
sleep 1
done
```