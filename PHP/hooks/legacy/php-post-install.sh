#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/phar-legacy
# usr/bin/phar-legacy.phar
# usr/bin/php-config-legacy
# usr/bin/php-legacy
# usr/bin/phpize-legacy

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/php-legacy" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"

# Array of binaries to move
set -- "php-legacy" "php-config-legacy" "phpize-legacy" "phar-legacy" "phar-legacy.phar"
for item in "$@";
do
    new_item=$(echo "$item" | sed 's/-legacy//g')
    sudo mv -f "$PHP_ENV_PATH/$item" "$PVM_PATH/bin/$PHP_VERSION/$new_item"
done


# TODO call re-symlink script