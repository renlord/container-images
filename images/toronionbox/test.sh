#!/bin/bash

# test the image locally
IMAGE_NAME=ghcr.io/renlord/onionbox

podman run -v ./config.sample/theonionbox.cfg:/config/theonionbox.cfg:ro -v ./config.sample/torrc:/config/torrc:ro -p 8080 -it $IMAGE_NAME:latest /entrypoint.sh
