#!/usr/bin/env python3
import minecraft_launcher_lib
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--version",default=minecraft_launcher_lib.utils.get_latest_version()["release"],help="The Minecraft version")
parser.add_argument("--directory",help="The Minecraft version")
args = parser.parse_args().__dict__

minecraft_launcher_lib.install.install_minecraft_version(args["version"],args["directory"],callback={"setStatus":print})
