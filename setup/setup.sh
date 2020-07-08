#!/usr/bin/env bash

pip install --user pipenv
pip install --user minecraft-launcher-cmd
pipenv sync
./install_mc.py
mkdir minecraft/versions/fabric-1.15.2
cp fabric-1.15.2.json minecraft/fabric-1.15.2/fabric-1.15.2.json
mkdir minecraft/mods
cp headless-api-1.0.0.jar setup/minecraft/mods/headlessapi.jar
cp fabritone-1.5.3.jar minecraft/mods/fabritone.jar
cp options.txt minecraft/options.txt
mkdir gamedir