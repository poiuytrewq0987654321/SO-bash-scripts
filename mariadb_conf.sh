#!/bin/bash

# curl -O https://raw.githubusercontent.com/poiuytrewq0987654321/SO-bash-scripts/master/mariadb_conf.sh


sudo mysql_secure_installation

#enter, n enter, y enter, y enter, y enter, y enter, 
#printf '\nn\ny\ny\ny\ny\n'

printf "sudo mysql -u root -p\n\n"
printf "CREATE DATABASE wpdb;\n"
printf "GRANT ALL ON wpdb.* TO 'wpuser' IDENTIFIED BY 'wppasword';\n"
printf "FLUSH PRIVILEGES;\n"
printf "quit\n"