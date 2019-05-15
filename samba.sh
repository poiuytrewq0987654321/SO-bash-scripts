#!/bin/bash

echo 'instalacja samby'
apt-get -y install samba

echo 'konfiguracja pliku smb.conf dla udzialu public'
echo '[public]' >> /etc/samba/smb.conf
echo 'path = /media/storage/' >> /etc/samba/smb.conf
echo 'public = yes' >> /etc/samba/smb.conf
echo 'writable = yes' >> /etc/samba/smb.conf
echo 'comment = smb share' >> /etc/samba/smb.conf
echo 'printable = no' >> /etc/samba/smb.conf
echo 'guest ok = yes' >> /etc/samba/smb.conf

echo 'tworzenie (jesli go nie ma) folderu storage i nadawanie mu uprawnien'
cd /media
znajdz=$(find /media/ -name 'storage' | wc -l)

if [[ $znajdz = 1 ]]; then
    chmod 777 /media/storage
    else
    mkdir /media/storage
    chmod 777 /media/storage
fi

echo 'restart samba service'
systemctl restart smbd.service

echo 'konfiguracja samby pod uwierzytelnienie'
echo 'dla usera: smbuser i hasle: smbuser123'
useradd -p $(openssl passwd -1 $smbuser123) $smbuser

echo 'konfiguracja pliku smb.conf dla udzialu restricted (logowanie poprzez usera)'
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

cd /media
znajdz2=$(find /media/ -name 'storage2' | wc -l)

if [[ $znajdz2 = 1 ]]; then
    chmod 777 /media/storage2
    else
    mkdir /media/storage2
    chown -R smbuser:smbuser /media/storage2
    chmod 700 /media/storage2
fi
