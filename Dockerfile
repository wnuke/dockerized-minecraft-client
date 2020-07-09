### 1. Get Ubuntu Bionic (18.04) with jdk 8
FROM adoptopenjdk:8u252-b09-jdk-hotspot-bionic

### 2. Get Python 3.7 for Ubuntu Bionic
COPY --from=iamjohnnym/bionic-python:3.7 / /

### 3-4. Get XVFB for headless render output
RUN apt-get update -y
RUN apt-get install xvfb -y

### 4. Install a command line Minecraft launcher
RUN pip3 install minecraft-launcher-cmd

### 5. Set default environement variables
ENV USERNAME="username" \
    PASSWORD="password" \
    VERSION="fabric-1.15.2" \
    MCDIR="/srv/minecraft" \
    INSTDIR="/srv/instance" \
    LAUNCHARGS=""

### 6. Get the setup files
COPY setup /srv/setup
RUN mkdir /srv/setup/mods
### 7. Get the Fabritone source files
COPY fabritone /srv/headlessmcgit/fabritone
RUN cp /srv/setup/gradle.properties /srv/headlessmcgit/fabritone/gradle.properties
### 8. Build the Fabritone jar
WORKDIR /srv/headlessmcgit/fabritone
RUN sh gradlew --no-daemon build
### 9. Move the Fabritone jar to the mods folder
RUN mv build/libs/fabritone-1.5.3.jar /srv/setup/mods/
### 10. Get the API mod files
COPY headless-api-mod /srv/headlessmcgit/headless-api-mod
RUN cp /srv/setup/gradle.properties /srv/headlessmcgit/headless-api-mod/gradle.properties
### 11. Build the API mod jar
WORKDIR /srv/headlessmcgit/headless-api-mod
RUN sh gradlew --no-daemon build
### 12. Move the API mod jar to the mods folder
RUN mv build/libs/headless-api-1.0.0.jar /srv/setup/mods/
### 13. Remove unneeded files
WORKDIR /srv
RUN rm -rf /srv/headlessmcgit

ENTRYPOINT Xvfb :5 -screen 0 100x100x24 & export DISPLAY=:5; /srv/setup/setup.sh; minecraft-launcher-cmd --version "$VERSION" --minecraftDir "$MCDIR" --gameDir "$INSTDIR" --resolutionWidth 10 --resolutionHeight 10 --username "$USERNAME" --password "$PASSWORD" $LAUNCHARGS
