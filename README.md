# wp-installer
***Automates Wordpress installation on Debian/like systems***

###This script makes the following actions:

#####Install
***Debian***
* apache2
* php5
* php5-gd
* php5-mysql
* libapache2-mod-php5 
* mysql-server

***CentOS***
* httpd
* mariadb
* mariadb-server
* php
* php-gd

#####Download the lastest WordPress tar ball
https://wordpress.org/latest.tar.gz
#####Configure MySQL database for Wordpress
* Create Database
* Create User
* Set privileges
* Configure wp-config.php

#####Move files to server root
* Copy all source files to server root

###Usage
    $ git clone https://github.com/fnk0c/wp-installer.git
    $ cd wp-installer
    $ ./wp-installer.sh
    
###Versions
**0.2**
* STABLE
* Support Debian systems

**0.3**
*UNSTABLE
* Support Debian and CentOS
