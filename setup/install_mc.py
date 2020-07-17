#!/usr/bin/env python3
import minecraft_launcher_lib
import sys

minecraft_launcher_lib.install.install_minecraft_version(sys.argv[1], "/srv/minecraft")
