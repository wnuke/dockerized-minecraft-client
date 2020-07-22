#!/usr/bin/env python3
import argparse
import docker
import json
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


def create_container(args):
    return client.containers.run('dockermcbot:latest',
                                 environment=["USERNAME=" + args[0], "PASSWORD=" + args[1]],
                                 ports={'8000/tcp': 10000 + len(usedports)},
                                 hostname="dockermcbotinst-" + str(len(instances)), detach=True)


def create_instance(args):
    username = ""
    if len(args) > 0:
        username = args[0]
    password = ""
    if len(args) > 1:
        password = args[1]
    print("Creating another instance of the bot...")
    try:
        instances.append(
            [create_container([password, username]), username, password, len(instances), default_bot_address, False])
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


def instance_ready(instance):
    if "[main/INFO]: Created: 256x128x0 minecraft:textures/atlas/mob_effects.png-atlas".encode() in instance[0].logs():
        return True
    else:
        return False


def cleanup():
    print("Closing all instances...")
    instances_to_remove = []
    for i in instances:
        print("removing instance #" + str(i[3]) + "...")
        instances_to_remove.append(i)
    for i in instances_to_remove:
        remove_instance(i)
    client.close()


def get_player_stats(instance):
    return str(requests.get(str(instance[4]) + str(instance[3] + 10000) + "/player"))


def parse_player_stats(stats):
    if stats == "<Response [200]>":
        return "Player is null."
    else:
        stats_json = json.loads(stats)
        return stats_json['Username'] + "(" + stats_json["UUID"] + ")" + ":\n  Health: " + str(
            stats_json["Player"]["Health"]) + " (" + float(
            stats_json["Player"]["Health"]) / 2 + " hearts)\n  Hunger: " + str(
            stats_json["Player"]["Hunger"]) + " (" + float(
            stats_json["Player"]["Hunger"]) / 2 + " bars)\n  XYZ: " + str(
            stats_json["Coordinates"]["X"]) + " " + str(
            stats_json["Coordinates"]["Y"]) + " " + str(
            stats_json["Coordinates"]["Z"]) + "\n"


def connect_to_server(instance, address, port):
    if instance_ready(instance):
        if not instance[5] and get_player_stats(instance) == "<Response [200]>":
            requests.post(str(instance[4]) + str(instance[3] + 10000) + "/connect",
                          json={'address': str(address), 'port': str(port)})
            instance[5] = True
            return
        else:
            print("Bot is already cor has been onnected.")
    else:
        print("Bot not ready.")


def send_message(instance, message):
    if instance_ready(instance) and not get_player_stats(instance) == "<Response [200]>":
        requests.post(str(instance[4]) + str(instance[3] + 10000) + "/sendmsg",
                      json={'message': str(message)})
        return
    print("Bot not ready.")


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
            "Creates a specified number of instances of the bot, requires the desired number of instances as an "
            "argument.")

    def do_list(self, inp):
        for i in instances:
            print(instance_string(i))

    def help_list(self):
        print("Lists all instances of the bot.")

    def do_stats(self, inp):
        if len(inp) > 0 and (inp.isnumeric()):
            for i in instances:
                if i[3] == int(inp):
                    print("instance #" + str(i[3]) + " [" + parse_player_stats(get_player_stats(i)) + "]")
        else:
            print("Invalid argument, requires the id of the instance you would like to see the stats of.")

    def help_stats(self):
        print("Displays stats about the bot's player.")

    def do_del(self, inp):
        if len(inp) > 0 and (inp.isnumeric()):
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
                if i[3] in range(int(args[0]), int(args[1]) + 1):
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
                    send_message(i, args[1])

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
                    send_message(i, args[2])

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
                    connect_to_server(i, args[1], port)

    def help_connect(self):
        print("Tells an instance of the bot to try to connect to a server.")

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
