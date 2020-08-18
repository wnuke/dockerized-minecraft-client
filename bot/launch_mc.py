#!/usr/bin/env python3
import argparse
import random
import string
import subprocess
import uuid

import minecraft_launcher_lib

parser = argparse.ArgumentParser()
parser.add_argument("--gamedir", default="/srv/minecraft", help="Directory where the game files are located")
parser.add_argument("--instdir", default="/srv/instance", help="Directory where the instance config is stored")
parser.add_argument("--version", default="fabric-1.16", help="The Minecraft version")
parser.add_argument("--username", default="", help="Mojang username")
parser.add_argument("--password", default="", help="Mojang password")
args = parser.parse_args().__dict__

options = {
    "username": "nukebot",
    "uuid": "0",
    "token": "0",
    "launcherName": "mclauncher-cmd",
    "launcherVersion": "1.0",
    "demo": "false",
    "gameDirectory": str(args["instdir"]),
    "jvmArguments": ["-Xms300M", "-Xmx450M", "-XX:+UnlockExperimentalVMOptions", "-XX:+AlwaysPreTouch", "-XX"
                                                                                                        ":+UseAdaptiveGCBoundary",
                     "-XX:+UseGCOverheadLimit", "-XX:MaxHeapFreeRatio=80",
                     "-XX:MinHeapFreeRatio=40", "-XX:-UseG1GC", "-XX:+UseZGC", "-XX:+DisableExplicitGC",
                     "-XX:-UseParallelGC"],
    "resolutionWidth": "20",
    "resolutionHeight": "20",
}

command = minecraft_launcher_lib.command.get_minecraft_command(str(args["version"]), str(args["gamedir"]), options)

subprocess.call(command)
