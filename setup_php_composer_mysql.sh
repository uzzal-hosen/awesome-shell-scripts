#!/bin/bash

# Update package list
sudo apt update

# Install PHP 7.4 and required extensions
sudo apt install -y php7.4 php7.4-cli php7.4-common php7.4-mbstring php7.4-xml php7.4-zip

# Install Composer
EXPECTED_SIGNATURE=$(curl -sS https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [[ $EXPECTED_SIGNATURE != $ACTUAL_SIGNATURE ]]; then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Cleanup
rm composer-setup.php

# Install MySQL and set root password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt install -y mysql-server

# Display installed versions
php -v
composer --version
mysql --version
