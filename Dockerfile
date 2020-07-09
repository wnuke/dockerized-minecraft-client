### 1. Get Linux
FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y \
&& apt-get install bash xvfb -y

RUN pip3 install minecraft-launcher-cmd minecraft-launcher-lib

ENV USERNAME="username"
ENV PASSWORD="password"
ENV VERSION="fabric-1.15.2"
ENV MCDIR="/srv/minecraft"
ENV INSTDIR="/srv/instance"

COPY setup /srv/headlessmcgit/setup
WORKDIR /srv/headlessmcgit/setup
RUN ["bash", "setup.sh"]
WORKDIR /srv/headlessmcgit
RUN ["bash", "buildmods.sh"]
WORKDIR /srv
RUN ["rm", "-rf", "/srv/headlessmcgit"]

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; minecraft-launcher-cmd --version "$VERSION" --minecraftDir "$MCDIR" --gameDir "$INSTDIR" --resolutionWidth 10 --resolutionHeight 10 --username "$USERNAME" --password "$PASSWORD"
