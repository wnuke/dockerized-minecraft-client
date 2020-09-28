FROM gradle:latest as faritone-build

COPY "fabritone" "/srv/fabritone"

WORKDIR "/srv/fabritone"
RUN gradle build


FROM gradle:latest as mchttpapi-build

WORKDIR "/srv/mc-http-api"
COPY "mc-http-api/gradle" "/srv/mc-http-api/gradle"
COPY "mc-http-api/build.gradle.kts" "mc-http-api/settings.gradle.kts" "mc-http-api/gradlew" "/srv/mc-http-api"/

RUN gradle build

COPY "mc-http-api/src" "/srv/mc-http-api/src"
RUN gradle build


FROM python:3.8-slim as getmc

ENV GAMEVER="fabric-1.16" \
    BASEVER="1.16.1"

RUN pip3 install minecraft-launcher-lib requests

COPY download_mc.py /srv/download_mc.py

RUN python /srv/download_mc.py --version=$BASEVER --directory=/srv/minecraft

COPY $GAMEVER.json /srv/minecraft/versions/$GAMEVER/$GAMEVER.json

RUN python /srv/download_mc.py --version=$GAMEVER --directory=/srv/minecraft

COPY getlibs.py /srv/getlibs.py

RUN python /srv/getlibs.py /srv/minecraft/versions/$GAMEVER/$GAMEVER.json /srv/minecraft/libraries/

FROM alpine:latest as setupinstancedir

COPY --from=faritone-build "/srv/fabritone/build/libs/fabritone-1.5.3.jar" "/srv/instance/mods/fabritone-1.5.3.jar"
COPY --from=mchttpapi-build "/srv/mc-http-api/build/libs/mchttpapi-1.0.0.jar" "/srv/instance/mods/mchttpapi-1.0.0.jar"
COPY options.txt /srv/instance/options.txt


FROM debian:buster

RUN apt-get update && \
    apt-get install openjdk-11-jre-headless -y

COPY --from=python:3.8-slim / /

RUN apt-get install --no-install-recommends xvfb -y && \
    pip install minecraft-launcher-lib requests && \
    rm -rf /var/lib/apt/lists/*

ENV GAMEVER="fabric-1.16" \
    BASEVER="1.16.1" \
    USERNAME="" \
    PASSWORD=""

COPY launch_mc.py /srv/

COPY --from=getmc /srv/minecraft /srv/minecraft
COPY --from=setupinstancedir /srv/instance /srv/instance

WORKDIR /srv/instance

LABEL dockermcbot="true"
EXPOSE 8000

ENTRYPOINT rm /tmp/.X5-lock \
    & Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    python /srv/launch_mc.py \
      --version=$GAMEVER \
      --gamedir="/srv/minecraft" \
      --instdir="/srv/instance" \
      --username=$USERNAME \
      --password=$PASSWORD
