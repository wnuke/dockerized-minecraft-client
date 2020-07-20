#!/usr/bin/env bash

NUMBEROFBOTS=$1
if [ -z $NUMBEROFBOTS ]; then
  NUMBEROFBOTS=1
fi

BOTCOMPTEMPLATE='  BOTNAME:
    image: dockermcbot:latest
    volumes:
      - minecraft:/srv/minecraft
    deploy:
      mode: global
    ports:
      - BOTPORT:8000'

git submodule update --init && \
  cd setup || (echo "Setup directory does not exist, exiting..." && exit); \
  #docker build . -t dockermcinstall:latest && \
  #docker volume create minecraft && \
  #docker run -v minecraft:/srv/minecraft dockermcinstall:latest && \
  cd ../bot || (echo "Bot directory does not exist, exiting..." && exit); \
  #docker build . -t dockermcbot:latest && \
  cd .. && \
  PORT=10000
  rm docker-compose.yml
  echo 'version: "3"
services:' >> docker-compose.yml
  for i in $(seq 0 $NUMBEROFBOTS);
  do
  PORT=$((PORT + 1))
  BOTCOMP=${BOTCOMPTEMPLATE//BOTNAME/mcbot$i}
  BOTCOMP=${BOTCOMP//BOTPORT/$PORT}
  echo "$BOTCOMP" >> docker-compose.yml
  done && \
  echo 'volumes:
  minecraft:
    external: true' >> docker-compose.yml && \
  docker-compose up
