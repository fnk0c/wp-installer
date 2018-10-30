# wp-installer
***Automates Wordpress installation on Linux systems***

### Tested on:
* Debian 7
* Debian 8
* Ubuntu 14.04 LTS
* CentOS 7
* Fedora 21
* Manjaro 0.8.12 (Unstable)

### This script makes the following actions:

#### 1. Install
***Debian***
* apache2
* php5
* php5-gd
* php5-mysql
* libapache2-mod-php5 
* mysql-server
* libmysqlclient-dev

***CentOS***
* httpd
* mariadb
* mariadb-server
* php
* php-gd
* php-mysql
* php-xml

***Arch*** (Unstable)
* apache
* mariadb
* mariadb-server
* php
* php-gd
* php-apache

#### 2. Download the lastest WordPress tarball
https://wordpress.org/latest.tar.gz
#### Configure MySQL database for WordPress
* Create Database
* Create User
* Set WordPress table prefix
* Set privileges
* Modify php.ini and httpd.conf on Arch systems

#### 3. Move files to server root
* Copy all source files to server root

#### 4. wp-config.php
* Configure wp-config.php

### Usage
```
$ git clone https://github.com/fnk0c/wp-installer.git
$ cd wp-installer
$ ./wp-installer.sh
```
