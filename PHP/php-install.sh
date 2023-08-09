#!/bin/sh

# Terminal colors
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
COLOR_RESET=$(tput sgr0)

# Install PHP
sudo pacman --noconfirm -S php php-fpm php-cgi

# XDebug & PHP extensions
sudo pacman --noconfirm --needed -S \
php-gd \
php-imagick \
php-redis \
php-pgsql \
php-sqlite \
php-sodium \
xdebug \
imagemagick

# Modify php.ini

# Set timezone properly
sudo sed -i 's/;date.timezone =/date.timezone = Europe\/Prague/' /etc/php/php.ini

# Display all errors
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php/php.ini
sudo sed -i 's/display_startup_errors = Off/display_startup_errors = On/' /etc/php/php.ini
sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php/php.ini

# Set memory limit to 512MB
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/php.ini

# Enable extensions
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php/php.ini
sudo sed -i 's/; extension = imagick/extension = imagick/' /etc/php/conf.d/imagick.ini
sudo sed -i 's/;extension=igbinary/extension=igbinary/' /etc/php/conf.d/igbinary.ini
sudo sed -i 's/;extension=redis/extension=redis/' /etc/php/conf.d/redis.ini
sudo sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
sudo sed -i 's/;extension=pgsql/extension=pgsql/' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_pgsql/extension=pdo_pgsql/' /etc/php/php.ini
sudo sed -i 's/;extension=sqlite3/extension=sqlite3/' /etc/php/php.ini
sudo sed -i 's/;extension=pdo_sqlite/extension=pdo_sqlite/' /etc/php/php.ini
sudo sed -i 's/;extension=sodium/extension=sodium/' /etc/php/php.ini
sudo sed -i 's/;extension=bcmath/extension=bcmath/' /etc/php/php.ini
sudo sed -i 's/;extension=bz2/extension=bz2/' /etc/php/php.ini
sudo sed -i 's/;extension=calendar/extension=calendar/' /etc/php/php.ini
sudo sed -i 's/;extension=dba/extension=dba/' /etc/php/php.ini
sudo sed -i 's/;extension=exif/extension=exif/' /etc/php/php.ini
sudo sed -i 's/;extension=ffi/extension=ffi/' /etc/php/php.ini
sudo sed -i 's/;extension=ftp/extension=ftp/' /etc/php/php.ini
sudo sed -i 's/;extension=gmp/extension=gmp/' /etc/php/php.ini
sudo sed -i 's/;extension=iconv/extension=iconv/' /etc/php/php.ini
sudo sed -i 's/;extension=intl/extension=intl/' /etc/php/php.ini
sudo sed -i 's/;zend_extension=opcache/zend_extension=opcache/' /etc/php/php.ini
sudo sed -i 's/;extension=shmop/extension=shmop/' /etc/php/php.ini
sudo sed -i 's/;extension=soap/extension=soap/' /etc/php/php.ini
sudo sed -i 's/;extension=sockets/extension=sockets/' /etc/php/php.ini
sudo sed -i 's/;extension=sysvmsg/extension=sysvmsg/' /etc/php/php.ini
sudo sed -i 's/;extension=sysvsem/extension=sysvsem/' /etc/php/php.ini
sudo sed -i 's/;extension=sysvshm/extension=sysvshm/' /etc/php/php.ini

# Handle XDebug
echo "" | sudo tee /etc/php/conf.d/xdebug.ini
echo "zend_extension=xdebug.so" | sudo tee -a /etc/php/conf.d/xdebug.ini
echo "xdebug.mode=develop" | sudo tee -a /etc/php/conf.d/xdebug.ini

# Check if php -m is same as extension-check.txt
test_files="./test-files"
tmp_name="php-extensions.txt"

php -m > "$test_files/$tmp_name"
file_1="$test_files/$tmp_name"
file_2="$test_files/extensions-check.txt"

if cmp -s "$file_1" "$file_2"; then
    clear
    printf "%s\n\n" "${GREEN}PHP installed successfully...${COLOR_RESET}"
else
    clear
    printf "%s\n" "${RED}PHP installation failed...${COLOR_RESET}"
    diff "$file_1" "$file_2"
    exit 1
fi

rm "$test_files/$tmp_name"

php -v




