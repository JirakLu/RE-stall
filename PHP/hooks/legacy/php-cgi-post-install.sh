#!/bin/sh

# Handle moving and re-symlinking files after install

# usr/bin/php-cgi-legacy

BINARY_NAME="php-cgi-legacy"
NEW_BINARY_NAME="php-cgi"

PHP_ENV_PATH="/usr/bin"
PVM_PATH="$HOME/.pvm"

# Get PHP version
PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

mkdir -p "$PVM_PATH/bin/$PHP_VERSION"

# Array of binaries to move
sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_PATH/bin/$PHP_VERSION/$NEW_BINARY_NAME"

# TODO call re-symlink script