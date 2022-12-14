Домашнее задание к занятию "3.4. Операционные системы. Лекция 2"
1.	На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:
o	поместите его в автозагрузку,
o	предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
o	удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Установка.
wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar xzf node_exporter-1.4.0.linux-amd64.tar.gz
sudo touch /opt/node_exporter.env
echo "EXTRA_OPTS=\"--log.level=info\"" | sudo tee /opt/node_exporter.env
sudo mv node_exporter-1.4.0.linux-amd64/node_exporter /usr/local/bin/
sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/node_exporter
StandardOutput=file:/var/log/node_explorer.log
StandardError=file:/var/log/node_explorer.log

[Install]
WantedBy=multi-user.target
EOF
Перезапускаю демон сервисов: sudo systemctl daemon-reload
Стартую сервис: sudo systemctl start node_exporter
Добавляю его в автозагрузку: sudo systemctl enable node_exporter

Добавление опций к запускаемому процессу через внешний файл.
echo "EXTRA_OPTS=\"--log.level=info\"" | sudo tee opt/node_exporter.env

Перезапускаю машину. Проверяю статус.
sudo systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2022-11-11 12:43:21 UTC; 8min ago
   Main PID: 675 (node_exporter)
      Tasks: 5 (limit: 1131)
     Memory: 14.0M
     CGroup: /system.slice/node_exporter.service
             └─675 /usr/local/bin/node_exporter

Nov 11 12:43:21 ubuntu-focal systemd[1]: Started Node Exporter.

sudo journalctl -u node_exporter.service
-- Logs begin at Wed 2022-10-19 13:29:59 UTC, end at Fri 2022-11-11 12:50:54 UTC. --
Nov 11 12:35:57 ubuntu-focal systemd[1]: Started Node Exporter.
Nov 11 12:43:09 ubuntu-focal systemd[1]: Stopping Node Exporter...
Nov 11 12:43:09 ubuntu-focal systemd[1]: node_exporter.service: Succeeded.
Nov 11 12:43:09 ubuntu-focal systemd[1]: Stopped Node Exporter.
-- Reboot --
Nov 11 12:43:21 ubuntu-focal systemd[1]: Started Node Exporter.

2.	Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

curl http://localhost:9100/metrics | grep cpu
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 7275.53
node_cpu_seconds_total{cpu="0",mode="iowait"} 0.48
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0
node_cpu_seconds_total{cpu="0",mode="softirq"} 0.73
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 4.08
node_cpu_seconds_total{cpu="0",mode="user"} 2.24
node_cpu_seconds_total{cpu="1",mode="idle"} 251368.27
node_cpu_seconds_total{cpu="1",mode="iowait"} 0.3
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0
node_cpu_seconds_total{cpu="1",mode="softirq"} 0.8
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 3.06
node_cpu_seconds_total{cpu="1",mode="user"} 3.23

# TYPE node_memory_MemAvailable_bytes gauge
node_memory_MemAvailable_bytes 7.09341184e+08
100 58430    0 58430    0     0  1630k      0 --:--:-- --:--:-- --:--:-- 1678k
# TYPE node_memory_MemFree_bytes gauge
node_memory_MemFree_bytes 4.17816576e+08
100 58429    0 58429    0     0  1783k      0 --:--:-- --:--:-- --:--:-- 1783k
# TYPE node_memory_MemTotal_bytes gauge
node_memory_MemTotal_bytes 1.024118784e+09
100 58410    0 58410    0     0  3565k      0 --:--:-- --:--:-- --:--:-- 3565k
# TYPE node_memory_SwapCached_bytes gauge
node_memory_SwapCached_bytes 0
100 58449    0 58449    0     0  3805k      0 --:--:-- --:--:-- --:--:-- 3805k
# TYPE node_memory_SwapFree_bytes gauge
node_memory_SwapFree_bytes 0
100 58415    0 58415    0     0  4753k      0 --:--:-- --:--:-- --:--:-- 4753k

