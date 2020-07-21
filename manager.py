#!/usr/bin/env python3
import argparse
import docker
import requests
import sys
import timeit
import traceback
import urllib3
from cmd import Cmd

parser = argparse.ArgumentParser()
parser.add_argument("--dir", default="bot", help="Directory to find the bot Dockerfile in.")
execargs = parser.parse_args().__dict__
client = docker.from_env()

instances = []
usedports = []


def build_image():
    print("Building Docker images, this may take a while...")
    elapsed_time = timeit.timeit(client.images.build(path=execargs["dir"], tag="dockermcbot:latest"),
                                 number=1) / 1000000
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
    usedports.remove(10000 + instance[3])
    instances.remove(instance)


def cleanup():
    print("Closing all instances...")
    instances_to_remove = []
    for i in instances:
        print("removing instance #" + str(i[3]) + "...")
        instances_to_remove.append(i)
    for i in instances_to_remove:
        remove_instance(i)
    client.close()


def send_message(botaddress, botport, message):
    requests.post(botaddress + str(botport) + "/sendmsg", json={'message': str(message)})


def connect_to_server(botaddress, botport, address, port):
    requests.post(botaddress + str(botport) + "/connect", json={'address': str(address), 'port': str(port)})


default_bot_address = 'http://localhost:'


class MyPrompt(Cmd):
    prompt = 'bot-manager > '

    def do_exit(self, inp):
        cleanup()
        print("Done, exiting...")
        return True

    def help_exit(self):
        print("Destroys all instances of the bot and exits.")

    def do_build(self, inp):
        build_image()

    def help_build(self):
        print("Builds the Docker image for the bot.")

    def do_add(self, inp):
        create_instance(inp.split(" "))

    def help_add(self):
        print("Creates a single instance of the bot, with username and password as optional arguments.")

    def do_madd(self, inp):
        if not (len(inp) < 1 or not (inp.isnumeric())):
            for i in range(int(inp)):
                create_instance([])

    def help_madd(self):
        print(
            "Creates a specified number fo instances of the bot, requires the desired number of instances as an argument.")

    def do_list(self, inp):
        for i in instances:
            print(instance_string(i))

    def help_list(self):
        print("Lists all instances of the bot.")

    def do_del(self, inp):
        if len(inp) < 1 or not (inp.isnumeric()):
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

    def help_del(self):
        print("Deletes the specified instance of the bot, requires the id of the bot to remove.")

    def do_mdel(self, inp):
        args = inp.split(" ")
        if (len(args) < 2) and (
                (len(args[0]) > 0 or not (args[0].isnumeric())) and (len(args[1]) > 0 or not (args[1].isnumeric()))):
            print("Requires two numeric arguments.")
        else:
            for i in instances:
                if i[3] in range(int(args[0]), int(args[1])):
                    print("closing instance #" + str(i[3]))
                    remove_instance(i)

    def help_mdel(self):
        print("Deletes all bots who's ids are in a given range, requires 2 numbers as arguments.")

    def do_message(self, inp):
        args = inp.split(" ", 1)
        if (len(args) < 2) and (
                (len(args[0]) > 0 or not (args[0].isnumeric())) and len(args[1]) > 0):
            print("Requires one numeric argument followed by strings.")
        else:
            for i in instances:
                if i[3] == int(args[0]):
                    print("sending \"" + args[1] + "\" from instance #" + str(i[3]))
                    send_message(default_bot_address, 10000 + i[3], args[1])

    def help_message(self):
        print("Tells an instance of the bot to type a message in the chat box and press enter.")

    def do_mmessage(self, inp):
        args = inp.split(" ", 2)
        if (len(args) < 2) and (
                (len(args[0]) > 0 or not (args[0].isnumeric())) and (
                len(args[1]) > 0 or not (args[1].isnumeric())) and len(args[2]) > 0):
            print("Requires two numeric arguments followed by strings.")
        else:
            for i in instances:
                if i[3] in range(int(args[0]), int(args[1])):
                    print("sending from instance #" + str(i[3]))
                    send_message(default_bot_address, 10000 + i[3], args[2])

    def help_mmessage(self):
        print("Tells all instances of the bot in a range of ids to type a message in the chat box and press enter.")

    def do_connect(self, inp):
        args = inp.split(" ")
        if (len(args) < 2) and (
                (len(args[0]) > 0 or not (args[0].isnumeric())) and len(args[1]) > 0):
            print("Requires one numeric argument followed by a string optionally followed by a numeric argument.")
        else:
            port = "25565"
            if len(args) > 2 and (len(args[2]) > 0 or not (args[2].isnumeric())):
                port = args[2]
            for i in instances:
                if i[3] == int(args[0]):
                    print("connecting instance #" + str(i[3]) + " to " + args[1] + ":" + port)
                    connect_to_server(default_bot_address, 10000 + i[3], args[1], port)

    def help_connect(self):
        print("Tells an instance of the bot to try to connect to a server.")

    def do_mconnect(self, inp):
        args = inp.split(" ")
        if (len(args) < 3) and (
                (len(args[0]) > 0 or not (args[0].isnumeric())) and len(args[1]) > 0 or not (
                args[1].isnumeric()) and len(args[2]) > 0):
            print("Requires two numeric arguments followed by a string optionally followed by a numeric argument.")
        else:
            port = "25565"
            if len(args) > 3 and (len(args[3]) > 0 or not (args[3].isnumeric())):
                port = args[3]
            for i in instances:
                if i[3] in range(int(args[0]), int(args[1] + 1)):
                    print("connecting instance #" + str(i[3]) + " to " + args[2] + ":" + port)
                    connect_to_server(default_bot_address, 10000 + i[3], args[2], port)

    def help_mconnect(self):
        print("Tells all instances of the bot in a range of ids to try to connect to a server.")

    def do_prune(self, inp):
        print("Removing failed instances...")
        for i in instances:
            if i[0].status == "exited":
                i[0].remove(force=True)
                instances.remove(i[0])
        print("Failed instances removed.")

    def help_prune(self):
        print("Deletes all stopped instances of the bot.")


def main():
    try:
        MyPrompt().cmdloop()
    except ValueError:
        print("Invalid argument.")
    except IndexError:
        print("Not enough arguments.")
    except requests.ConnectionError:
        print("Bot encountered an error.")
    except urllib3.exceptions.ProtocolError:
        print("Network error.")
    except TypeError:
        print("Invalid argument.")
    main()


try:
    print("Welcome! ? to list commands.")
    main()
except KeyboardInterrupt:
    print("Keyboard interrupt...")
except Exception:
    traceback.print_exc(file=sys.stdout)
cleanup()
sys.exit(0)
