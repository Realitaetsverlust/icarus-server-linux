# Icarus-Server-Linux
A collection of scripts for running a game-server of the game "Icarus: First Cohort" (https://store.steampowered.com/app/1149460/ICARUS)

The developers of Icarus run their servers on windows and do not provide a native linux versions. However, yet again, wine is to the rescue. The game requires very little configuration and runs without (linux-specific) hickups. However, keep in mind that the current build of the server provided by the devs is still in a beta-state, so hickups are to be expected.

## Installation

After you cloned this repo, you have to set up the system you're working on. If you run a debian system, you have two options to do this. The easiest option is to run the `root_install.sh` as root user. This script is basically a collection of the commands below. If you don't want to do that or are not using a debian system, you can always execute the commands below manually - keep in mind that you'll have to adjust the commands depending on your distro. I'll slowly add support for other OS but debian, so keep tuned.

First of all, you will need an unprivileged user, I named mine `steam`, but you can use any name you want. You can create your user with this command:

```
useradd -s /bin/bash -d /home/steam -m steam
```

The name of the home directoy HAS to match the name of the user.

Then, add 32-bit support and update your system

```
dpkg --add-architecture i386
apt-get update && apt-get install --no-install-recommends -y ca-certificates lib32gcc-s1 curl wget gnupg2 software-properties-common && apt-get upgrade
```

Now, we still need wine. Debian ships with wine 5 by default, which is a bit too old, so we're going to install wine-stable.

```
mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources
apt update
apt install --install-recommends winehq-stable
```

This process is debian only - please refer to a guide on how to install wine 7 for your distro if you are not using debian.

Once you did that, you can switch to the user you created above and either clone this repository or copy the `install_server.sh` and `launch_server.sh` into the home folder of your user.

Then, set permissions:

```
chmod +x install_server.sh
chmod +x launch_server.sh
```

Now you're ready for the server installation. Execute `install_server.sh`. It'll ask you for the name of the server (the one displayed in the server browser) and the ports it should use. I've used somewhat sane defaults, but you can change them however you like.

## Launching the server

Simply execute `launch_server.sh`. I recommend using screen or tmux to avoid being locked into the terminal. Then you're ready to play!

## Hickups

The icarus server supports configuration via an .ini file. It's located under `.wine/drive_c/icarus/Saved/Config/WindowsServer/ServerSettings.ini`. However, do not attempt to create this file yourself. The server has to do that itself, but it doesn't do that on startup. Launch the server unprotected, join in and immediatly launch a mission. Now quit out again. In the directoy, it should have created a lot of .ini-files, including the ServerSettings.ini, which you can now change to your liking. A full documentation of the possible values can be found here: https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Config-&-Launch-Parameters

## License

This afternoon-project was licensed under the WTFPL.
