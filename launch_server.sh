#!/bin/bash

if [[ $(id -u) == 0 ]] ; then
  echo "Running a PUBLIC SERVER as root user is a really really bad idea."
  exit 1
fi

. ~/serverconfig.env

echo "####################"
echo "##  ICARUS SERVER ##"
echo "####################"

echo Server Name: $SERVERNAME 
echo Game Port  : $GAMEPORT
echo Query Port : $QUERYPORT

HOMEDIR=/home/$(whoami)

echo "Initializing wine ..."
wineboot --init

echo "Performing steam update ..."
$HOMEDIR/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir ~/game/ +login anonymous +app_update 2089300 +quit

echo "Launching server ..."
wine $HOMEDIR/game/icarus/Binaries/Win64/IcarusServer-Win64-Shipping.exe -Log -UserDir='C:\icarus' -SteamServerName="$SERVERNAME" -PORT="$GAMEPORT" -QueryPort="$QUERYPORT"
