#!/bin/sh

# Terminal colors
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
COLOR_RESET=$(tput sgr0)

# Install PHP
sudo pacman --noconfirm -S php-legacy php-legacy-fpm php-legacy-cgi

# XDebug & PHP extensions
sudo pacman --noconfirm --needed -S php-legacy \
php-legacy-gd \
php-legacy-imagick \
php-legacy-redis \
php-legacy-pgsql \
php-legacy-sqlite \
php-legacy-sodium \
imagemagick
yay --noconfirm --needed -S php-legacy-xdebug

# Modify php.ini

# Set timezone properly
sudo sed -i 's/;date.timezone =/date.timezone = Europe\/Prague/' /etc/php-legacy/php.ini

# Display all errors
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php-legacy/php.ini
sudo sed -i 's/display_startup_errors = Off/display_startup_errors = On/' /etc/php-legacy/php.ini
sudo sed -i 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' /etc/php-legacy/php.ini

# Set memory limit to 512MB
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php-legacy/php.ini

# Enable extensions
sudo sed -i 's/;extension=gd/extension=gd/' /etc/php-legacy/php.ini
sudo sed -i 's/; extension = imagick/extension = imagick/' /etc/php-legacy/conf.d/imagick.ini
sudo sed -i 's/;extension=igbinary/extension=igbinary/' /etc/php-legacy/conf.d/igbinary.ini
sudo sed -i 's/;extension=redis/extension=redis/' /etc/php-legacy/conf.d/redis.ini
sudo sed -i 's/;extension=mysqli/extension=mysqli/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=pgsql/extension=pgsql/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=pdo_pgsql/extension=pdo_pgsql/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sqlite3/extension=sqlite3/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=pdo_sqlite/extension=pdo_sqlite/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sodium/extension=sodium/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=bcmath/extension=bcmath/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=bz2/extension=bz2/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=calendar/extension=calendar/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=dba/extension=dba/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=exif/extension=exif/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=ffi/extension=ffi/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=ftp/extension=ftp/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=gmp/extension=gmp/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=iconv/extension=iconv/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=intl/extension=intl/' /etc/php-legacy/php.ini
sudo sed -i 's/;zend_extension=opcache/zend_extension=opcache/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=shmop/extension=shmop/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=soap/extension=soap/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sockets/extension=sockets/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sysvmsg/extension=sysvmsg/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sysvsem/extension=sysvsem/' /etc/php-legacy/php.ini
sudo sed -i 's/;extension=sysvshm/extension=sysvshm/' /etc/php-legacy/php.ini

# Handle XDebug
echo "" | sudo tee /etc/php-legacy/conf.d/xdebug.ini
echo "zend_extension=xdebug.so" | sudo tee -a /etc/php-legacy/conf.d/xdebug.ini
echo "xdebug.mode=develop" | sudo tee -a /etc/php-legacy/conf.d/xdebug.ini

# Check if php-legacy -m is same as extension-check.txt
test_files="./test-files"
tmp_name="php-extensions.txt"

/usr/bin/php-legacy -m > "$test_files/$tmp_name"
file_1="$test_files/$tmp_name"
file_2="$test_files/extensions-check-legacy.txt"

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

/usr/bin/php-legacy -v




