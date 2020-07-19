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


FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip3 install minecraft-launcher-lib requests && \
    rm -rf /var/lib/apt/lists/*

COPY "setup" "/srv/setup"
COPY --from=faritone-build "/srv/fabritone/build/libs/fabritone-1.5.3.jar" "/srv/setup/fabritone-1.5.3.jar"
COPY --from=mchttpapi-build "/srv/mc-http-api/build/libs/mchttpapi-1.0.0.jar" "/srv/setup/mchttpapi-1.0.0.jar"

ENV GAMEDIR="/srv/minecraft" \
    INSTDIR="/srv/instance" \
    SETUPDIR="/srv/setup" \
    GAMEVER="fabric-1.16" \
    BASEVER="1.16.1"

ENTRYPOINT rm /tmp/.X5-lock \
    & Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    bash /srv/setup/setup.sh