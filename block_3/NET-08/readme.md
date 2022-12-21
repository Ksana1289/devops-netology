### Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"
#### 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```shell
telnet route-views.routeviews.org
Username: rviews
```
```shell
show ip route 188.233.xx.xx
Routing entry for 188.233.xx.0/32
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 4w5d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 4w5d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
```
```shell
show bgp 188.233.xx.xx
BGP routing table entry for 188.233.xx.0/32, version 2533235742
Paths: (23 available, best #17, table default)
  Not advertised to any peer
  Refresh Epoch 1
  3561 3910 3356 9002 9002 9002 9002 9002 9049 9049 39435
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE0549E7158 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1257 1299 9049 39435
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 1257:50 1257:51 1257:2000 1257:3528 1257:4103
      path 7FE11B0B7A70 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 9049 39435
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0F2700800 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 9049 39435
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE087E957D8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1299 9049 39435
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE0BAC56250 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1299 9049 39435
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1299:30000 8283:1 8283:101
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
```
#### 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
Запуск модуля
```shell
echo "dummy" > /etc/modules-load.d/dummy.conf
echo "options dummy numdummies=2" > /etc/modprobe.d/dummy.conf
```
Настройка интерфейса
```shell
cat << "EOF" >> /etc/systemd/network/10-dummy0.netdev
[NetDev]
Name=dummy0
Kind=dummy
EOF
# cat << "EOF" >> /etc/systemd/network/20-dummy0.network
[Match]
Name=dummy0

[Network]
Address=10.0.8.1/24
EOF

systemctl restart systemd-networkd
```
Добавление статического маршрута (рфботает до перезагрузки)
```shell
sudo ip route add 10.0.4.0/24 via 10.0.2.2
RTNETLINK answers: File exists
sudo ip route add 10.10.5.0/24 via 10.0.2.15
```
Таблица маршрутизации
```shell
ip r
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
10.0.4.0/24 via 10.0.2.2 dev enp0s3
10.0.8.0/24 dev dummy0 proto kernel scope link src 10.0.8.1
10.10.5.0/24 via 10.0.2.15 dev enp0s3
```
Добавление статического маршрута
```shell
nano /etc/netplan/02-networkd.yaml
network:
  version: 2
  ethernets:
    eth0:
      optional: true
      addresses:
        - 10.0.2.3/24
      routes:
        - to: 10.0.4.0/24
          via: 10.0.2.2

netplan --debug generate
netplan apply
```
Таблица маршрутизации
```shell
ip r
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.3
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
10.0.4.0/24 via 10.0.2.2 dev enp0s3 proto static
10.0.8.0/24 dev dummy0 proto kernel scope link src 10.0.8.1
```
#### 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```shell
ss -tnlp
State    Recv-Q   Send-Q      Local Address:Port       Peer Address:Port   Process
LISTEN   0        4096        127.0.0.53%lo:53              0.0.0.0:*       users:(("systemd-resolve",pid=764,fd=13))
LISTEN   0        128               0.0.0.0:22              0.0.0.0:*       users:(("sshd",pid=871,fd=3))
LISTEN   0        128                  [::]:22                 [::]:*       users:(("sshd",pid=871,fd=4))
```
53 порт - DNS
22 порт - SSH

#### 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```shell
ss -unap
State    Recv-Q   Send-Q        Local Address:Port     Peer Address:Port   Process
UNCONN   0        0             127.0.0.53%lo:53            0.0.0.0:*       users:(("systemd-resolve",pid=764,fd=12))
UNCONN   0        0          10.0.2.15%enp0s3:68            0.0.0.0:*       users:(("systemd-network",pid=11064,fd=22))
```
53 порт - DNS.
68 порт использует DHCP для отправки сообщений клиентам.

#### 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
 image.png
#### 6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.
Создаем директорию для хоста
```shell
mkdir /var/www/balans.local
```
Теперь нам необходимо создать виртуальный хост balans.local, запросы которого мы и будем распределять.
```shell
nano /etc/nginx/sites-available/balans.local

upstream backend {
    server 192.168.1.32:8080;
    server 192.168.1.42:8080;
}

server {
    listen    80;
    server_name  balans.local;
    location ~* \.()$ {
    root   /var/www/balans.local;  }
    location / {
    client_max_body_size    10m;
    client_body_buffer_size 128k;
    proxy_send_timeout   90;
    proxy_read_timeout   90;
    proxy_buffer_size    4k;
    proxy_buffers     16 32k;
    proxy_busy_buffers_size 64k;
    proxy_temp_file_write_size 64k;
    proxy_connect_timeout 30s;
    proxy_pass   http://backend;
    proxy_set_header   Host   $host;
    proxy_set_header   X-Real-IP  $remote_addr;
    proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
       }
location ~* /.(jpg|jpeg|gif|png|css|mp3|avi|mpg|txt|js|jar|rar|zip|tar|wav|wmv)$ {
root    /var/www/balans.local;}
 }
 ```
Добавляем символическую ссылку в sites-enabled.
```shell
ln -s /etc/nginx/sites-available/balans.local /etc/nginx/sites-enabled/
```
Удалим стандартную настройку порта 80
```shell
rm -f /etc/nginx/sites-enabled/default
```
Перезапускаем nginx
```shell
sudo systemctl reload nginx
```
Настройка нод 
```shell
sudo  nano /etc/nginx/sites-available/default
```
В секции server { находим строку:
```shell
listen 80 default
```
и меняем порт на тот, что мы указали в конфигурационном файле, виртуального хоста balans.local на балансировщике.
```shell
listen 8080 default;
```
Перезапускаем Nginx

Далее, для того чтобы увидеть, как происходит перенаправление запросов между серверами, нам необходимо отредактировать index.html который лежит в корневой директории этого сервера:
```shell
sudo nano /var/www/html/index.html
```
Находим там строку:
```shell
<center><h1>Welcome to nginx!</h1></center>
```
Вписываем туда NODE1.
Делается это для того, чтобы было видно, какой сервер прислал ответ в данный момент.
Повторяем на остальных нодах.

Открываем браузер и переходим по адресу балансировщика.

 image.png
 image.png

#### 7*. Установите bird2, настройте динамический протокол маршрутизации RIP.
#### 8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.
```shell
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF
docker-compose pull
docker-compose up
```
Запрос на создание префикса через curl
```shell
curl -ss -X POST \
-H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
http://192.168.1.22:8000/api/ipam/prefixes/ \
--data '{
    "prefix": "10.0.18.0/24"
}' | jq .
```
Ответ:
```shell
{
  "id": 2,
  "url": "http://192.168.1.22:8000/api/ipam/prefixes/2/",
  "display": "10.0.18.0/24",
  "family": {
    "value": 4,
    "label": "IPv4"
  },
  "prefix": "10.0.18.0/24",
  "site": null,
  "vrf": null,
  "tenant": null,
  "vlan": null,
  "status": {
    "value": "active",
    "label": "Active"
  },
  "role": null,
  "is_pool": false,
  "mark_utilized": false,
  "description": "",
  "comments": "",
  "tags": [],
  "custom_fields": {},
  "created": "2022-12-21T16:06:33.117624Z",
  "last_updated": "2022-12-21T16:06:33.117644Z",
  "children": 0,
  "_depth": 0
}
```
image.png