#!bin/bash


# 1) Установите из сетевого репозитория пакеты, входящие в группу «Developments Tools».
yum group install «Development Tools»

# 2) Установите из исходных кодов, приложенных к методическим указаниям пакет bastet-0.43. Для этого
# необходимо создать отдельный каталог и скопировать в него исходные коды проекта bastet. Вы
# можете использовать подключение сетевого каталога в хостовой операционной системе для передачи
# архива с исходными кодами в виртуальную машину. Далее следует распаковать архив до появления
# каталога с исходными файлами (в каталоге должен отображаться Makefile). После этого соберите
# пакет bastet и запустите его, чтобы удостовериться, что он правильно собрался. Затем модифицируйте
# Makefile, добавив в него раздел install. Обеспечьте при установке копирование исполняемого файла в

# /usr/bin с установкой соответствующих прав доступа. Выполните установку и проверьте, что любой
# пользователь может запустить установленный пакет.

mkdir lab4
cp -r Linux_labs/lab4/batset-0.43 lab4
cd bastet-0.43
yum install boost boost-thread boost-devel
yum install ncurses-devel
make

# install:
#	cp -p $(PROGNAME) /usr/bin/

make install 

# 3) Создайте файл task3.log, в который выведите список всех установленных пакетов.
rpm -qa | less > task3.log

# 4) Создайте файл task4_1.log, в который выведите список всех пакетов (зависимостей), необходимых
# для установки и работы компилятора gcc. Создайте файл task4_2.log, в который выведите список
# всех пакетов (зависимостей), установка которых требует установленного пакета libgcc.
yum deplist gcc > task4_1.log

rpm -q --whatrequires libgcc > task4_2.log

# 5) Создайте каталог localrepo в домашнем каталоге пользователя root и скопируйте в него пакет
# checkinstall-1.6.2-3.el6.1.x86_64.rpm , приложенный к методическим указаниям. Создайте
# собственный локальный репозиторий с именем localrepo из получившегося каталога с пакетом.
mkdir localrepo
cp /Linux_labs/lab4/checkinstall-1.6.2-3.el6.1.x86_64.rpm /localrepo
yum install createrepo yum-utils
createrepo ./
nano /etc/yum.repos.d/localrepo.repo

# [localrepo]
# name=localrepo
# mirrorlist=file://root/localrepo
# enabled=1
# gpgcheck=0

# 6) Создайте файл task6.log, в который выведите список всех доступных репозиториев.
yum repolist enabled > task6.log

# 7) Настройте систему на работу только с созданным локальным репозиторием (достаточно переименовать
# конфигурационные файлы других репозиториев). Выведите на экран список доступных для установки
# пакетов и убедитесь, что доступен только один пакет, находящийся в локальном репозитории. Установите
# этот пакет.
cd /etc
mkdir yum.repos.d.old
mv yum.repos.d/CentOS-* yum.repo.d.old/
yum list available
yum install checkinstall

# 8)Скопируйте в домашний каталог пакет fortunes-ru_1.52-2_all, приложенный к методическим
# рекомендациям, преобразуйте его в rpm пакет и установите.
cp Linux_labs/lab4/fortunes-ru_1.52-2_all.deb fortunes-ru_1.52-2_all.deb
yum install epel-release
yum install alien 
alien --to-rpm fortunes-ru_1.52-_all.deb
rpm fortunes-ru_1.52-3_all.noarch.rpm

# 9) Скачайте из сетевого репозитория пакет nano. Пересоберите пакет таким образом, чтобы после его
# установки менеджером пакетов, появлялась возможность запустить редактор nano из любого каталога,
# введя команду newnano.
dnf download nano

cd rpmbuild/SPECS
nano nano.spec 

sudo yum config-manager --set-enabled PowerTools
yum groupinstall "Development tools"

# добавляем строчку в %install:
# $install
# cd build
# ln -s "nano" "%{_bindir}/newnano" <- добавляем эту строчку

yum-builddep nano.spec
rpmbuild -bb nano.spec 
cd ../RPMS/x86_64
yum localinstall nano-2.3.1-10.e17.rpm 

