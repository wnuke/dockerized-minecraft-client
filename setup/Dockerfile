FROM ubuntu:20.04

COPY minecraft /srv/minecraft

WORKDIR /srv/minecraft

ENV USERNAME username
ENV PASSWORD password
RUN apt-get update -y
RUN apt-get install python3 python3-pip openjdk-8-jdk-headless -y
RUN pip3 install minecraft-launcher-cmd
RUN apt-get install mesa-common-dev libosmesa6-dev libglu1-mesa-dev -y

ENTRYPOINT minecraft-launcher-cmd --version "fabric-1.15.2" --minecraftDir "/srv/minecraft" --gameDir "/srv/minecraft" --resolutionWidth 1 --resolutionHeight 1 --username $USERNAME --password $PASSWORD