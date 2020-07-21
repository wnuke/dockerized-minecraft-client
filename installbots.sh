#!/usr/bin/env bash

git submodule update --init && \
  cd bot || (echo "Bot directory does not exist, exiting..." && exit); \
  docker build . -t dockermcbot:latest
