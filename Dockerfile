FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as faritone-build

COPY "faritone" "/srv/faritone"

WORKDIR "/srv/faritone"
RUN sh gradlew build

FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim as mchttpapi-build

COPY "gradle" "srv/mc-http-api/gradle"
COPY "build.gradle" "settings.gradle" "gradlew" "/srv/mc-http-api"/

WORKDIR "/srv/mc-http-api"
RUN sh gradlew build


FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip3 install minecraft-launcher-cmd requests && \
    rm -rf /var/lib/apt/lists/*

COPY "setup" "/srv/setup"
COPY --from=faritone-build "/srv/faritone/build/libs/fabritone-1.5.3.jar" "/srv/fabritone-1.5.3.jar"
COPY --from=mchttpapi-build "/srv/mc-http-api/build/libs/mchttpapi-1.0.0.jar" "/srv/mchttpapi-1.0.0.jar"

ENV USERNAME="username" \
    PASSWORD="password"

ENTRYPOINT rm /tmp/.X5-lock \
    & Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    if sh /srv/setup/start.sh; \
    then echo "Minecraft launched successfully." \
    else sh /srv/setup/setup.sh \
    & sh /srv/setup/start.sh; fi