#!/usr/bin/env bash

IMAGE_NAME=segence/apache-drill
VERSION=$(cat version.txt)

docker build -t $IMAGE_NAME:$VERSION .
docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest
