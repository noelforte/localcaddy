#!/bin/bash
set -euo pipefail

RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"

echo -e "\n${YELLOW}==> Note: This script requires caddy to already be installed."
echo -e "==> If it is not installed, please install it via caddyserver.com, github, or your favorite package manager.${RESET}\n"

DEFAULT_PATH=~/Developer/www

read -p "Press ENTER to continue, Ctrl-C to abort..."

read -p "Path to your dev environment location (press ENTER to use ${DEFAULT_PATH}): " DEV_PATH
DEV_PATH=${DEV_PATH:-$DEFAULT_PATH}

if [[ ! -x "$(command -v caddy)" ]] ; then 
  echo "Error, caddy not installed or not found in PATH. Please install caddy or add it to your path to continue."
  echo "Aborting..."
  exit 1
fi

echo "Checking for folders..."
if [[ ! -e $DEV_PATH ]] ; then 
  mkdir -p $DEV_PATH
fi
if [[ ! -e ${DEV_PATH}/config ]] ; then 
  mkdir ${DEV_PATH}/config
fi
if [[ ! -e ${DEV_PATH}/public ]] ; then 
  mkdir ${DEV_PATH}/public
fi
if [[ ! -e ${DEV_PATH}/log ]] ; then 
  mkdir ${DEV_PATH}/log
fi

if [[ ! -e ${DEV_PATH}/config/Caddyfile ]] ; then
  echo "Making copy of Caddyfile with changes..."
  sed "s|<ROOT_PATH>|${DEV_PATH}|g" ./configs/Caddyfile > ${DEV_PATH}/config/Caddyfile
  echo "Caddyfile has been copied to ${DEV_PATH}/config/Caddyfile"
  echo -e "\n${GREEN}==> Local environment set up in ${DEV_PATH}.${RESET}\n"
else
  echo -e "\n${RED}==> A Caddyfile is already present at ${DEV_PATH}/config/Caddyfile.\n==> To use the one provided by this script, delete the currently existing one and re-run this script.${RESET}\n"
fi

read -p "Install LaunchAgent and caddyctl script? (requires root, you may be prompted for a password) (y/n): " do_service_files

if [[ $do_service_files == "y" || $do_service_files == "yes" ]] ; then
  echo "Making copy of .plist file with changes..."
  sed "s|<WORKING_DIR_PATH>|${DEV_PATH}/config|g" ./LaunchAgents/com.caddyserver.plist > ~/Library/LaunchAgents/com.caddyserver.plist
  
  echo -e "\n${BOLD}${BLUE}==> Created ~/Library/LaunchAgents/com.caddy.plist. You will need to edit this file in the future to modify the folder path, as this is where Caddy will be launched from.${RESET}\n"
  
  echo "Taking root ownership of caddy and moving to /usr/local/sbin..."
  sudo mv $(which caddy) /usr/local/sbin/caddy
  sudo chown root:wheel /usr/local/sbin/caddy
  sudo chmod +s /usr/local/sbin/caddy

  echo "Making copy of caddyctl with changes..."
  sed "s|<ROOT_PATH>|${DEV_PATH}|g" ./execs/caddyctl > /usr/local/bin/caddyctl
  chmod +x /usr/local/bin/caddyctl

  echo -e "\n${BOLD}${BLUE}==> Added caddyctl as an executable to /usr/local/bin/caddyctl. You can modify this script at any time by editing this file."
  echo -e "==> Get help by running 'caddyctl'.${RESET}"
fi

echo -e "${GREEN}==> Provision complete.${RESET}\n\n"

exit 0