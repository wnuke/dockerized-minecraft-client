#!/usr/bin/env python3
import minecraft_launcher_lib
import subprocess
import argparse
import uuid

parser = argparse.ArgumentParser()
parser.add_argument("--username",required=True,help="Your mojang username")
parser.add_argument("--password",help="Your mojang password")
parser.add_argument("--version",default=minecraft_launcher_lib.utils.get_latest_version()["release"],help="The Minecraft version")
args = parser.parse_args().__dict__

print("Downloading Minecraft...")
minecraft_launcher_lib.install.install_minecraft_version(args["version"],'/srv/minecraft',callback={"setStatus":print})
print("Minecraft downloaded.")

if args["password"]:
    login_data = minecraft_launcher_lib.account.login_user(args["username"],args["password"])

username = ''
userid = ''
usertoken = ''

if "errorMessage" in login_data:
    print(login_data["errorMessage"])
    userid = uuid.uuid4()
    username = args["username"]
    usertoken = '0'
else:
    userid = login_data['selectedProfile']['id']
    username = login_data['selectedProfile']['name']
    usertoken = login_data['accessToken']

options = {
    "username": username,
    "uuid": userid,
    "token": usertoken,
    "launcherName": "mclauncher-cmd",
    "launcherVersion": "1.0",
    "demo": "false",
    "gameDirectory": "/srv/instance",
    "jvmArguments": ["-Xms512M", "-Xmx1024M"],
    "resolutionWidth": "20",
    "resolutionHeight": "20",
}

command = minecraft_launcher_lib.command.get_minecraft_command(args["version"],"/srv/minecraft",options)

subprocess.call(command)
