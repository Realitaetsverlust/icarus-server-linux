#!/bin/bash

OS=$(cat /etc/*release | grep "^ID=")

if [[ $OS != 'ID=debian' ]] ; then
  echo "This script is for debian only. I didn't have the time to support other OS at this point in time."
  exit 1
fi


if [[ $(id -u) != 0 ]] ; then
  echo "This script needs to be executed as root. If you're uncomfortable with that, please follow the instructions in the readme to manually prepare the system."
  exit 1
fi

echo "Creating steam user ..."
useradd -s /bin/bash -d /home/steam -m steam

echo "Adding 32-bit support and installing basic packages ..."
dpkg --add-architecture i386
apt update && apt install --no-install-recommends -y ca-certificates lib32gcc-s1 curl wget gnupg2 software-properties-common && apt upgrade

echo "Installing latest stable wine version ..."
mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources
apt update
apt install --install-recommends winehq-stable

echo "All root-tasks done - executing install-script as steam user..."
su - steam -c "git clone https://github.com/Realitaetsverlust/icarus-server-linux /home/steam/icarus-server-linux"
su - steam -c "chmod +x /home/steam/icarus-server-linux/install_server.sh"
su - steam -c "chmod +x /home/steam/icarus-server-linux/launch_server.sh"
su - steam -c "bash /home/steam/icarus-server-linux/install_server.sh"
