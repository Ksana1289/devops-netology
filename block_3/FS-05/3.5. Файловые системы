Домашнее задание к занятию "3.5. Файловые системы"
1.	Узнайте о sparse (разряженных) файлах.
Файлы с пустотами на диске. Записи пустот на диск не происходит, информация о них хранится только в метаданных.
2.	Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Нет, не могут, т.к. это просто ссылки на один и тот же inode - в нём и хранятся права доступа и имя владельца.
3.	Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
path_to_disk_folder = './disks'

host_params = {
    'disk_size' => 2560,
    'disks'=>[1, 2],
    'cpus'=>2,
    'memory'=>2048,
    'hostname'=>'sysadm-fs',
    'vm_name'=>'sysadm-fs'
}
Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-20.04"
    config.vm.hostname=host_params['hostname']
    config.vm.provider :virtualbox do |v|

        v.name=host_params['vm_name']
        v.cpus=host_params['cpus']
        v.memory=host_params['memory']

        host_params['disks'].each do |disk|
            file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
            unless File.exist?(file_to_disk)
                v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
            end
            v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        end
    end
    config.vm.network "private_network", type: "dhcp"
end
Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

Данная конфигурация не работает. Машина создается, но подключиться к ней не получается.
Добавила диски ручками.
lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0    7:0    0 63.2M  1 loop /snap/core20/1623
loop1    7:1    0   48M  1 loop /snap/snapd/17029
loop2    7:2    0 67.8M  1 loop /snap/lxd/22753
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0   10M  0 disk
sdc      8:32   0  2.5G  0 disk
sdd      8:48   0  2.5G  0 disk

4.	Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x2104e581.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-5242879, default 2048): 2048
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
loop0    7:0    0 67.8M  1 loop /snap/lxd/22753
loop1    7:1    0   48M  1 loop /snap/snapd/17029
loop2    7:2    0 63.2M  1 loop /snap/core20/1623
loop3    7:3    0 49.7M  1 loop /snap/snapd/17576
loop4    7:4    0 63.2M  1 loop /snap/core20/1695
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0   10M  0 disk
sdc      8:32   0  2.5G  0 disk
├─sdc1   8:33   0    2G  0 part
└─sdc2   8:34   0  511M  0 part
sdd      8:48   0  2.5G  0 disk
sudo fdisk –l
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x2104e581

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

5.	Используя sfdisk, перенесите данную таблицу разделов на второй диск.

sudo sfdisk -d /dev/sdc > sdc.dump
sudo sfdisk /dev/sdd < sdc.dump
Checking that no-one is using this disk right now ... OK

Disk /dev/sdd: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x2104e581.
/dev/sdd1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdd2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdd3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x2104e581

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdd1          2048 4196351 4194304    2G 83 Linux
/dev/sdd2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

6.	Соберите mdadm RAID1 на паре разделов 2 Гб.

sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[cd]1
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[cd]1
mdadm: must be super-user to perform this action
vagrant@ubuntu-focal:~$ sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[cd]1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

7.	Соберите mdadm RAID0 на второй паре маленьких разделов.

sudo mdadm --create /dev/md1 --level=0 --raid-devices=2 /dev/sd[cd]2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
8.	Создайте 2 независимых PV на получившихся md-устройствах.
sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
sudo pvs
  PV         VG Fmt  Attr PSize    PFree
  /dev/md0      lvm2 ---    <2.00g   <2.00g
  /dev/md1      lvm2 ---  1018.00m 1018.00m
9.	Создайте общую volume-group на этих двух PV.

sudo vgcreate netology /dev/md0 /dev/md1
  Volume group "netology" successfully created
sudo vgs
  VG       #PV #LV #SN Attr   VSize  VFree
  netology   2   0   0 wz--n- <2.99g <2.99

10.	Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

sudo lvcreate -L 100m -n netology-lv netology /dev/md1
  Logical volume "netology-lv" created.
