#!/bin/bash

# Run all post-install hooks

source ./hooks/php-post-install.sh
source ./hooks/php-fpm-post-install.sh
source ./hooks/php-cgi-post-install.sh

source ./hooks/legacy/php-post-install.sh
source ./hooks/legacy/php-fpm-post-install.sh
source ./hooks/legacy/php-cgi-post-install.sh
