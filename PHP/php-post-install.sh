#!/bin/sh


# if no dir ~/.php, create it
if [ ! -d ~/.php ]; then
    mkdir ~/.php
fi

# create array of directories

# php -> php, phpize, php-config
# php-fpm
# php-cgi
cli="/usr/bin/php"
cli_legacy="/usr/bin/php-legacy"


# HANDLE NON LEGACY PHP
if [ -f "$cli" ]; then
    cgi="/usr/bin/php-cgi"
    fpm="/usr/bin/php-fpm"
    config="/usr/bin/php-config"
    phpize="/usr/bin/phpize"

    # get php version
    php_version=$("$cli" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
    php_version=$(echo "$php_version" | sed 's/\.//g')

    # check if ~/.php/$php_version exists
    if [ ! -d ~/.php/"$php_version" ]; then
        mkdir ~/.php/"$php_version"
    fi

    php_folder=~/.php/"$php_version"

    # move php, phpize, php-config to ~/.php/$php_version
    sudo mv -f "$cli" "$php_folder"
    sudo mv -f "$config" "$php_folder"
    sudo mv -f "$phpize" "$php_folder"

    # php-fpm
    if [ -f "$fpm" ]; then
        sudo mv -f "$fpm" "$php_folder"
    fi

    # php-cgi
    if [ -f "$cgi" ]; then
        sudo mv -f "$cgi" "$php_folder"
    fi
fi


# HANDLE LEGACY PHP
if [ -f "$cli_legacy" ]; then
    cgi_legacy="/usr/bin/php-cgi-legacy"
    fpm_legacy="/usr/bin/php-fpm-legacy"
    config_legacy="/usr/bin/php-config-legacy"
    phpize_legacy="/usr/bin/phpize-legacy"

    # get php version
    php_version=$("$cli_legacy" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
    php_version=$(echo "$php_version" | sed 's/\.//g')

    # check if ~/.php/$php_version exists
    if [ ! -d ~/.php/"$php_version" ]; then
        mkdir ~/.php/"$php_version"
    fi

    php_folder=~/.php/"$php_version"

    # move php, phpize, php-config to ~/.php/$php_version
    sudo mv -f "$cli_legacy" "$php_folder/php"
    sudo mv -f "$config_legacy" "$php_folder/php-config"
    sudo mv -f "$phpize_legacy" "$php_folder/phpize"

    # php-fpm
    if [ -f "$fpm_legacy" ]; then
        sudo mv -f "$fpm_legacy" "$php_folder/php-fpm"
    fi

    # php-cgi
    if [ -f "$cgi_legacy" ]; then
        sudo mv -f "$cgi_legacy" "$php_folder/php-cgi"
    fi
fi

# remove old symlinks if they exist
sudo rm -f /usr/bin/php
sudo rm -f /usr/bin/php-config
sudo rm -f /usr/bin/phpize
sudo rm -f /usr/bin/php-fpm
sudo rm -f /usr/bin/php-cgi

php_folder=/home/lukas/.php/82

# crate symlinks
sudo ln -s "$php_folder/php" /usr/bin/php
sudo ln -s "$php_folder/php-config" /usr/bin/php-config
sudo ln -s "$php_folder/phpize" /usr/bin/phpize
sudo ln -s "$php_folder/php-fpm" /usr/bin/php-fpm
sudo ln -s "$php_folder/php-cgi" /usr/bin/php-cgi