# TYPE node_disk_io_time_seconds_total counter
node_disk_io_time_seconds_total{device="sda"} 4.208
node_disk_io_time_seconds_total{device="sdb"} 0.064
# TYPE node_disk_read_bytes_total counter
node_disk_read_bytes_total{device="sda"} 2.97294848e+08
node_disk_read_bytes_total{device="sdb"} 2.217984e+06
# TYPE node_disk_read_time_seconds_total counter
node_disk_read_time_seconds_total{device="sda"} 1.856
node_disk_read_time_seconds_total{device="sdb"} 0.031
# TYPE node_disk_write_time_seconds_total counter
node_disk_write_time_seconds_total{device="sda"} 0.8230000000000001
node_disk_write_time_seconds_total{device="sdb"} 0

# TYPE node_network_up gauge
node_network_up{device="enp0s3"} 1
node_network_up{device="lo"} 0
# TYPE node_network_receive_errs_total counter
node_network_receive_errs_total{device="enp0s3"} 0
node_network_receive_errs_total{device="lo"} 0
# TYPE node_network_transmit_errs_total counter
node_network_transmit_errs_total{device="enp0s3"} 0
node_network_transmit_errs_total{device="lo"} 0
# TYPE node_network_receive_bytes_total counter
node_network_receive_bytes_total{device="enp0s3"} 743956
node_network_receive_bytes_total{device="lo"} 1.616991e+06
# TYPE node_network_transmit_bytes_total counter
node_network_transmit_bytes_total{device="enp0s3"} 397948
node_network_transmit_bytes_total{device="lo"} 1.677553e+06

3.	Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata).
После успешной установки:
o	в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,

nano /etc/netdata/netdata.conf 
[global]
        run as user = netdata
        web files owner = root
        web files group = root
        # Netdata is not designed to be exposed to potentially hostile
        # networks. See https://github.com/netdata/netdata/issues/164
        # bind socket to IP = 127.0.0.1
        bind to = 0.0.0.0

o	добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999

vagrant port
The forwarded ports for the machine are listed below. Please note that
these values may differ from values configured in the Vagrantfile if the
provider supports automatic port collision detection and resolution.

    22 (guest) => 2222 (host)
 19999 (guest) => 19999 (host)

После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

http://localhost:19999
 
![2022-11-15_14-48-55](https://user-images.githubusercontent.com/75307275/201919356-98536e79-5e18-4d24-afd8-eb95cda9fb79.png)

4.	Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Можно, выводит сообщение Hypervisor detected
dmesg | grep KVM
[    0.000000] Hypervisor detected: KVM
[    0.057489] Booting paravirtualized kernel on KVM

5.	Как настроен sysctl fs.nr_open на системе по-умолчанию? Определите, что означает этот параметр. 

fs.nr_open - жесткий лимит на открытые дескрипторы для ядра (системы
sysctl fs.nr_open
fs.nr_open = 1048576

Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

ulimit -Sn
1024
Soft limit на пользователя, может быть изменен как большую, так и меньшую сторону

ulimit -Hn
1048576
Hard limit на пользователя, может быть изменен только в меньшую сторону
Оба ulimit -n не могут превышать fs.nr_open

6.	Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

Терминал 1:
unshare -f --pid --mount-proc sleep 1h
Терминал 2:
ps -e | grep sleep
   1936 pts/1    00:00:00 sleep
nsenter --target 1936 --pid --mount
ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   7228   580 pts/1    S+   12:42   0:00 sleep 1h
root           2  0.0  0.5  10036  5076 pts/0    S    12:46   0:00 -bash
root          13  0.0  0.3  10612  3248 pts/0    R+   12:47   0:00 ps aux

7.	Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации.
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Это fork bomb, бесконечно создающая свои копии (системным вызовом fork())

-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
-bash: fork: Resource temporarily unavailable
Терминал зависает. Сама ОС не стабилизируется.
Изменение значения TasksMax в /usr/lib/systemd/system/user-.slice.d/10-defaults.conf, а также назначения новых лимитов через ulimit -u 20, ничего не дает.
ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 3770
max locked memory       (kbytes, -l) 65536
max memory size         (kbytes, -m) unlimited
open files                      (-n) 1024
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 20
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
