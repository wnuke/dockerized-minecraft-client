#!/usr/bin/env python3

import minecraft_launcher_lib

def main():
    minecraft_launcher_lib.install.install_minecraft_version("1.12.2", "/srv/minecraft")

if __name__ == "__main__":
    main()
