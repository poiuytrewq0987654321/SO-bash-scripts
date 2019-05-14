# dodanie repo do pliku sources.list

echo 'dodawanie wpisow repo do sources.list'
cd /etc/apt/sources.list
sed -r sources.list
'deb http://deb.debian.org/debian/ stretch main contrib' >> sources.list
'deb http://security.debian.org/ stretch/updates contrib main' >> sources.list
'deb http://deb.debian.org/debian/ stretch-updates contrib main' >> sources.list

echo 'updateowanie repo'
apt-get update

echo 'upgradeowanie pakietow'
apt-get upgrade

echo 'instalacja sudo'
apt-get install sudo

echo 'nadawanie uprawnien sudo uzytkownikom'
cd /etc
'student ALL=(ALL:ALL) ALL' >> sudoers