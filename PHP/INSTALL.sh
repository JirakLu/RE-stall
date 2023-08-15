#!/bin/bash

# Terminal colors
GREEN=$(tput setaf 2)
COLOR_RESET=$(tput sgr0)

PVM_DIR="$HOME/.pvm"

# Clean old post install pacman hook
sudo rm -f /usr/local/bin/php-post-install-hook.sh >/dev/null 2>&1
sudo rm -f /etc/pacman.d/hooks/php-post-install-hook.hook >/dev/null 2>&1

# Install PHP
./php-install.sh
./php-legacy-install.sh

# Install composer
sudo pacman --noconfirm -S composer >/dev/null 2>&1

# Move pvm script
mkdir -p "$PVM_DIR"
sudo cp -f ./pvm.sh "$PVM_DIR"/pvm
sudo chmod 755 "$PVM_DIR"/pvm
sudo sed -i "s|<home>|$HOME|g" "$PVM_DIR"/pvm

# Create post install pacman hook
sudo mkdir -p /usr/local/bin /etc/pacman.d/hooks
sudo cp -f ./hooks/php-post-install-hook.sh /usr/local/bin/php-post-install-hook.sh
sudo chown root:root /usr/local/bin/php-post-install-hook.sh
sudo chmod 755 /usr/local/bin/php-post-install-hook.sh
sudo sed -i "s|<home>|$HOME|g" /usr/local/bin/php-post-install-hook.sh

echo "[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = php
Target = php-cgi
Target = php-fpm
Target = php-legacy
Target = php-legacy-cgi
Target = php-legacy-fpm

[Action]
Description = Moving php binaries to enable versioning using pvm...
When = PostTransaction
Exec = /usr/local/bin/php-post-install-hook.sh
NeedsTargets" | sudo tee /etc/pacman.d/hooks/php-post-install-hook.hook >/dev/null 2>&1

# Run the hook
echo "php
php-cgi
php-fpm
php-legacy
php-legacy-cgi
php-legacy-fpm" | . /usr/local/bin/php-post-install-hook.sh

echo "${GREEN}PHP was installed!${COLOR_RESET}"

printf '\nAdd this to your .rc file
export PATH="$HOME/.pvm:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"\n'


