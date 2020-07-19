FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

COPY --from=iamjohnnym/bionic-python:3.7 / /

RUN apt-get update -y && \
    apt-get install --no-install-recommends xvfb -y && \
    pip3 install minecraft-launcher-lib requests && \
    rm -rf /var/lib/apt/lists/*

ENV GAMEVER="fabric-1.16" \
    BASEVER="1.16.1"

COPY launch_mc.py /srv/launch_mc.py
COPY start.sh /srv/start.sh

ENTRYPOINT rm /tmp/.X5-lock \
    & Xvfb :5 -screen 0 100x100x24 \
    & export DISPLAY=:5; \
    bash /srv/start.sh
