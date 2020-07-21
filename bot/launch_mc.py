#!/usr/bin/env python3
import minecraft_launcher_lib
import subprocess
import argparse
import random
import string
import uuid

def get_random_string(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str

parser = argparse.ArgumentParser()
parser.add_argument("--gamedir",default="/srv/minecraft",help="Directory where the game files are located")
parser.add_argument("--instdir",default="/srv/instance",help="Directory where the instance config is stored")
parser.add_argument("--version",default="fabric-1.16",help="The Minecraft version")
parser.add_argument("--username",default="",help="Mojang username")
parser.add_argument("--password",default="",help="Mojang password")
args = parser.parse_args().__dict__

username = get_random_string(8)
uuid = str(uuid.uuid3(uuid.NAMESPACE_DNS, username))
token = "abcdefghijklmnopqrstuvwxyz"

if not(args["username"] == ""):
    if not(args["password"] == ""):
        login_data = minecraft_launcher_lib.account.login_user(args["username"],args["password"])
        if not("errorMessage" in login_data):
            username = login_data["selectedProfile"]["name"]
            uuid = login_data["selectedProfile"]["id"]
            token = login_data["accessToken"]


options = {
    "username": username,
    "uuid": uuid,
    "token": token,
    "launcherName": "mclauncher-cmd",
    "launcherVersion": "1.0",
    "demo": "false",
    "gameDirectory": str(args["instdir"]),
    "jvmArguments": ["-Xms850M", "-Xmx850M"],
    "resolutionWidth": "20",
    "resolutionHeight": "20",
}

command = minecraft_launcher_lib.command.get_minecraft_command(str(args["version"]),str(args["gamedir"]),options)

subprocess.call(command)
