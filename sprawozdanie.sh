#!/bin/bash

echo -e "\e[42mpodaj numer serwera(np 1 lub 2):\e[0m"
read serwernumber
echo -e "\e[42mpodaj numer indeksu:\e[0m"
read indeks
echo -e "\e[42mpodaj nazwe uzytkownika dla tego serwera (np. student / studentka):\e[0m"
read uzytkownik

echo wybrales numer serwera: $serwernumber
echo wybrales numer indeksu: $indeks

rm /etc/hostname
touch /etc/hostname
echo 'serwer$serwernumber-$indeks' >> /etc/hostname

echo -e "\e[42mustawienie strefy czasowej:\e[0m"
timedatectl set-timezone Europe/Warsaw

echo -e "\e[42msprawdzenie daty:\e[0m"
date

echo -e "\e[42mutworzenie folderu backup i skopiowanie wybranych plikow\e[0m"
mkdir /root/backup
cp /etc/passwd /root/backup
cp /etc/shadow /root/backup
cp /etc/group /root/backup

echo -e "\e[42mdodanie usera $uzytkownik-$indeks\e[0m"
adduser $uzytkownik-$indeks

echo -e "\e[42mzmiana hasla i nadanie mu expired na 40 dni\e[0m"
passwd -i 40 $uzytkownik-$indeks

echo -e "\e[42mpodaj ile znakow minimum ma miec haslo\e[0m"
read passminlength

sed -i 's/sha512/& minlen=$passminlength/' /etc/pam.d/common-password

echo -e "\e[42mwykonac szukanie 'dev' w nazwach plikow? (napisz duza litera: T dla TAK i N dla NIE\e[0m"
read odpfinddev

if [ $odpfinddev == "T" ] ; then
mkdir /home/$uzytkownik-$indeks/Nowy
find / -type f -name "*dev*" > /home/$uzytkownik-$indeks/wyniki
else
echo -e "wybrales \e[32mNIE\e[0m tworzyc pliku 'Nowy' i zapisania w nim wyszukiwania 'dev'"
fi


echo -e "\e[42mTEXT\e[0m"
groupadd linux$indeks
usermod -a -G linux$indeks $uzytkownik-$indeks


echo -e "\e[42mczy mam zainstalowac system wymiany plikow (SAMBA)? wpisz T lub N\e[0m"
read odpsamba
if [ "$odpsamba" == "T" ] ; then
echo -e "\e[42minstaluje sambe\e[0m"
bash samba.sh
else
echo -e "wybrales \e[32mNIE\e[0m instalowac samby"
fi

echo -e "\e[42mczy mam zainstalowac serwer WWW (APACHE2)? wpisz T lub N\e[0m"
read odpapache
if [ "$odpapache" == "T" ] ; then
echo -e "\e[42minstaluje apache\e[0m"
bash apache.sh
echo -e "\e[42mkonfiguruje plik index.html\e[0m"
rm /var/www/html/index.html
touch /var/www/html/index.html
echo "<html>" >> /var/www/html/index.html
echo "<body>" >> /var/www/html/index.html
echo "<div>Prace planowe na serwerze Serwer2-$indeks beda realizowane od godz. 9.00 do 12.00</div>" >> /var/www/html/index.html
echo "</body>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html
else
echo -e "wybrales \e[32mNIE\e[0m instalowac samby"
fi



echo -e "\e[42mTEXT\e[0m"

echo -e "\e[42mTEXT\e[0m"

echo -e "\e[42mTEXT\e[0m"