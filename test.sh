#!/bin/sh

GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
COLOR_RESET=$(tput sgr0)

printf "%s\n" "${RED}FAILED${COLOR_RESET}"
printf "%s\n" "${GREEN}SUCCESS${COLOR_RESET}"

echo "normal"