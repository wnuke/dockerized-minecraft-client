#!/usr/bin/env python3

import minecraft_launcher_lib
import sys

def main():
    minecraft_launcher_lib.install.install_minecraft_version(sys.argv[1], "/srv/minecraft")

if __name__ == "__main__":
    main()