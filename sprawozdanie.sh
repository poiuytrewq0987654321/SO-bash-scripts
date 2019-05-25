#!/bin/bash

echo -e "\e[42mpodaj numer serwera(zgodnie z zadaniem np 1 lub 2):\e[0m"
read serwernumber
echo -e "\e[42mpodaj numer indeksu:\e[0m"
read indeks
echo -e "\e[42mpodaj nazwe uzytkownika dla tej wirtualnej maszyny (np. student / studentka):\e[0m"
read uzytkownik

echo "\n"
echo wybrales numer serwera: $serwernumber
echo wybrales numer indeksu: $indeks
echo "\n"

rm /etc/hostname
touch /etc/hostname
echo "\e[42mzmieniam nazwe hostname na: serwer$serwernumber-$indeks \e[0m"
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
echo -e "\e[32mpamietaj, tutaj ustawiasz standardowe haslo uzytkownika\e[0m"
passwd -i 40 $uzytkownik-$indeks

echo -e "\n"
echo -e "\e[42mpodaj z co najmniej ilu znakow ma sie skladac haslo: \e[0m"
read passminlength

sed -i 's/sha512/& minlen=$passminlength/' /etc/pam.d/common-password

echo -e "\e[42mwykonac szukanie frazy 'dev' we wszystkich nazwach plikow? (napisz duza litera: T dla TAK i N dla NIE\e[0m"
read odpfinddev

if [ $odpfinddev == "T" ] ; then
mkdir /home/$uzytkownik-$indeks/Nowy
echo "\e[32mprzeczesuje wszystkie pliki...\e[0m"
find / -type f -name "*dev*" > /home/$uzytkownik-$indeks/wyniki
else
echo -e "wybrales \e[32mNIE\e[0m tworzyc pliku 'Nowy' i zapisania w nim wyszukiwania 'dev'"
fi


echo -e "\e[42mtworze grupe linux$indeks i dodaje do niej uzytkownika: $uzytkownik-$indeks\e[0m"
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
echo -e "\e[42mkonfiguruje plik index.html zgodnie z wymaganiami\e[0m"
rm /var/www/html/index.html
touch /var/www/html/index.html
echo "<html>" >> /var/www/html/index.html
echo "<body>" >> /var/www/html/index.html
echo "<div>Prace planowe na serwerze Serwer$serwernumber-$indeks beda realizowane od godz. 9.00 do 12.00</div>" >> /var/www/html/index.html
echo "</body>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html
else
echo -e "wybrales \e[32mNIE\e[0m instalowac samby"
fi

echo -e "\e[32m!PODSUMOWANIE!\e[0m"
echo -e "\n"
echo -e "aby sprawdzic jaki jest hostname, wpisz w konsoli: hostname"
echo -e "\n"
echo -e "aby sprawdzic w jakich grupach jest dany user, wpisz: groups nazwa_uzytkownika"
echo -e "\n"
echo -e "aby sprawdzic ile znakow jest wymaganych w hasle wedlug konfiguracji, przejdz do pliku: /etc/pam.d/common-password i odnajdz linie w ktorej jest pod koniec tekst 'sha-512' zaraz po nim znajdziesz konfiguracje hasla (minlen=X)"
echo -e ""
echo -e "\e[42m\e[0m"