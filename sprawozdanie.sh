#!/bin/bash

rm /etc/hostname
touch /etc/hostname

echo -e "\e[42mpodaj numer serwera:"
read serwernumber
echo -e "\e[42mpodaj numer indeksu:"
read indeks
echo -e "\e[42mpodaj nazwe uzytkownika dla tego serwera:"
read uzytkownik


echo wybrales numer serwera: $serwernumber
echo wybrales numer indeksu: $indeks

echo -e "\e[42mserwer$serwernumber-$indeks >> /etc/hostname"

echo -e "\e[42mustawienie strefy czasowej:"
timedatectl set-timezone Europe/Warsaw

echo -e "\e[42msprawdzenie daty:"
date

echo -e "\e[42mutworzenie folderu backup i skopiowanie wybranych plikow"
mkdir /root/backup
sudo cp /etc/passwd /root/backup
sudo cp /etc/shadow /root/backup
sudo cp /etc/group /root/backup

echo -e "\e[42mdodanie usera $uzytkownik-$indeks"
adduser $uzytkownik-$indeks

echo -e "\e[42mzmiana hasla i nadanie mu expired na 40 dni"
passwd -i 40 $uzytkownik-$indeks

echo -e "\e[42mpodaj ile znakow minimum ma miec haslo"
read passminlength

sed -i '/password\t[success=1 default=ignore]\tpam_unix.so obscure sha512/ s/$/ minlen=$passminlength/' /etc/pam.d/common-password

echo -e "\e[42mwykonac szukanie 'dev' w nazwach plikow? (napisz duza litera: T dla TAK i N dla NIE"
read odpowiedz

if [ $odpowiedz eq 'T' ] ; then
mkdir /home/$uzytkownik-$indeks/Nowy
find / -type f -name "*dev*" > /home/$uzytkownik-$indeks/wyniki
else
echo "wybrales \e[32mNIE\e[0m tworzyc pliku 'Nowy' i zapisania w nim wyszukiwania 'dev'"
fi

echo -e "\e[42mTEXT"

echo -e "\e[42mTEXT"

echo -e "\e[42mTEXT"

echo -e "\e[42mTEXT"

echo -e "\e[42mTEXT"