FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as baritone-build

COPY "baritone" "/srv/baritone"

WORKDIR "/srv/baritone"
RUN sh gradlew build


FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip3 install minecraft-launcher-cmd && \
    rm -rf /var/lib/apt/lists/*

COPY "setup" "/srv/setup"
COPY --from=baritone-build "/srv/baritone/build/libs/baritone-api-1.5.3.jar" "/srv/baritone-api-1.5.3.jar"

ENV USERNAME="username" \
    PASSWORD="password"

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    "/srv/setup/setup.sh"; \
    minecraft-launcher-cmd \
    --version "1.15.2-Baritone" \
    --resolutionWidth 10 \
    --resolutionHeight 10 --username "$USERNAME" \
    --minecraftDir "/srv/minecraft" \
    --gameDir "/srv/instance" \
    --password "$PASSWORD" \
    --jvmArguments="-Xms512M -Xmx1024M"