sudo lvs -o +devices
  LV          VG       Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
  netology-lv netology -wi-a----- 100.00m                                                     /dev/md1(0)

11.	Создайте mkfs.ext4 ФС на получившемся LV.

sudo mkfs.ext4 -L netology-ext4 -m 1 /dev/mapper/netology-netology--lv
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
sudo blkid | grep netology-netology--lv
/dev/mapper/netology-netology--lv: LABEL="netology-ext4" UUID="3eb07b18-966d-4452-9787-ca032cde8001" TYPE="ext4"

12.	Смонтируйте этот раздел в любую директорию, например, /tmp/new.

mkdir /tmp/new
sudo mount /dev/mapper/netology-netology--lv /tmp/new/
sudo mount | grep netology-netology--lv
/dev/mapper/netology-netology--lv on /tmp/new type ext4 (rw,relatime,stripe=256)

13.	Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2022-11-21 14:53:05--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 23456661 (22M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz              100%[=================================================>]  22.37M  2.18MB/s    in 9.7s

2022-11-21 14:53:15 (2.32 MB/s) - ‘/tmp/new/test.gz’ saved [23456661/23456661]

14.	Прикрепите вывод lsblk.

lsblk
NAME                        MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                         7:0    0 67.8M  1 loop  /snap/lxd/22753
loop1                         7:1    0   48M  1 loop  /snap/snapd/17029
loop2                         7:2    0 63.2M  1 loop  /snap/core20/1623
loop3                         7:3    0 49.7M  1 loop  /snap/snapd/17576
loop4                         7:4    0 63.2M  1 loop  /snap/core20/1695
sda                           8:0    0   40G  0 disk
└─sda1                        8:1    0   40G  0 part  /
sdb                           8:16   0   10M  0 disk
sdc                           8:32   0  2.5G  0 disk
├─sdc1                        8:33   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
└─sdc2                        8:34   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0
    └─netology-netology--lv 253:0    0  100M  0 lvm   /tmp/new
sdd                           8:48   0  2.5G  0 disk
├─sdd1                        8:49   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
└─sdd2                        8:50   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0
    └─netology-netology--lv 253:0    0  100M  0 lvm   /tmp/new

15.	Протестируйте целостность файла:

gzip -t /tmp/new/test.gz
echo $?
0

16.	Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

sudo pvmove -n netology-lv /dev/md1 /dev/md0
  /dev/md1: Moved: 28.00%
  /dev/md1: Moved: 100.00%
lsblk
NAME                        MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                         7:0    0 67.8M  1 loop  /snap/lxd/22753
loop1                         7:1    0   48M  1 loop  /snap/snapd/17029
loop2                         7:2    0 63.2M  1 loop  /snap/core20/1623
loop3                         7:3    0 49.7M  1 loop  /snap/snapd/17576
loop4                         7:4    0 63.2M  1 loop  /snap/core20/1695
sda                           8:0    0   40G  0 disk
└─sda1                        8:1    0   40G  0 part  /
sdb                           8:16   0   10M  0 disk
sdc                           8:32   0  2.5G  0 disk
├─sdc1                        8:33   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
│   └─netology-netology--lv 253:0    0  100M  0 lvm   /tmp/new
└─sdc2                        8:34   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0
sdd                           8:48   0  2.5G  0 disk
├─sdd1                        8:49   0    2G  0 part
│ └─md0                       9:0    0    2G  0 raid1
│   └─netology-netology--lv 253:0    0  100M  0 lvm   /tmp/new
└─sdd2                        8:50   0  511M  0 part
  └─md1                       9:1    0 1018M  0 raid0

17.	Сделайте --fail на устройство в вашем RAID1 md.

sudo mdadm --fail /dev/md0 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0

18.	Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

sudo dmesg | grep md0 | tail -n 2
[13279.885356] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.

19.	Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

gzip -t /tmp/new/test.gz
echo $?
0

20.	Погасите тестовый хост, vagrant destroy.

vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
