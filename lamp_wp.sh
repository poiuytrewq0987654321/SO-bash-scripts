#!/bin/bash

# curl -O https://raw.githubusercontent.com/poiuytrewq0987654321/SO-bash-scripts/master/lamp_wp.sh

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install expect -y

echo "instalacja LAMP"

echo "instalacja apache2"
sudo apt-get install apache2 -y

echo "instalacja mariadb-server"
sudo apt-get install mariadb-server -y

echo "konfiguracja mysql/mariadb"







echo "instalacja komponentów PHP"
sudo apt-get install php libapache2-mod-php -y
sudo apt-get install php-gd php-mysql -y
sudo apt-get install php-curl php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y

sudo systemctl restart apache2.service

#wordpress install

cd  /var/www/
sudo curl -O https://wordpress.org/latest.tar.gz
sudo tar -xvf latest.tar.gz
sudo rm latest.tar.gz

sudo find /var/www/wordpress/ -type d -exec chmod 755 {} \;
sudo find /var/www/wordpress/ -type f -exec chmod 755 {} \;

sudo mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

#zmieniamy definicje bazy / usera / hasła zgodnie z tymi ustawionymi wczesniej
#sudo nano wp-config.php

sudo sed -i 's/database_name_here/wpdb/' /var/www/wordpress/wp-config.php
sudo sed -i 's/username_here/wpuser/' /var/www/wordpress/wp-config.php
sudo sed -i 's/password_here/wppasword/' /var/www/wordpress/wp-config.php

sudo sed -i "/^define( 'AUTH_KEY'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'SECURE_AUTH_KEY'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'LOGGED_AUTH_KEY'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'NONCE_KEY'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'AUTH_SALT'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'SECURE_AUTH_SALT'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'LOGGED_IN_SALT'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'NONCE_SALT'/d" /var/www/wordpress/wp-config.php
sudo sed -i "/^define( 'LOGGED_IN_KEY'/d" /var/www/wordpress/wp-config.php

wp_salts=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
echo $wp_salts >> /var/www/wordpress/wp-config.php


sudo sed -i 's!DocumentRoot /var/www/html!DocumentRoot /var/www/wordpress!g' /etc/apache2/sites-available/000-default.conf

echo "<Directory /var/www/wordpress/>" >> /etc/apache2/sites-available/000-default.conf
echo "AllowOverride All" >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf

sudo a2enmod rewrite
sudo apache2ctl configtest
sudo systemctl restart apache2

