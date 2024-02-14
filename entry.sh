#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
 
MAC_INTSTALLER="$SCRIPT_DIR/installer.sh"
LINUX_INSTALLER="$SCRIPT_DIR/linux_installer.sh"

echo "$MAC_INTSTALLER"

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

echo -e "${YELLOW}${BOLD}Welcome to the installer!${NORMAL}"

echo "Choose your operating system:"
echo "1. ${GREEN}${BOLD}Mac${NORMAL}"
echo "2. ${GREEN}${BOLD}Linux${NORMAL} ( Ubuntu 22.04 )"

read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
    "$MAC_INTSTALLER"
elif [ "$choice" == "2" ]; then
    # echo -e "${RED}${BOLD}Linux installer: Coming soon...${NORMAL}"
    "$LINUX_INSTALLER"
else
    echo -e "${RED}${BOLD}Invalid choice. Exiting...${NORMAL}"
    exit 1
fi

echo -e "${GREEN}${BOLD}Installation complete!${NORMAL}"
