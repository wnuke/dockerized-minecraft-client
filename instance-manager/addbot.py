#!/usr/bin/env python3
import docker
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--username",default="",help="Mojang username")
parser.add_argument("--password",default="",help="Mojang password")
args = parser.parse_args().__dict__

client = docker.from_env()

client.containers.run('dockermcbot', environment=["USERNAME=" + args["username"], "PASSWORD=" + args["password"]], detach=True)