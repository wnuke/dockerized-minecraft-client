#!/usr/bin/env bash

git submodule update --init && \
  cd setup || (echo "Setup directory does not exist, exiting..." && exit); \
  docker build . -t dockermcinstall:latest && \
  docker volume create minecraft && \
  docker run -v minecraft:/srv/minecraft dockermcinstall:latest && \
  cd ../bot || (echo "Bot directory does not exist, exiting..." && exit); \
  docker build . -t dockermcbot:latest
