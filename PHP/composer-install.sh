#!/bin/sh
sudo pacman --noconfirm -S composer

# If using bash add to path
echo "## Composer" >> ~/.bashrc
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc