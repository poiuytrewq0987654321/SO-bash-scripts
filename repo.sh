#!/bin/bash
# dodanie repo do pliku sources.list

echo 'dodawanie wpisow repo do sources.list'
cd /etc/apt
rm sources.list
touch sources.list
echo 'deb http://deb.debian.org/debian/ stretch main contrib' >> sources.list
echo 'deb http://security.debian.org/ stretch/updates contrib main' >> sources.list
echo 'deb http://deb.debian.org/debian/ stretch-updates contrib main' >> sources.list

echo 'updateowanie repo'
apt-get update

echo 'upgradeowanie pakietow'
apt-get -y upgrade

echo 'instalacja sudo'
apt-get install sudo

echo 'nadawanie uprawnien sudo uzytkownikom'
cd /etc
echo 'student ALL=(ALL:ALL) ALL' >> sudoers