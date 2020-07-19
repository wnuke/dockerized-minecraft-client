#!/usr/bin/env python3
import minecraft_launcher_lib
import subprocess
import argparse
import uuid

parser = argparse.ArgumentParser()
parser.add_argument("--username",required=True,help="Your mojang username")
parser.add_argument("--password",help="Your mojang password")
parser.add_argument("--gamedir",required=True,help="Directory where the game files are located")
parser.add_argument("--instdir",help="Directory where the instance config is stored")
parser.add_argument("--version",default=minecraft_launcher_lib.utils.get_latest_version()["release"],help="The Minecraft version")
parser.add_argument("--port",default="8000",help="Port the API server should listen on.")
args = parser.parse_args().__dict__

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
    "gameDirectory": args["instdir"],
    "jvmArguments": ["-Xms850M", "-Xmx850M", "-Dhttpapiserverport=" + args["port"]],
    "resolutionWidth": "20",
    "resolutionHeight": "20",
}

command = minecraft_launcher_lib.command.get_minecraft_command(args["version"],args["gamedir"],options)

subprocess.call(command)
