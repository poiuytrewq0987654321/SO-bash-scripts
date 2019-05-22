#!/bin/bash

echo 'instalacja samby'
apt-get -y install samba

rm /etc/samba/smb.conf
touch /etc/samba/smb.conf

echo 'dodawanie konfiguracji do pliku smb.conf'
echo '[global]' >> /etc/samba/smb.conf
echo 'workgroup = smb' >> /etc/samba/smb.conf
echo 'security = user' >> /etc/samba/smb.conf
echo 'map to guest = never' >> /etc/samba/smb.conf
echo '\n' >> /etc/samba/smb.conf

echo '[homes]' >> /etc/samba/smb.conf
echo 'comment = Home Directories' >> /etc/samba/smb.conf
echo 'browsable = no' >> /etc/samba/smb.conf
echo 'read only = no' >> /etc/samba/smb.conf
echo 'create mode = 0750' >> /etc/samba/smb.conf
echo '\n' >> /etc/samba/smb.conf

echo '[public]' >> /etc/samba/smb.conf
echo 'path = /media/storage/' >> /etc/samba/smb.conf
echo 'public = yes' >> /etc/samba/smb.conf
echo 'writable = yes' >> /etc/samba/smb.conf
echo 'comment = smb share' >> /etc/samba/smb.conf
echo 'printable = no' >> /etc/samba/smb.conf
echo 'guest ok = yes' >> /etc/samba/smb.conf
echo '\n' >> /etc/samba/smb.conf

echo '[restricted]' >> /etc/samba/smb.conf
echo 'valid users = smbuser' >> /etc/samba/smb.conf
echo 'path = /media/storage2/' >> /etc/samba/smb.conf
echo 'public = no' >> /etc/samba/smb.conf
echo 'writable = yes' >> /etc/samba/smb.conf
echo 'comment = smb restricted share' >> /etc/samba/smb.conf
echo 'printable = no' >> /etc/samba/smb.conf
echo 'guest ok = no' >> /etc/samba/smb.conf
echo 'create mask = 0600' >> /etc/samba/smb.conf
echo 'directory mask = 0700' >> /etc/samba/smb.conf

mkdir /media/storage
chmod 777 /media/storage

echo 'konfiguracja samby pod uwierzytelnienie'
echo 'dla usera: sambo i hasle: sambo123'
useradd -p sambo123 -s /bin/false sambo

awk -F: '{ print $1}' /etc/passwd

mkdir /media/storage2
chown -R sambo:smbuser /media/storage2
chmod 700 /media/storage2

echo 'restart samba service'
systemctl restart smbd.service