FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as fabritone-build

COPY fabritone /srv/headlessmcgit/fabritone

WORKDIR /srv/headlessmcgit/fabritone
RUN sh gradlew build


FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as headlessapi-build

COPY headless-api-mod /srv/headlessmcgit/headless-api-mod

WORKDIR /srv/headlessmcgit/headless-api-mod
RUN sh gradlew build


FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /
COPY --from=fabritone-build /srv/headlessmcgit/fabritone/build/libs/fabritone-1.5.3.jar /srv/mods/fabritone-1.5.3.jar
COPY --from=headlessapi-build /srv/headlessmcgit/headless-api-mod/build/libs/headless-api-1.0.0.jar /srv/mods/headless-api-1.0.0.jar
COPY setup /srv/setup

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip3 install minecraft-launcher-cmd && \
    rm -rf /var/lib/apt/lists/*

ENV USERNAME="username" \
    PASSWORD="password"

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    /srv/setup/setup.sh; \
    minecraft-launcher-cmd \
    --version "fabric-1.15.2" \
    --resolutionWidth 10 \
    --resolutionHeight 10 --username "$USERNAME" \
    --minecraftDir /srv/minecraft \
    --gameDir /srv/instance \
    --password "$PASSWORD" \
    --jvmArguments="-Xms512M -Xmx1024M"
