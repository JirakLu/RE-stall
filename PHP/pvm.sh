#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

# Terminal colors
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
COLOR_RESET=$(tput sgr0)

PVM_DIR="<home>/.pvm"

# Get newest version by comparing all versions in bin folder
get_newest_version() {
  newest_version=$(ls -1 "$PVM_DIR"/bin | sort -V | tail -n 1)

  # If empty abort
  if [ -z "$newest_version" ]; then
    echo "${RED}No version found. Please add binaries to $PVM_DIR/bin/<version>${COLOR_RESET}"
    exit 1
  fi

  echo "$newest_version"
}

# Get current version by reading .pvmrc
# If there is no .pvmrc file, get the newest version and set it as active
get_current_version() {
  active_version=$(head --lines 1 "$PVM_DIR"/.pvmrc 2>/dev/null)

  if [ -z "$active_version" ]; then
    active_version=$(get_newest_version)
    echo "$active_version" > "$PVM_DIR"/.pvmrc
  fi

  echo "$active_version"
}

# Handle resymlinking files
# all files from $PVM_DIR/bin/<version> to /usr/bin
# all files from $PVM_DIR/services/<version> to /usr/lib/systemd/system

resymlink() {
  version="$1"
  echo "Switching to version: $version"

  # Check if $PVM_DIR/bin/<version> exists
  if [ ! -d "$PVM_DIR/bin/$version" ]; then
    echo "${RED}Binaries for $version not found.${COLOR_RESET}"
    exit 1
  fi

  # Stop services
  sudo systemctl stop php-fpm

  # Remove old symlinks and create new
  for file in "$PVM_DIR"/bin/"$version"/*; do
    filename=$(basename "$file")
    sudo rm -f "/usr/bin/$filename"
    sudo ln -s "$file" "/usr/bin/$filename"
  done

  # Set active version to .pvmrc
  echo "$version" | sudo tee "$PVM_DIR"/.pvmrc >/dev/null 2>&1

  echo "Restarting services..."
  # Restart services
  sudo systemctl daemon-reload
  sudo systemctl enable php-fpm
  sudo systemctl start php-fpm

  echo "${GREEN}Successfully switched to PHP $version${COLOR_RESET}"
}

# pvm use <version | "latest">
handle_use() {
  version="$1"
  # If version is empty or "latest" set it to latest
  if [ -z "$version" ] || [ "$version" = "latest" ]; then
    if [ -z "$version" ] ; then
      echo "No version given. Using latest."
    fi
    version=$(get_newest_version)
  fi

  resymlink "$version"
}

# pvm restart
# resymlink current version in .pvmrc
handle_restart() {
  echo "Restarting all PHP symlinks..."
  version=$(get_current_version)
  resymlink "$version"
}

# pvm list
# list all installed versions
handle_list() {
  echo "Installed versions:"
  ls -1 "$PVM_DIR"/bin | sort -V
}

# pvm help
# show help
handle_help() {
  echo "Commands:"
  echo "  use <version | \"latest\">"
  echo "     - switch to specific version or latest"
  echo "  restart"
  echo "     - restart all PHP symlinks"
  echo "  list"
  echo "     - list all installed versions"
  echo "  help"
  echo "     - show this help"
}


command="$1"

if [ "$command" == "use" ]; then
    handle_use "$2"
elif [ "$command" == "restart" ]; then
    handle_restart
elif [ "$command" == "list" ]; then
    handle_list
elif [ "$command" == "help" ] || [ "$command" = "-h" ]; then
    handle_help
else
    echo "Invalid command."
fi