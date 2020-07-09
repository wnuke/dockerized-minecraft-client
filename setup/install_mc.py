#!/usr/bin/env python3

import minecraft_launcher_lib

def main():
    version = "1.15.2"
    directory = "/srv/minecraft"
    minecraft_launcher_lib.install.install_minecraft_version(version, directory)

if __name__ == "__main__":
    main()
