#!/usr/bin/env python3
import argparse
import docker
import timeit
from cmd import Cmd

parser = argparse.ArgumentParser()
parser.add_argument("--dir", default="bot", help="Directory to find the bot Dockerfile in.")
args = parser.parse_args().__dict__
client = docker.from_env()

instances = []
usedports = []


def build_image():
    print("Building Docker images, this may take a while...")
    elapsed_time = timeit.timeit(client.images.build(path=args["dir"], tag="dockermcbot:latest"), number=1) / 1000000
    print("Done building images! It took: " + elapsed_time + "s")


def create_instance(args):
    username = ""
    if len(args) > 0:
        username = args[0]
    password = ""
    if len(args) > 1:
        password = args[1]
    print("Creating another instance of the bot...")
    try:
        instances.append([client.containers.run('dockermcbot:latest',
                                                environment=["USERNAME=" + username, "PASSWORD=" + password],
                                                ports={'8000/tcp': 10000 + len(usedports)},
                                                hostname="dockermcbotinst-" + str(len(instances)), detach=True),
                          username, password, len(instances)])
        usedports.append(10000 + len(usedports))
        print("Created another instance of the bot.")
    except docker.errors.APIError:
        print("Failed to create docker container.")


def instance_string(instance):
    userstring = ""
    if not (instance[1] == ""):
        userstring += ", username " + instance[1]
        if not (instance[2] == ""):
            userstring += ", password " + instance[2]
    return "dockermcbotinst-" + str(instance[3]) + " (" + instance[0].status + "): port " + str(
        10000 + instance[3]) + userstring


def remove_instance(instance):
    instance[0].remove(force=True)
    instances.remove(instance)


class MyPrompt(Cmd):
    def do_exit(self, inp):
        print("Closing all instances...")
        for i in instances:
            print("removing instance #" + str(i[3]) + "...")
            remove_instance(i)
        client.close()
        print("Done, exiting...")
        return True

    def do_build(self, inp):
        build_image()

    def do_add(self, inp):
        create_instance(inp.split(" "))

    def do_addm(self, inp):
        if len(inp) > 0 or not (inp.isnumeric()):
            for i in range(int(inp)):
                create_instance([])

    def do_list(self, inp):
        for i in instances:
            print(instance_string(i))

    def do_del(self, inp):
        if len(inp) > 0 or not (inp.isnumeric()):
            found = False
            for i in instances:
                if i[3] == int(inp):
                    number = i[3]
                    print("Closing instance " + instance_string(i))
                    remove_instance(i)
                    print("Closed instance #" + str(number))
                    found = True
            if not found:
                print("No container with number " + inp)
        else:
            print("Requires a numeric argument.")

    def do_prune(self, inp):
        print("Removing failed instances...")
        for i in instances:
            if i[0].status == "exited":
                i[0].remove(force=True)
                instances.remove(i[0])
        print("Failed instances removed.")


MyPrompt().cmdloop()
