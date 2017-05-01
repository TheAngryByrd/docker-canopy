#!/usr/bin/env bash


mono .paket/paket.exe restore
docker build -t docker-canopy .
docker run  docker-canopy