#!/bin/bash

server_root="/var/www"
wp_source="https://wordpress.org/latest.tar.gz"

green="\033[32m"
red="\033[31m"
default="\033[00m"

echo -e "$green [+] Installing dependencies $default"
sudo apt-get install apache2 php5 php5-gd php5-mysql libapache2-mod-php5 mysql-server

echo -e "$green [+] Downloading Wordpress$default"
wget $wp_source
echo -e "$green [+] Unpacking Wordpress$default"
tar xpvf latest.tar.gz
echo -e "$green [+] Copying files to $server_root"
sudo rsync -avP wordpress/ $server_root
echo -e "$green [+] Changing permissions$default"
sudo chown www-data:www-data $server_root/* -R
mv $server_root/index.html $server_root/index.html.orig

echo -e "$red [!] Configuring Database. Please follow the steps $default"
echo -e "$red [!] Enter MySQL shell and create a database for WordPress $default"
echo -e "$red [!] Once on Shell, create the Database $default"
echo ""
echo -e "$green [COMMANDS] $default "
echo -e " $ mysql -u root -p"
echo -e " MYSQL> CREATE DATABASE $green wpdatabase$default;"
echo -e " MYSQL> CREATE USER $green wpuser$default@localhost;"
echo -e " MYSQL> SET PASSWORD FOR $green wpuser$default@localhost= PASSWORD('$green password$default');"
echo -e " MYSQL> GRANT ALL PRIVILEGES on $green wpdatabase$default.* TO $green wpuser$default@localhost;"
echo -e " MYSQL> FLUSH PRIVILEGES;"
echo -e " MYSQL> exit"
echo -e "$green--------------------------------------------------------------------------------$default"
echo -e "When it's done just access your Domain and install wordpress through their assistant"
