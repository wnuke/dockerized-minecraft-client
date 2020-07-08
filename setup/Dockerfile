FROM ubuntu:20.04

COPY minecraft /srv/minecraft

WORKDIR /srv/minecraft

ENV USERNAME username
ENV PASSWORD password
ENV VERSION fabric-1.15.2
RUN apt-get update -y
RUN apt-get install python3 python3-pip openjdk-8-jdk-headless xvfb -y
RUN pip3 install minecraft-launcher-cmd

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; minecraft-launcher-cmd --version $VERSION --minecraftDir "/srv/minecraft" --gameDir "/srv/minecraft" --resolutionWidth 1 --resolutionHeight 1 --username $USERNAME --password $PASSWORD