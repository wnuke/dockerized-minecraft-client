#!/usr/bin/env sh
echo "Creating symlinks..."
mkdir -p /srv/instance
ln -s /srv/minecraft/options.txt /srv/instance/options.txt
ln -s /srv/minecraft/APIconfig.json /srv/instance/APIconfig.json
ln -s /srv/minecraft/mods /srv/instance/mods
echo "Launching Minecraft..."
cd /srv/minecraft && \
  python3 /srv/launch_mc.py \
    --version=$GAMEVER \
    --gamedir="/srv/minecraft" \
    --instdir="/srv/instance" \
    --port="8000" && \
  echo "Minecraft stopped." && exit