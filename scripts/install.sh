#!/bin/bash
set -euo pipefail

# installation script for downloading caddy from source for mac

echo -e "
This script will do the following:
1) Download caddy
2) Make it executable
3) Install it into /usr/local/bin
"

DEFAULT_PATH=~/Desktop/dev

read -p "Proceed? (y/n): " proceed

if [[ $proceed == "y" || $proceed == "yes" ]] 
  then

  read -p "Path to your dev environment location (press ENTER to use ${DEFAULT_PATH}): " DEV_PATH

  DEV_PATH=${DEV_PATH:-$DEFAULT_PATH}

  if [[ ! -e $DEV_PATH ]]
    then echo "Path does not exist. Creating..."
    mkdir -p $DEV_PATH
  fi

  if [[ ! -x "$(command -v caddy)" ]]
    then echo "Need to install caddy..."

    curl -o "caddy" "https://caddyserver.com/api/download?os=darwin&arch=amd64"
    chmod +x caddy
    mv -f ./caddy /usr/local/bin/caddy

    echo "Done! Installed caddy into /usr/local/bin."
  else
    echo "Caddy is already installed. Continuing..."
  fi

  echo "Checking for folders..."
  if ! [[ -e ${DEV_PATH}/config ]]
    then mkdir ${DEV_PATH}/config
  fi
  if ! [[ -e ${DEV_PATH}/public ]]
    then mkdir ${DEV_PATH}/public
  fi

  echo "Setting up Caddyfile..."
  sed "s|<ROOT_PATH>|${DEV_PATH}/public|g" ./configs/Caddyfile > ${DEV_PATH}/config/Caddyfile

  echo "

Caddyfile is in place. You'll want to test caddy before continuing.
In a new terminal window, execute 'caddy run' from '${DEV_PATH}/config'.
If caddy can start successfully then you can use 'install_service.sh' to install the service file and control script.

"
  
else
  echo "Aborting..."
  exit 1
fi