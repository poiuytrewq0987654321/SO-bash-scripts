#!/bin/bash

echo -e "\e[42mpodaj nazwe serwera(np serwer1 czy serwer2):\e[0m"
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
echo -e "\e[42mzmieniam nazwe hostname na: $serwernumber-$indeks \e[0m"
echo "$serwernumber-$indeks" >> /etc/hostname
echo "\n"
echo -e "\e[42mustawienie strefy czasowej:\e[0m"
timedatectl set-timezone Europe/Warsaw

echo -e "\e[42msprawdzenie daty:\e[0m"
date
echo -e "\n"
echo -e "\e[42mutworzenie folderu backup i skopiowanie wybranych plikow\e[0m"
mkdir /root/backup
cp /etc/passwd /root/backup
cp /etc/shadow /root/backup
cp /etc/group /root/backup

echo -e "\e[42mdodanie usera $uzytkownik-$indeks\e[0m"
useradd -m $uzytkownik-$indeks

echo -e "\e[42mnadanie haslu waznosci na 40 dni\e[0m"
passwd -i 40 $uzytkownik-$indeks
echo -e "\n"
echo -e "\e[32mpamietaj, tutaj ustawiasz standardowe haslo uzytkownika\e[0m"
passwd $uzytkownik-$indeks

echo -e "\n"
echo -e "\e[42mpodaj z co najmniej ilu znakow ma sie skladac haslo: \e[0m"
read passminlength

sed -i "s/sha512/& minlen=$passminlength/" /etc/pam.d/common-password

echo -e "\e[42mwykonac szukanie frazy 'dev' we wszystkich nazwach plikow? (napisz duza litera: T dla TAK i N dla NIE\e[0m"
read odpfinddev

if [ $odpfinddev == "T" ] ; then
mkdir /home/$uzytkownik-$indeks/Nowy
echo -e "\e[32mprzeczesuje wszystkie pliki...\e[0m"
find / -type f -name "*dev*" > /home/$uzytkownik-$indeks/Nowy/wyniki
else
echo -e "wybrales \e[32mNIE\e[0m tworzyc pliku 'Nowy' i zapisania w nim wyszukiwania 'dev'"
fi
echo "\n"

echo -e "\e[42mtworze grupe linux$indeks i dodaje do niej uzytkownika: $uzytkownik-$indeks\e[0m"
groupadd linux$indeks
usermod -a -G linux$indeks $uzytkownik-$indeks

# 
# instalacja samby start
# 
echo "\n"
echo -e "\e[42mczy mam zainstalowac system wymiany plikow (SAMBA)? wpisz T lub N\e[0m"
read odpsamba
if [ "$odpsamba" == "T" ] ; then
    echo -e "\e[42minstaluje sambe\e[0m"
    apt-get -y install samba

    rm /etc/samba/smb.conf
    touch /etc/samba/smb.conf

    echo 'dodawanie konfiguracji do pliku smb.conf'
    echo '[global]' >> /etc/samba/smb.conf
    echo 'workgroup = smb' >> /etc/samba/smb.conf
    echo 'security = user' >> /etc/samba/smb.conf
    echo 'map to guest = never' >> /etc/samba/smb.conf

    echo '[homes]' >> /etc/samba/smb.conf
    echo 'comment = Home Directories' >> /etc/samba/smb.conf
    echo 'browsable = no' >> /etc/samba/smb.conf
    echo 'read only = no' >> /etc/samba/smb.conf
    echo 'create mode = 0750' >> /etc/samba/smb.conf

    echo '[public]' >> /etc/samba/smb.conf
    echo 'path = /media/storage/' >> /etc/samba/smb.conf
    echo 'public = yes' >> /etc/samba/smb.conf
    echo 'writable = yes' >> /etc/samba/smb.conf
    echo 'comment = smb share' >> /etc/samba/smb.conf
    echo 'printable = no' >> /etc/samba/smb.conf
    echo 'guest ok = yes' >> /etc/samba/smb.conf

    echo '[restricted]' >> /etc/samba/smb.conf
    echo "valid users = $uzytkownik-$indeks" >> /etc/samba/smb.conf
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

    echo "konfiguracja samby pod uwierzytelnienie"

    echo -e "\e[42muustaw haslo dla $uzytkownik-$indeks ktorego bedziesz uzywac autoryzujac sie na windows w trakcie laczenia sie z udostepnionym zasobem sieciowym:\e[0m"
    smbpasswd -a $uzytkownik-$indeks

    echo "\n"
    echo "tworze folder dla samby: /media/storage2"
    mkdir /media/storage2
    chown -R $uzytkownik-$indeks:$uzytkownik-$indeks /media/storage2
    chmod 700 /media/storage2

    echo "restart samba service"
    systemctl restart smbd.service

else
    echo -e "wybrales \e[32mNIE\e[0m instalowac samby"
fi
# 
# instalacja samby end
# 

# 
# instalacja apache start
# 

echo -e "\e[42mczy mam zainstalowac serwer WWW (APACHE2)? wpisz T lub N\e[0m"
read odpapache
if [ "$odpapache" == "T" ] ; then
    echo -e "\e[42minstaluje apache\e[0m"
    apt-get -y install apache2
    echo "uruchomienie apache2"
    systemctl start apache2
    echo -e "\e[42mkonfiguruje plik index.html zgodnie z wymaganiami\e[0m"
    rm /var/www/html/index.html
    touch /var/www/html/index.html
    echo "<html>" >> /var/www/html/index.html
    echo "<body>" >> /var/www/html/index.html
    echo "<div>Prace planowe na serwerze $serwernumber-$indeks beda realizowane od godz. 9.00 do 12.00</div>" >> /var/www/html/index.html
    echo "</body>" >> /var/www/html/index.html
    echo "</html>" >> /var/www/html/index.html
else
    echo -e "wybrales \e[32mNIE\e[0m instalowac samby"
fi
# 
# instalacja apache end
# 

echo -e "\n"
echo -e "\e[32m!PODSUMOWANIE!\e[0m"
echo -e "\n"
echo -e "aby sprawdzic jaki jest hostname, wpisz w konsoli: hostname (wymagany restart maszyny)"
echo -e "\n"
echo -e "aby sprawdzic w jakich grupach jest dany user, wpisz: groups nazwa_uzytkownika"
echo -e "\n"
echo -e "aby sprawdzic ile znakow jest wymaganych w hasle wedlug konfiguracji, przejdz do pliku: /etc/pam.d/common-password i odnajdz linie w ktorej jest pod koniec tekst 'sha-512' zaraz po nim znajdziesz konfiguracje hasla (minlen=X)"
echo -e "\n"
echo -e "\e[42maby sprawdzic czy dziala apache, wejdz na adres IP komputera na ktorym zainstalowales apache\e[0m"