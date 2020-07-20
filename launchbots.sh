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

PORT=10000
rm docker-compose.yml
echo 'version: "3"
services:' >> docker-compose.yml && \
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