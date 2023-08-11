#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/php-fpm
# usr/lib/systemd/system/php-fpm.service

BINARY_NAME="php-fpm"

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"

sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_PATH/bin/$PHP_VERSION/$BINARY_NAME"


# TODO call re-symlink script