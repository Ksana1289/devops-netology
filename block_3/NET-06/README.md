### Домашнее задание к занятию "3.6. Компьютерные сети. Лекция 1"
#### 1.	Работа c HTTP через телнет.
•	Подключитесь утилитой телнет к сайту stackoverflow.com telnet stackoverflow.com 80
•	Отправьте HTTP запрос
```shell
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
•	В ответе укажите полученный HTTP код, что он означает?
```shell
HTTP/1.1 403 Forbidden
Connection: close
Content-Length: 1923
Server: Varnish
Retry-After: 0
Content-Type: text/html
Accept-Ranges: bytes
Date: Tue, 22 Nov 2022 21:55:33 GMT
Via: 1.1 varnish
X-Served-By: cache-hel1410024-HEL
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1669154133.347068,VS0,VE2
X-DNS-Prefetch-Control: off

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Forbidden - Stack Exchange</title>
    <style type="text/css">
                body
                {
                        color: #333;
                        font-family: 'Helvetica Neue', Arial, sans-serif;
                        font-size: 14px;
                        background: #fff url('img/bg-noise.png') repeat left top;
                        line-height: 1.4;
                }
                h1
                {
                        font-size: 170%;
                        line-height: 34px;
                        font-weight: normal;
                }
                a { color: #366fb3; }
                a:visited { color: #12457c; }
                .wrapper {
                        width:960px;
                        margin: 100px auto;
                        text-align:left;
                }
                .msg {
                        float: left;
                        width: 700px;
                        padding-top: 18px;
                        margin-left: 18px;
                }
    </style>
</head>
<body>
    <div class="wrapper">
                <div style="float: left;">
                        <img src="https://cdn.sstatic.net/stackexchange/img/apple-touch-icon.png" alt="Stack Exchange" />
                </div>
                <div class="msg">
                        <h1>Access Denied</h1>
                        <p>This IP address (188.233.53.190) has been blocked from access to our services. If you believe this to be in error, please contact us at <a href="mailto:team@stackexchange.com?Subject=Blocked%20188.233.53.190%20(Request%20ID%3A%203379438533-HEL)">team@stackexchange.com</a>.</p>
                        <p>When contacting us, please include the following information in the email:</p>
                        <p>Method: block</p>
                        <p>XID: 3379438533-HEL</p>
                        <p>IP: 188.233.53.190</p>
                        <p>X-Forwarded-For: </p>
                        <p>User-Agent: </p>

                        <p>Time: Tue, 22 Nov 2022 21:55:33 GMT</p>
                        <p>URL: stackoverflow.com/questions</p>
                        <p>Browser Location: <span id="jslocation">(not loaded)</span></p>
                </div>
        </div>
        <script>document.getElementById('jslocation').innerHTML = window.location.href;</script>
</body>
</html>Connection closed by foreign host.
```
Ошибка 403 Forbidden – это код состояния HTTP, который означает, что доступ к странице или ресурсу, по какой-то причине абсолютно запрещен.

#### 2.	Повторите задание 1 в браузере, используя консоль разработчика F12.
•	откройте вкладку Network
•	отправьте запрос http://stackoverflow.com
•	найдите первый ответ HTTP сервера, откройте вкладку Headers
•	укажите в ответе полученный HTTP код.
•	проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
•	приложите скриншот консоли браузера в ответ.

stackoverflow.com работает по протоколу https.
В ответ получили код 200 OK
 ![image](https://user-images.githubusercontent.com/75307275/203605167-e554d252-6c7c-46be-86a8-4ddf5705dbfe.png)

Страница полностью загрузилась за 5.53 s. Самый долгий запрос - начальная загрузка страницы Request URL https://stackoverflow.com/ 389 ms

#### 3.	Какой IP адрес у вас в интернете?
```shell
dig @resolver4.opendns.com myip.opendns.com +short
188.233.XX.XXX
```
#### 4.	Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
```shell
whois 188.233.XX.XXX | grep netname
netname:        BSKYB-BROADBAND
whois 188.233.XX.XXX | grep origin
origin:         AS5607
```
#### 5.	Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute
```shell
traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  192.168.1.1 [*]  14.486 ms  14.437 ms  14.075 ms
 2  * * *
 3  88.87.67.34 [AS39435]  20.659 ms  20.300 ms  20.254 ms
 4  72.14.215.165 [AS15169]  49.619 ms  49.495 ms  45.305 ms
 5  72.14.215.166 [AS15169]  43.268 ms  43.223 ms  42.602 ms
 6  * * *
 7  108.170.250.129 [AS15169]  69.100 ms 72.14.233.94 [AS15169]  68.348 ms 172.253.69.166 [AS15169]  68.189 ms
 8  108.170.250.146 [AS15169]  68.065 ms 108.170.250.66 [AS15169]  67.920 ms 108.170.250.83 [AS15169]  67.682 ms
 9  172.253.66.116 [AS15169]  67.638 ms 72.14.234.20 [AS15169]  68.346 ms 172.253.66.116 [AS15169]  67.314 ms
10  216.239.43.20 [AS15169]  67.800 ms 72.14.235.69 [AS15169]  51.170 ms 209.85.254.6 [AS15169]  50.893 ms
11  172.253.51.239 [AS15169]  55.561 ms  55.533 ms 216.239.47.167 [AS15169]  50.352 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  54.187 ms * *
```
Пакет проходит через AS - AS39435, AS15169
```shell
grep OrgName <(whois AS15169)
OrgName:        Google LLC\
```
AS39435 не определяется

#### 6.	Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
```shell
mtr 8.8.8.8 -znrc 1
Start: 2022-11-23T15:36:45+0000
HOST: ubuntu-focal                Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    10.0.2.2             0.0%     1    0.8   0.8   0.8   0.8   0.0
  2. AS???    192.168.1.1          0.0%     1  474.2 474.2 474.2 474.2   0.0
  3. AS???    10.93.254.252        0.0%     1  469.0 469.0 469.0 469.0   0.0
  4. AS39435  88.87.67.34          0.0%     1  459.6 459.6 459.6 459.6   0.0
  5. AS15169  72.14.215.165        0.0%     1  474.4 474.4 474.4 474.4   0.0
  6. AS15169  72.14.215.166        0.0%     1  514.4 514.4 514.4 514.4   0.0
  7. AS15169  108.170.250.33       0.0%     1  503.7 503.7 503.7 503.7   0.0
  8. AS15169  108.170.250.34       0.0%     1  491.6 491.6 491.6 491.6   0.0
  9. AS15169  172.253.66.116       0.0%     1  485.5 485.5 485.5 485.5   0.0
 10. AS15169  72.14.235.69         0.0%     1  533.2 533.2 533.2 533.2   0.0
 11. AS15169  216.239.49.3         0.0%     1  530.5 530.5 530.5 530.5   0.0
 12. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 13. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 14. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 15. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 16. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 17. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 18. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 19. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 20. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
 21. AS15169  8.8.8.8              0.0%     1  261.6 261.6 261.6 261.6   0.0
```
Наибольшая задержка на 10 хопе

#### 7.	Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? Воспользуйтесь утилитой dig
```shell
dig +short NS dns.google
ns2.zdns.google.
ns3.zdns.google.
ns4.zdns.google.
ns1.zdns.google.
dig +short A dns.google
8.8.8.8
8.8.4.4
```
#### 8.	Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? Воспользуйтесь утилитой dig
```shell
for ip in `dig +short A dns.google`; do dig -x $ip | grep ^[0-9].*in-addr; done
8.8.8.8.in-addr.arpa.   6914    IN      PTR     dns.google.
4.4.8.8.in-addr.arpa.   6913    IN      PTR     dns.google.###
```
