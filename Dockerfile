### 1. Get Linux
FROM adoptopenjdk/openjdk8:jdk8u252-b09-alpine-slim

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add bash \
&& apk add --virtual=build-dependencies unzip \
&& apk add curl \
&& apk add git \
&& apk add xvfb \
&& apk add maven

### 3. Get Python, PIP
RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache

RUN pip install minecraft-launcher-cmd minecraft-launcher-lib

ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
ENV USERNAME="username"
ENV PASSWORD="password"
ENV VERSION="fabric-1.15.2"

EXPOSE 8000
COPY . /srv/headlessmcgit
WORKDIR /srv/headlessmcgit
RUN ["git", "submodule", "update"]
RUN ["bash", "gradlew", "build"]
WORKDIR /srv/headlessmcgit/fabritone
RUN ["bash", "gradlew", "build"]
WORKDIR /srv/headlessmcgit/setup
RUN ["python", "install_mc.py"]
RUN ["bash", "setup.sh"]
RUN ["mv", "minecraft", "/srv/minecraft"]
RUN ["mv", "instance", "/srv/instance"]

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; minecraft-launcher-cmd --version $VERSION --minecraftDir "/srv/minecraft" --gameDir "/srv/instance" --resolutionWidth 10 --resolutionHeight 10 --username $USERNAME --password $PASSWORD
