### 1. Get Linux
FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install bash xvfb -y

RUN pip3 install minecraft-launcher-cmd minecraft-launcher-lib

ENV USERNAME="username" \
    PASSWORD="password" \
    VERSION="fabric-1.15.2" \
    MCDIR="/srv/minecraft" \
    INSTDIR="/srv/instance"

COPY setup /srv/headlessmcgit/setup
WORKDIR /srv/headlessmcgit/setup
RUN ["bash", "setup.sh"]
COPY fabritone /srv/headlessmcgit/fabritone
WORKDIR /srv/headlessmcgit/fabritone
RUN ["sh", "gradlew", "--no-daemon", "build"]
RUN mkdir $INSTDIR \
    && mkdir $INSTDIR/mods && \
    mv build/libs/fabritone-1.5.3.jar $INSTDIR/mods/
COPY headless-api-mod /srv/headlessmcgit/headless-api-mod
WORKDIR /srv/headlessmcgit/headless-api-mod
RUN ["sh", "gradlew", "--no-daemon", "build"]
RUN ["mv", "build/libs/headless-api-1.0.0.jar", "$INSTDIR/mods/"]
WORKDIR /srv
RUN ["rm", "-rf", "/srv/headlessmcgit"]

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; minecraft-launcher-cmd --version "$VERSION" --minecraftDir "$MCDIR" --gameDir "$INSTDIR" --resolutionWidth 10 --resolutionHeight 10 --username "$USERNAME" --password "$PASSWORD"
