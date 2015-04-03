#!/bin/bash

server_root="/var/www"
wp_source="https://wordpress.org/latest.tar.gz"
user="wpuser"
database="wpdatabase"

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

echo -e "$red [+] Configuring Database. Please choose a password for WordPress database $default"
echo "Type $user@localhost password"
read pass

Q1="CREATE DATABASE $database;"
Q2="CREATE USER $user@localhost;"
Q3="SET PASSWORD FOR $user@localhost= PASSWORD('$pass');"
Q4="GRANT ALL PRIVILEGES on $database.* TO $user@localhost;"
Q5="FLUSH PRIVILEGES;"
SQL=${Q1}${Q2}${Q3}${Q4}${Q5}

`mysql -u root -p -e "$SQL"`

echo -e "$green [+] Done!"
echo -e " Please access the WordPress install file through your$red browser$default"
