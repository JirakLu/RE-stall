#!/bin/sh
sudo pacman --noconfirm -S composer

echo 'Add this to your .rc file: export PATH="$HOME/.config/composer/vendor/bin:$PATH"'