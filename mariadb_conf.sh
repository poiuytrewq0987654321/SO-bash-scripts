sudo mysql_secure_installation

#enter, n enter, y enter, y enter, y enter, y enter, 
#printf '\nn\ny\ny\ny\ny\n'

printf "sudo mysql -u root -p\n"
printf "CREATE DATABASE wpdb;\n"
printf "GRANT ALL ON wpdb.* TO 'wpuser' IDENTIFIED BY 'wppasword';\n"
printf "FLUSH PRIVILEGES;\n"
printf "quit\n"