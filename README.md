# wp-installer
***Automates Wordpress installation on Linux systems***

###Tested on:
* Debian 7
* Debian 8
* Ubuntu 14.04 LTS
* CentOS 7
* Fedora 21
* Manjaro 0.8.12 (Unstable)

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
* php-mysql

***Arch*** (Unstable)
* apache
* mariadb
* mariadb-server
* php
* php-gd
* php-apache

#####Download the lastest WordPress tar ball
https://wordpress.org/latest.tar.gz
#####Configure MySQL database for WordPress
* Create Database
* Create User
* Set privileges
* Modify php.ini and httpd.conf on Arch systems

#####Move files to server root
* Copy all source files to server root

#####wp-config.php
* Configure wp-config.php

###Usage
    $ git clone https://github.com/fnk0c/wp-installer.git
    $ cd wp-installer
    $ ./wp-installer.sh
