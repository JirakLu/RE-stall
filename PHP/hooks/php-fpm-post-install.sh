#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/php-fpm
# usr/lib/systemd/system/php-fpm.service

BINARY_NAME="php-fpm"
SERVICE_NAME="php-fpm.service"

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"
SYSTEMD_PATH="/usr/lib/systemd/system"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"
mkdir -p "$PVM_PATH/services/$PHP_VERSION"

sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_PATH/bin/$PHP_VERSION/$BINARY_NAME"
sudo mv -f "$SYSTEMD_PATH/$SERVICE_NAME" "$PVM_PATH/services/$PHP_VERSION/$SERVICE_NAME"


# TODO call re-symlink script