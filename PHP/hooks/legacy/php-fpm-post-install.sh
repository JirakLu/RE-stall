#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/php-fpm
# usr/lib/systemd/system/php-fpm.service

BINARY_NAME="php-fpm-legacy"
NEW_BINARY_NAME="php-fpm"
SERVICE_NAME="php-fpm-legacy.service"

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"
SYSTEMD_PATH="/usr/lib/systemd/system"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"

sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_PATH/bin/$PHP_VERSION/$NEW_BINARY_NAME"

# Remove old service files
sudo rm -f "$SYSTEMD_PATH/$SERVICE_NAME"
sudo rm -f "$SYSTEMD_PATH/php-legacy-fpm.service"


# TODO call re-symlink script