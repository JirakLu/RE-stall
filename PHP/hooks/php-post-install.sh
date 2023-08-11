#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/phar
# usr/bin/phar.phar
# usr/bin/php
# usr/bin/php-config
# usr/bin/phpize

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/php" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"

# Array of binaries to move
set -- "php" "php-config" "phpize" "phar" "phar.phar"
for item in "$@";
  do sudo mv -f "$PHP_ENV_PATH/$item" "$PVM_PATH/bin/$PHP_VERSION/$item"
done


# TODO call re-symlink script