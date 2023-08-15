#!/bin/sh

PHP_ENV_PATH="/usr/bin"
PVM_DIR="<home>/.pvm"
SYSTEMD_PATH="/usr/lib/systemd/system"

handle_php() {
  # Get PHP version
  PHP_VERSION=$("$PHP_ENV_PATH/php" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

  mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

  # Array of binaries to move
  set -- "php" "php-config" "phpize" "phar" "phar.phar"
  for item in "$@";
    do sudo mv -f "$PHP_ENV_PATH/$item" "$PVM_DIR/bin/$PHP_VERSION/$item"
  done
}

handle_php_cgi() {
  BINARY_NAME="php-cgi"

  # Get PHP-cgi version
  PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

  mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

  sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_DIR/bin/$PHP_VERSION/$BINARY_NAME"
}

handle_php_fpm() {
  BINARY_NAME="php-fpm"

  # Check if exists
  if [ -f "$PHP_ENV_PATH/$BINARY_NAME" ]; then
    # Get PHP-fpm version
    PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
    PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

    mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

    sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_DIR/bin/$PHP_VERSION/$BINARY_NAME"
  fi
}

handle_php_legacy() {
  # Get PHP-legacy version
  PHP_VERSION=$("$PHP_ENV_PATH/php-legacy" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

  mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

  # Array of binaries to move
  set -- "php-legacy" "php-config-legacy" "phpize-legacy" "phar-legacy" "phar-legacy.phar"
  for item in "$@";
  do
      new_item=$(echo "$item" | sed 's/-legacy//g')
      sudo mv -f "$PHP_ENV_PATH/$item" "$PVM_DIR/bin/$PHP_VERSION/$new_item"
  done
}

handle_php_legacy_cgi() {
  BINARY_NAME="php-cgi-legacy"
  NEW_BINARY_NAME="php-cgi"

  # Get PHP-cgi version
  PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
  PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

  mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

  sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_DIR/bin/$PHP_VERSION/$NEW_BINARY_NAME"
}

handle_php_legacy_fpm() {
  BINARY_NAME="php-fpm-legacy"
  NEW_BINARY_NAME="php-fpm"
  SERVICE_NAME="php-fpm-legacy.service"

  # Check if exists
  if [ -f "$PHP_ENV_PATH/$BINARY_NAME" ]; then
    # Get PHP-fpm version
    PHP_VERSION=$("$PHP_ENV_PATH/$BINARY_NAME" -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
    PHP_VERSION=$(echo "$PHP_VERSION" | sed 's/\.//g')

    mkdir -p "$PVM_DIR/bin/$PHP_VERSION"

    sudo mv -f "$PHP_ENV_PATH/$BINARY_NAME" "$PVM_DIR/bin/$PHP_VERSION/$NEW_BINARY_NAME"

    # Remove old service files
    sudo rm -f "$SYSTEMD_PATH/$SERVICE_NAME"
    sudo rm -f "$SYSTEMD_PATH/php-legacy-fpm.service"
  fi
}

while IFS= read -r target; do
  # Create switch for target
  case "$target" in
      "php")
          handle_php
          ;;
      "php-cgi")
          handle_php_cgi
          ;;
      "php-fpm")
          handle_php_fpm
          ;;
      "php-legacy")
          handle_php_legacy
          ;;
      "php-legacy-cgi")
          handle_php_legacy_cgi
          ;;
      "php-legacy-fpm")
          handle_php_legacy_fpm
          ;;
      *)
          echo "Unknown target: $target"
          exit 1
          ;;
  esac
done

"$PVM_DIR"/pvm restart