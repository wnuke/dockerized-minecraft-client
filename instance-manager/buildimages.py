#!/usr/bin/env python3
import docker
import argparse

client = docker.from_env()

client.images.build(path="../bot/", tag="mcbot")
