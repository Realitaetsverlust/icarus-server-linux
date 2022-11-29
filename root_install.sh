#!/bin/bash

if [[ $(id -u) != 0 ]] ; then
  echo "This script needs to be executed as root. If you're uncomfortable with that, please follow the instructions in the readme to manually prepare the system."
  exit 1
fi

echo "Creating steam user ..."
useradd -s /bin/bash -d /home/steam -m steam

echo "Adding 32-bit support ..."
dpkg --add-architecture i386
apt-get update && apt-get install --no-install-recommends -y ca-certificates lib32gcc-s1 curl wget gnupg2 software-properties-common wine wine32 wine64 xvfb xauth && apt-get upgrade

echo "All root-tasks done - executing install-script as steam user..."
PWD=$(pwd)
su - steam -c "bash $PWD/install_server.sh"