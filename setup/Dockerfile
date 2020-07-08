FROM java:8

COPY . /home/root/java/setup
WORKDIR /home/root/java/setup

RUN apt-get install python3 python3-pip
RUN apt-get install mesa-common-dev libosmesa6-dev libglu1-mesa-dev
RUN ./setup.sh

ENTRYPOINT ["minecraft-launcher-cmd", "--version", "fabric-1.15.2", "--minecraftDir", "/home/root/java/setup/minecraft", "--resolutionWidth", "1", "--resolutionHeight", "1", "--username", "$USERNAME", "--password", "$PASSWORD"]