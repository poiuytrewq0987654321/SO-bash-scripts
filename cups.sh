#!/bin/bash

echo 'instalacja serwera wydruku cups i reszty wymaganych pakietow'
apt-get -y install cups
apt-get -y install libsmbclient
apt-get -y install smbclient
apt-get -y install python-smbc

echo 'dodanie uzytkownika "student" do grupy lpadmin'
usermod -aG lpadmin student
echo 'sprawdzenie czy uzytkownik student zostal dodany do grupy lpadmin'
grep 'lpadmin' /etc/group

echo 'skonfigurowanie zdalnego zarzadzania CUPS'
cupsctl --remote-admin

echo 'restart uslugi cups'
systemctl restart cups

echo ' wejdz na https://localhost:631 :-)'

echo 'konfiguracja drukarek serwera CUPS przez serwer samba (wymagana samba)'
sed -i '/[global]/a rpc_server:spoolss = external' /etc/samba/smb.conf
sed -i '/[global]/a rpc_daemon:spoolssd = fork' /etc/samba/smb.conf

echo '[printers]' >> /etc/samba/smb.conf
echo 'path = /var/spool/samba' >> /etc/samba/smb.conf
echo 'printable = yes' >> /etc/samba/smb.conf
echo 'printing = CUPS' >> /etc/samba/smb.conf

!!!!'do sprawdzenia czy plik smb.conf nie ma juz sekcji [print$]'
echo '[print$]' >> /etc/samba/smb.conf
echo 'path = /srv/samba/Printer_drivers' >> /etc/samba/smb.conf
echo 'comment = Printer Drivers' >> /etc/samba/smb.conf
echo 'write list = student' >> /etc/samba/smb.conf

mkdir -p /var/spool/samba/
chmod 1777 /var/spool/samba/

systemctl restart samba