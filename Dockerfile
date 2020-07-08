FROM ubuntu:20.04

COPY setup/ /headless-mc-client/

WORKDIR /headless-mc-client

ENV USERNAME username
ENV PASSWORD password
ENV VERSION fabric-1.15.2
ENV PATH /root/.local/bin:$PATH
RUN apt-get update -y
RUN apt-get install python3 python3-pip openjdk-8-jdk-headless maven xvfb git -y
RUN ./setup.sh

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; minecraft-launcher-cmd --version $VERSION --minecraftDir "/headless-mc-client/minecraft" --gameDir "/headless-mc-client/instance" --resolutionWidth 1 --resolutionHeight 1 --username $USERNAME --password $PASSWORD