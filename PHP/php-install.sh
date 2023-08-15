#!/bin/sh

# Terminal colors
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
COLOR_RESET=$(tput sgr0)

PHP_INI_FILE="/etc/php/php.ini"
PHP_CONF_DIR="/etc/php/conf.d"

# First cleanup possible conflicts
echo "Cleaning up possible conflicts..."
sudo rm -f "$PHP_INI_FILE"
sudo rm -f "$PHP_CONF_DIR"/*.ini

# Install PHP
echo "Installing PHP..."
sudo pacman --noconfirm -S php php-fpm php-cgi >/dev/null 2>&1

# PHP extensions
echo "Installing PHP extensions..."

sudo pacman --noconfirm -S \
php-gd \
php-imagick \
php-redis \
php-pgsql \
php-sqlite \
php-sodium \
php-xsl \
xdebug \
imagemagick > /dev/null 2>&1

# Modify php.ini
echo "Changing some php.ini values..."

sudo sed -i \
  -e 's/;date.timezone =/date.timezone = Europe\/Prague/' \
  -e 's/zend.exception_ignore_args = On/zend.exception_ignore_args = Off/' \
  -e 's/zend.exception_string_param_max_len = 0/zend.exception_string_param_max_len = 15/' \
  -e 's/mysqlnd.collect_memory_statistics = Off/mysqlnd.collect_memory_statistics = On/' \
  -e 's/zend.assertions = -1/zend.assertions = 1/' \
  -e 's/display_errors = Off/display_errors = On/' \
  -e 's/display_startup_errors = Off/display_startup_errors = On/' \
  -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/' "$PHP_INI_FILE"

# Enable extensions
echo "Enabling PHP extensions..."

echo "extension=igbinary" | sudo tee "$PHP_CONF_DIR"/igbinary.ini >/dev/null 2>&1

sudo sed -i 's/; extension = imagick/extension=imagick/' "$PHP_CONF_DIR"/imagick.ini
sudo sed -i 's/;extension=redis/extension=redis/' "$PHP_CONF_DIR"/redis.ini
sudo sed -i \
  -e 's/;extension=gd/extension=gd/' \
  -e 's/;extension=mysqli/extension=mysqli/' \
  -e 's/;extension=pdo_mysql/extension=pdo_mysql/' \
  -e 's/;extension=pgsql/extension=pgsql/' \
  -e 's/;extension=pdo_pgsql/extension=pdo_pgsql/' \
  -e 's/;extension=sqlite3/extension=sqlite3/' \
  -e 's/;extension=pdo_sqlite/extension=pdo_sqlite/' \
  -e 's/;extension=sodium/extension=sodium/' \
  -e 's/;extension=bcmath/extension=bcmath/' \
  -e 's/;extension=bz2/extension=bz2/' \
  -e 's/;extension=calendar/extension=calendar/' \
  -e 's/;extension=dba/extension=dba/' \
  -e 's/;extension=exif/extension=exif/' \
  -e 's/;extension=ffi/extension=ffi/' \
  -e 's/;extension=ftp/extension=ftp/' \
  -e 's/;extension=gmp/extension=gmp/' \
  -e 's/;extension=iconv/extension=iconv/' \
  -e 's/;extension=intl/extension=intl/' \
  -e 's/;zend_extension=opcache/zend_extension=opcache/' \
  -e 's/;extension=shmop/extension=shmop/' \
  -e 's/;extension=soap/extension=soap/' \
  -e 's/;extension=sockets/extension=sockets/' \
  -e 's/;extension=xsl/extension=xsl/' \
  -e 's/;extension=sysvmsg/extension=sysvmsg/' \
  -e 's/;extension=sysvsem/extension=sysvsem/' \
  -e 's/;extension=sysvshm/extension=sysvshm/' "$PHP_INI_FILE"

# Handle XDebug
echo "zend_extension=xdebug.so
xdebug.mode=develop" | sudo tee "$PHP_CONF_DIR"/xdebug.ini >/dev/null 2>&1

# Check if php -m is same as extension-check.txt
echo "Checking if installation was successful..."
test_files="./test-files"
tmp_name="php-extensions.txt"

php -m > "$test_files/$tmp_name"
file_1="$test_files/$tmp_name"
file_2="$test_files/extensions-check.txt"

if cmp -s "$file_1" "$file_2"; then
    printf "%s\n\n" "${GREEN}PHP installed successfully...${COLOR_RESET}"
    rm "$test_files/$tmp_name"
else
    printf "%s\n" "${RED}PHP installation failed...${COLOR_RESET}"
    diff "$file_1" "$file_2"
    rm "$test_files/$tmp_name"
    exit 1
fi