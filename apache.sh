#!/bin/bash

echo 'instalacja apache2'
apt-get -y install apache2

echo 'uruchomienie apache2'
systemctl start apache2

# znajdz=$(ifconfig | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
# echo 'aby sprawdzic czy apache2 dziala poprawnie, wejdz na innej maszynie wirtualnej na adres:'
# echo $znajdz
# echo
# echo 'kod strony glownej znajdziesz w katalogu /var/www/html/'