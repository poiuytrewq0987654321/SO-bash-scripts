#!/bin/bash

# curl -O https://raw.githubusercontent.com/poiuytrewq0987654321/SO-bash-scripts/master/mariadb_conf.sh

sudo apt-get install expect -y

#sudo mysql_secure_installation
#Not required in actual script
MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

#enter, n enter, y enter, y enter, y enter, y enter,
#printf '\nn\ny\ny\ny\ny\n'

printf "sudo mysql -u root -p\n\n"
printf "CREATE DATABASE wpdb;\n"
printf "GRANT ALL ON wpdb.* TO 'wpuser' IDENTIFIED BY 'wppasword';\n"
printf "FLUSH PRIVILEGES;\n"
printf "quit\n"