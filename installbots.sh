#!/usr/bin/env sh

export NUMBEROFBOTS=$1
if [ -z $NUMBEROFBOTS ]; then
  NUMBEROFBOTS=1
fi

git submodule update --init && \
  cd setup || (echo "Setup directory does not exist, exiting..." && exit); \
  docker build . -t dockermcinstall:latest && \
  docker volume create minecraft && \
  docker run -v minecraft:/srv/minecraft dockermcinstall:latest && \
  cd ../bot || (echo "Bot directory does not exist, exiting..." && exit);
  docker build . -t dockermcbot:latest && \
  cd .. && \
  docker-compose up
