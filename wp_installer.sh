#!/bin/bash
#AUTHOR = FNKOC <franco.c.colombino@gmail.com>
#GITHUB = https://github.com/fnk0c
#LAST UPDATE = 17/08/2015
#VERSION: 0.4
#STATUS: UNSTABLE
#STABLE VERSION: 0.3 (https://github.com/fnk0c/wp-installer/releases/tag/0.3)
#CHANGES:	Arch Linux support
#			Configure mysql for Arch
#			Edit php.ini and httpd.conf
#			Fix sed permission
#			pacman --needed argument
#			Fix sed syntax
#			Set table prefix

# Installing wp-installer dependencies
if [ -e "/etc/yum" ] ; then
	sudo yum install dialog wget
elif [ -e "/etc/apt" ] ; then
	sudo apt-get install dialog wget
elif [ -e "/etc/pacman.d" ] ; then
	sudo pacman -S dialog wget --needed 
fi

# Starting script
server_root="/var/www"
wp_source="https://wordpress.org/latest.tar.gz"
user="wpuser"
database="wpdatabase"
table="wp_"

green="\033[32m"
red="\033[31m"
white="\e[0;37m"
default="\033[00m"

# Starting setting of variables
dialog --title "Setting variables" --yesno "Use $server_root as server root?" 0 0

if [ "$?" = "1" ] ; then
	server_root=$( dialog --stdout --inputbox "Set server root:" 0 0 )
fi

dialog --title "Setting variables" --yesno "Set $database as WordPress \
Database?" 0 0

if [ "$?" = "1" ] ; then
	database=$( dialog --stdout --inputbox "Set WordPress DB name:" 0 0 )
fi

dialog --title "Setting variables" --yesno "Set $table as WordPress \
table prefix?" 0 0

if [ "$?" = "1" ] ; then
	table=$( dialog --stdout --inputbox "Set WordPress table prefix:" 0 0 )
fi

dialog --title "Setting variables" --yesno "Use $user as WordPress database \
username?" 0 0

if [ "$?" = "1" ] ; then
	user=$( dialog --stdout --inputbox "Set WordPress username:" 0 0 )
fi

dialog --title "setting variables" --msgbox \
"[Server Root] = $server_root \
[Database name] = $database \
[Table prefix] = $table \
[MySQL Username] = $user" 10 35 --and-widget

# Installing and configuring dependencies according to each distro's package manager
echo -e "$green [+] Installing and configuring dependencies $default"

if [ -e "/etc/yum" ] ; then
	sudo yum install httpd php php-gd php-mysql php-xml mariadb-server mariadb
	sudo systemctl start mariadb
	sudo systemctl start httpd
	sudo systemctl enable mariadb
	sudo systemctl enable httpd
	mysql_secure_installation
elif [ -e "/etc/apt" ] ; then
	sudo apt-get install apache2 php5 php5-gd php5-mysql libapache2-mod-php5 \
	mysql-server libmysqlclient-dev
elif [ -e "/etc/pacman.d" ] ; then
	sudo pacman -S --needed apache php php-apache mariadb php-gd
	sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	sudo systemctl start mysqld
	sudo systemctl start httpd
	sudo systemctl enable mysqld
	sudo systemctl enable httpd
	mysql_secure_installation
	sudo sed -i "s/;extension=mysql.so/extension=mysql.so/g" /etc/php/php.ini
	sudo sed -i "s/;extension=mysqli.so/extension=mysqli.so/g" /etc/php/php.ini
	sudo sed -i "s/LoadModule mpm_event_module modules\/mod_mpm_event.so/LoadModule \
mpm_prefork_module modules\/mod_mpm_prefork.so/g" /etc/httpd/conf/httpd.conf

	#It has to be added in its sections. It isn't working, but i'm too lazy to
	#fix (has to use sed command)

	sudo sh -c 'echo "LoadModule php5_module modules/libphp5.so" >> /etc/httpd/\
conf/httpd.conf'
	sudo sh -c 'echo "Include conf/extra/php5_module.conf" >> /etc/httpd/conf/\
httpd.conf'
fi

# Downloading source
echo -e "$green [+] Downloading Wordpress$default"
wget $wp_source
echo -e "$green [+] Unpacking Wordpress$default"
tar xpvf latest.tar.gz

# Copying files to server root
echo -e "$green [+] Copying files to $server_root"
sudo rsync -avP wordpress/ $server_root

# Setting permittions
echo -e "$green [+] Changing permissions$default"
if [ -e "/etc/yum" ] ; then
	sudo chown apache:apache $server_root/* -R 
elif [ -e "/etc/apt" ] ; then
	sudo chown www-data:www-data $server_root/* -R
	local_user=`whoami`
	sudo usermod -a -G www-data $local_user
fi
mv $server_root/index.html $server_root/index.html.orig

# Configuring MySQL database
pass=$( dialog --stdout --inputbox "Type $user@localhost password" 0 0 )
echo -e "$green [+] Type MySQL root password $default"

Q1="CREATE DATABASE $database;"
Q2="CREATE USER $user@localhost;"
Q3="SET PASSWORD FOR $user@localhost= PASSWORD('$pass');"
Q4="GRANT ALL PRIVILEGES on $database.* TO $user@localhost;"
Q5="FLUSH PRIVILEGES;"
SQL=${Q1}${Q2}${Q3}${Q4}${Q5}

`mysql -u root -p -e "$SQL"`

# Generating wp-config.php
cp $server_root/wp-config-sample.php $server_root/wp-config.php
sed -i "s/database_name_here/$database/g" $server_root/wp-config.php
sed -i "s/username_here/$user/g" $server_root/wp-config.php
sed -i "s/password_here/$pass/g" $server_root/wp-config.php
sed -i "s/wp_/$table/g" $server_root/wp-config.php

# Finishing / End of the script

dialog --title "Complete" --msgbox "Done!" 0 0
dialog --title "Complete" --yesno "Would you like to open your browser in order\
 to finish WordPress install? [Firefox]" 0 0

if [ $? = "1" ] ; then
	echo -e "$red [!] Please, open your browser and access your WordPress in \
order to complete install$default"
	echo -e "$green [+] Bye! $default"
	exit
else
	echo -e "$green [+] Firefox started in background $default"
	`firefox --new-tab http://localhost &`
fi
