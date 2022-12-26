Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
1. Установите Bitwarden плагин для браузера. Зарегистрируйтесь и сохраните несколько паролей.
  
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden аккаунт через Google authenticator OTP.
  
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

sudo apt install apache2
sudo a2enmod ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \-keyout /etc/ssl/private/apache-selfsigned.key \-out /etc/ssl/certs/apache-selfsigned.crt \-subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=www. site-dev.local"

sudo a2enmod ssl
sudo systemctl restart apache2
nano /etc/apache2/sites-available/site-dev-ssl.conf
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin webmaster@site-dev.local

                DocumentRoot /var/www/site-dev.local

                ServerName site-dev.local

                # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
                # error, crit, alert, emerg.
                # It is also possible to configure the loglevel for particular
                # modules, e.g.
                #LogLevel info ssl:warn

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                # For most configuration files from conf-available/, which are
                # enabled or disabled at a global level, it is possible to
                # include a line for only one particular virtual host. For example the
                # following line enables the CGI configuration for this host only
                # after it has been globally disabled with "a2disconf".
                #Include conf-available/serve-cgi-bin.conf

                #   SSL Engine Switch:
                #   Enable/Disable SSL for this virtual host.
                SSLEngine on

                #   A self-signed (snakeoil) certificate can be created by installing
                #   the ssl-cert package. See
                #   /usr/share/doc/apache2/README.Debian.gz for more info.
                #   If both key and certificate are stored in the same file, only the
                #   SSLCertificateFile directive is needed.
                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

ln -s /etc/apache2/sites-available/site-dev-ssl.conf /etc/apache2/sites-enabled/

a2ensite site-dev-ssl.conf
apache2 -t
systemctl reload apache2
systemctl status apache2
image.png
 
4. Проверьте на TLS уязвимости произвольный сайт в интернете.

git clone https://github.com/drwetter/testssl.sh.git
./testssl.sh -e --fast --parallel https://www.google.com/

###########################################################
    testssl.sh       3.2rc2 from https://testssl.sh/dev/
    (198bb09 2022-11-28 17:09:04)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~183 ciphers]
 on apache:./bin/openssl.Linux.x86_64
 (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")


Testing all IPv4 addresses (port 443): 209.85.233.105 209.85.233.103 209.85.233.106 209.85.233.104 209.85.233.99 209.85.233.147
---------------------------------------------------------------------------------------------------------
 Start 2022-12-23 12:41:43        -->> 209.85.233.105:443 (www.google.com) <<--

 Further IP addresses:   209.85.233.147 209.85.233.99 209.85.233.104 209.85.233.106 209.85.233.103 2a00:1450:4010:c06::63 2a00:1450:4010:c06::67
                         2a00:1450:4010:c06::93 2a00:1450:4010:c06::6a
 rDNS (209.85.233.105):  lr-in-f105.1e100.net.
 Service detected:       HTTP



 Testing all 183 locally available ciphers against the server, ordered by encryption strength


Hexcode  Cipher Suite Name (OpenSSL)       KeyExch.   Encryption  Bits     Cipher Suite Name (IANA/RFC)
-----------------------------------------------------------------------------------------------------------------------------
 xc030   ECDHE-RSA-AES256-GCM-SHA384       ECDH 256   AESGCM      256      TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
 xc02c   ECDHE-ECDSA-AES256-GCM-SHA384     ECDH 256   AESGCM      256      TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
 xc014   ECDHE-RSA-AES256-SHA              ECDH 256   AES         256      TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
 xc00a   ECDHE-ECDSA-AES256-SHA            ECDH 256   AES         256      TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
 x9d     AES256-GCM-SHA384                 RSA        AESGCM      256      TLS_RSA_WITH_AES_256_GCM_SHA384
 x35     AES256-SHA                        RSA        AES         256      TLS_RSA_WITH_AES_256_CBC_SHA
 xc02f   ECDHE-RSA-AES128-GCM-SHA256       ECDH 256   AESGCM      128      TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
 xc02b   ECDHE-ECDSA-AES128-GCM-SHA256     ECDH 256   AESGCM      128      TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
 xc013   ECDHE-RSA-AES128-SHA              ECDH 256   AES         128      TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
 xc009   ECDHE-ECDSA-AES128-SHA            ECDH 256   AES         128      TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
 x9c     AES128-GCM-SHA256                 RSA        AESGCM      128      TLS_RSA_WITH_AES_128_GCM_SHA256
 x2f     AES128-SHA                        RSA        AES         128      TLS_RSA_WITH_AES_128_CBC_SHA
 x0a     DES-CBC3-SHA                      RSA        3DES        168      TLS_RSA_WITH_3DES_EDE_CBC_SHA


 Done 2022-12-23 12:41:49 [   8s] -->> 209.85.233.105:443 (www.google.com) <<--


5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ksana/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ksana/.ssh/id_rsa
Your public key has been saved in /home/ksana/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:hWZ3y3dbpohOtSWl3enWYJi550QHeC7ze9qLEUwiaP0 ksana@apache
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|        o.   .   |
|       o+oo.o.+  |
|      .o ooo+@ o.|
|        S  E%oO.*|
|           o &o*+|
|          o +.=+.|
|         o   ++o.|
|          .  .++o|
+----[SHA256]-----+
ssh-copy-id -i .ssh/id_rsa ksana@192.168.1.42
ssh ksana@192.168.1.42
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)
………………
ksana@ng-web2:~$
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
mv ~/.ssh/id_rsa ~/.ssh/id_rsa_web2
mv ~/.ssh/id_rsa.pub ~/.ssh/id_rsa_web2.pub
nano ~/.ssh/config
Host ng-web2
        HostName 192.168.1.42
        User ksana
        Port 22
        IdentityFile ~/.ssh/id_rsa_web2
ssh ng-web2
Welcome to Ubuntu 20.04.5 LTS (GNU/Linux 5.4.0-135-generic x86_64)
………………
ksana@ng-web2:~$
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
sudo tcpdump -c 5 -i ens33 port 22 -w ssh.pcap
tcpdump: listening on ens33, link-type EN10MB (Ethernet), capture size 262144 bytes
5 packets captured
6 packets received by filter
0 packets dropped by kernel

sudo apt install wireshark
sudo usermod -aG wireshark ksana
wireshark
 image.png

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

nmap scanme.nmap.org
Starting Nmap 7.80 ( https://nmap.org ) at 2022-12-26 07:40 UTC
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.22s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
Not shown: 993 closed ports
PORT      STATE    SERVICE
22/tcp    open     ssh
80/tcp    open     http
135/tcp   filtered msrpc
139/tcp   filtered netbios-ssn
445/tcp   filtered microsoft-ds
9929/tcp  open     nping-echo
31337/tcp open     Elite

Cервисы ssh, http, nping-echo, Elite.

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443

sudo ufw enable 
sudo ufw status verbose

Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

sudo ufw app list
Available applications:
  Apache
  Apache Full
  Apache Secure
  OpenSSH

sudo ufw allow http
sudo ufw allow https
sudo ufw allow ssh
sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
443/tcp                    ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
22/tcp                     ALLOW IN    Anywhere
443/tcp (v6)               ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
22/tcp (v6)                ALLOW IN    Anywhere (v6)
