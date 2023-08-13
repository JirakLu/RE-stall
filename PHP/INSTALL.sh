#!/bin/bash

sudo rm -rf /usr/local/bin/php-post-install-hook.sh >/dev/null 2>&1
sudo rm -rf /etc/pacman.d/hooks/php-post-install-hook.hook >/dev/null 2>&1

source php-install.sh
source php-legacy-install.sh

# Move pvm script
mkdir -p /usr/local/.pvm
sudo cp -f ./pvm.sh /usr/local/.pvm/pvm
sudo chmod 755 /usr/local/bin/php-post-install-hook.sh

# Create post install pacman hook
sudo mkdir -p /usr/local/bin /etc/pacman.d/hooks
sudo cp -f ./hooks/php-post-install-hook.sh /usr/local/bin/php-post-install-hook.sh
sudo chown root:root /usr/local/bin/php-post-install-hook.sh
sudo chmod 755 /usr/local/bin/php-post-install-hook.sh

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
php-legacy-fpm" | /bin/bash /usr/local/bin/php-post-install-hook.sh

echo 'Add this to your .rc file: export PATH="/usr/local/.pvm:$PATH"'

