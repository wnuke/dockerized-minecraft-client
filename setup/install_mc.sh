#!/usr/bin/env sh
echo "Downloading libraries..."
mkdir -p /srv/minecraft/versions/$GAMEVER
cp /srv/setup/$GAMEVER.json /srv/minecraft/versions/$GAMEVER/$GAMEVER.json
mkdir -p /srv/minecraft/libraries
python3 /srv/setup/getlibs.py /srv/minecraft/versions/$GAMEVER/$GAMEVER.json /srv/minecraft/libraries/
echo "Libraries downloaded."

echo "Downloading Minecraft..."
python3 /srv/setup/download_mc.py \
    --version=$BASEVER \
    --directory=/srv/minecraft
python3 /srv/setup/download_mc.py \
    --version=$GAMEVER \
    --directory=/srv/minecraft
cp /srv/minecraft/versions/$BASEVER/$BASEVER.jar /srv/minecraft/versions/$GAMEVER/$GAMEVER.jar
echo "Minecraft downloaded."

echo "Installing config..."
cp /srv/setup/options.txt /srv/minecraft/options.txt
cp /srv/setup/APIconfig.json /srv/minecraft/APIconfig.json
echo "Config installed..."

echo "Installing mods..."
mkdir -p /srv/minecraft/mods
cp /srv/setup/mchttpapi-1.0.0.jar /srv/minecraft/mods/mchttpapi-1.0.0.jar && \
  echo "HTTP-API installed."

cp /srv/setup/fabritone-1.5.3.jar /srv/minecraft/mods/fabritone-1.5.3.jar && \
  echo "Fabritone installed."
echo "Mods installed."