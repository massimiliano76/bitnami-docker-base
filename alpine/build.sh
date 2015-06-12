#!/bin/sh

VERSION=1.0
docker build -t bitnami/pineapple:build .
docker run --name pineapple-$VERSION bitnami/pineapple:build sh
docker export pineapple-$VERSION | docker import - bitnami/pineapple:$VERSION
docker tag bitnami/pineapple:$VERSION bitnami/pineapple:latest
docker rm pineapple-$VERSION
