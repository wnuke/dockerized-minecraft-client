[![Discord](https://img.shields.io/discord/745728805678874800?logo=discord)](https://discord.gg/MwBvhEz)
[![build](https://github.com/wnuke-dev/dockerized-minecraft-client/workflows/Docker%20Image%20CI/badge.svg)]((https://github.com/wnuke-dev/dockerized-minecraft-client/actions?query=workflow%3A%22Docker%20Image%20CI%22))
# Docker MC

Docker MC is a Dockerized version of Minecraft, uses mc-http-api as to cancel render and resource loading to imnprove performance and allow the instance manager to control it via a REST API.

## Developement Setup

Get access to the repo by asking wnuke (wnuke#1010 on Discord).
Download the source code:

- `git clone git@github.com:wnuke-dev/dockerized-minecraft-client`
- `cd dockerized-minecraft-client`
- `git submodule update --init`

If you do not have an IDE you should download one, I recommend [IntelliJ IDEA CE](https://www.jetbrains.com/idea/).

Install docker from here: https://www.docker.com/get-started

For the individual modules (the instance manager and the http api) check the README in their respective repositories.

## Building And Running the Docker Image

**NOTE:** I highly recommend using the instance manager as it provides a CLI for building and controlling instances using the REST API.

Follow the steps in **Developement Setup** then run the following commands:

- `cd bot`
- `docker build . -t docker-mc:latest`
- `docker run --rm --name docker-mc -p 8000:8000 docker-mc:latest`

Now you can send API requests to `localhost:8000` to control the instance of Docker MC, I recommend using a program like cURL to do so.
For example, to login to a Minecraft account, connect to a server and say "Hello!":
```bash 
# Tell the client to get an auth token from mojang for the user "wnuke" with password "password"
curl -v -H "Content-Type:application/json" -X POST -d "{\"username\":\"wnuke\",\"password\":\"password\"}" localhost:8000/login
# Tell the client to connect to server with address "mc.blazenarchy.net" on port 25565
curl -v -H "Content-Type:application/json" -X POST -d "{\"address\":\"mc.blazenarchy.net\",\"port\":\"25565\"}" localhost:8000/connect
# Tell the client to send a chat message with content "Hello!" to the server it is currently connected to
curl -v -H "Content-Type:application/json" -X POST -d "{\"message\":\"Hello!\"}" localhost:8000/sendmsg
```
