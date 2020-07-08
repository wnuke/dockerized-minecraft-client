FROM java:8

COPY . /home/root/java/setup
WORKDIR /home/root/java/setup

RUN apt-get install python3 python3-pip
RUN pip install minecraft-launcher-cmd
RUN apt-get install mesa-common-dev libosmesa6-dev libglu1-mesa-dev

ENTRYPOINT ["minecraft-launcher-cmd", "--version", "fabric-1.15.2", "--minecraftDir", "/home/root/java/setup/minecraft", "--gameDir", "/home/root/java/setup/instance", "--resolutionWidth", "1", "--resolutionHeight", "1", "--username", "$USERNAME", "--password", "$PASSWORD"]