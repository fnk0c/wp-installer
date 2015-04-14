#!/bin/bash
#AUTHOR = FNKOC <franco.c.colombino@gmail.com>
#GITHUB = https://github.com/fnk0c
server_root="/var/www"
wp_source="https://wordpress.org/latest.tar.gz"
user="wpuser"
database="wpdatabase"

green="\033[32m"
red="\033[31m"
white="\e[0;37m"
default="\033[00m"

#START SETTING VARIABLES #######################################################

echo -e "$green [+] Setting variables $default"
echo -e "$red >> Use$white $server_root$red as server root? [y/n]$default"
read choice
if [ "$choice" = "n" ]
then
	echo " >> Write server root directory"
	read server_root
	echo -e "$green [+] Using$white $server_root $default"
else
	echo -e "$green [+] Using$white $server_root $default"
fi

echo -e "$red >> Set$white $database$red WordPress Database? [y/n]$default"
read choice
if [ "$choice" = "n" ]
then
	echo "Choose a Database name"
	read database
	echo -e "$green [+] Using$white $database $default"
else
	echo -e "$green [+] Using$white $database $default"
fi

echo -e "$red >> Use$white $user$red as WordPress database username? [y/n]$default"
read choice
if [ "$choice" = "n" ]
then
	echo "Choose a username"
	read user
	echo -e "$green [+] Using$white $user $default"
else
	echo -e "$green [+] Using$white $user $default"
fi

#END SETTING VARIABLES #########################################################

#INSTALLING DEPENDENCIES #######################################################

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
local_user=`whoami`
sudo usermod -a -G www-data $local_user
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
echo -e "Would you like to open your browser in order to install WordPress? [Firefox]"
read choice

if [ $choice = "n" ]
then
	echo -e "$red [!] Please, open your browser and access your WordPress in order to complete install$default"
	echo -e "$green [+] Bye! $default"
	exit
else
	`firefox --new-tab http://localhost`
fi
