#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
  echo "This script is designed for an unprivileged user. Please do NOT install, let alone run a game server as root. Never ever."
  exit 1
fi

echo "What is the name of the server? (Icarus Server)"
read SERVERNAME

if [ -z "${SERVERNAME}" ]; then
  SERVERNAME="Icarus Server"
fi

echo "What is the game port? (17777)"
read GAMEPORT

if [ -z "${GAMEPORT}" ]; then
  GAMEPORT=17777
fi

echo "What is the query port? (27015)"
read QUERYPORT

if [ -z "${QUERYPORT}" ]; then
  QUERYPORT=27015
fi

CURRENTUSER=$(whoami)
HOMEDIR=/home/$CURRENTUSER

echo "Server name: $SERVERNAME"
echo "Game port: $GAMEPORT"
echo "Query port: $QUERYPORT"
echo "Are these values correct? (y/n)"

read answer

if [ "$answer" != 'y' ]; then
  echo "Aborting install ..."
  exit 0
fi

rm -f ~/serverconfig.env
echo "SERVERNAME=\"$SERVERNAME\"" >> ~/serverconfig.env
echo "GAMEPORT=\"$GAMEPORT\"" >> ~/serverconfig.env
echo "QUERYPORT=\"$QUERYPORT\"" >> ~/serverconfig.env
echo "WINEPREFIX=\"/home/steam/.icarus\"" >> ~/serverconfig.env
echo "WINEPATH=\"/\"" >> ~/serverconfig.env

. ~/serverconfig.env

export WINEARCH=win32

echo "Adding necessary directories ..."
mkdir -p $HOMEDIR/icarus/drive_c/icarus
mkdir -p $HOMEDIR/game/icarus
mkdir -p $HOMEDIR/steamcmd

echo "Installing steamcmd ..."
curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -v -C ~/steamcmd -zx
chown -R $CURRENTUSER:$CURRENTUSER ~

echo "Downloading vc_redist ..."
wget https://aka.ms/vs/17/release/vc_redist.x64.exe -P $HOMEDIR
chmod +x $HOMEDIR/vc_redist.x64.exe

# We're hiding this as it throws an error, but still works in the end. I have no clue why.
#echo "Installing vc_redist - this might take a while ..."
xvfb-run -a wine $HOMEDIR/vc_redist.x64.exe /quiet /norestart

echo "Installation complete!"

exit 0
