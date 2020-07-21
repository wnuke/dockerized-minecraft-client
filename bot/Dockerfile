FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as faritone-build

COPY "fabritone" "/srv/fabritone"

WORKDIR "/srv/fabritone"
RUN sh gradlew build

FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as mchttpapi-build

WORKDIR "/srv/mc-http-api"
COPY "mc-http-api/gradle" "/srv/mc-http-api/gradle"
COPY "mc-http-api/build.gradle" "mc-http-api/settings.gradle" "mc-http-api/gradle.properties" "mc-http-api/gradlew" "/srv/mc-http-api"/

RUN sh gradlew build

COPY "mc-http-api/src" "/srv/mc-http-api/src"
RUN sh gradlew build

FROM python:3.8-slim as download-mc

ENV GAMEVER="fabric-1.16" \
    BASEVER="1.16.1"

RUN pip3 install minecraft-launcher-lib requests

COPY download_mc.py /srv/download_mc.py

RUN python /srv/download_mc.py --version=$BASEVER --directory=/srv/minecraft

COPY fabric-1.16.json /srv/minecraft/versions/fabric-1.16/fabric-1.16.json

RUN python /srv/download_mc.py --version=$BASEVER --directory=/srv/minecraft

FROM alpine:latest as setupmc

COPY --from=download-mc "/srv/minecraft" "/srv/minecraft"
COPY --from=faritone-build "/srv/fabritone/build/libs/fabritone-1.5.3.jar" "/srv/instance/mods/fabritone-1.5.3.jar"
COPY --from=mchttpapi-build "/srv/mc-http-api/build/libs/mchttpapi-1.0.0.jar" "/srv/instance/mods/mchttpapi-1.0.0.jar"
COPY options.txt /srv/instance

COPY launch_mc.py start.sh /srv/

FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=python:3.8-slim / /

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip install minecraft-launcher-lib requests && \
    rm -rf /var/lib/apt/lists/*

ENV GAMEVER="fabric-1.16" \
    BASEVER="1.16.1" \
    USERNAME="" \
    PASSWORD=""

COPY launch_mc.py /srv/

COPY --from=setupmc /srv/minecraft /srv/instance /srv/

ENTRYPOINT rm /tmp/.X5-lock \
    & Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    cd /srv/minecraft && \
    python /srv/launch_mc.py \
      --version=$GAMEVER \
      --gamedir="/srv/minecraft" \
      --instdir="/srv/instance" \
      --username=$USERNAME \
      --password=$PASSWORD
