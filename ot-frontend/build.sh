#!/bin/bash

IMAGE_NAME=ghcr.io/renlord/owntracks-web
VERSION=v2.8.0
ARCHS="arm64v8 arm32v7 amd64"

SRCDIR=$(find . -maxdepth 1 ! -path . -type d)

for arch in ${ARCHS[@]}; do
    echo "building for $arch"
    podman build --build-arg "ARCH=$arch" --build-arg "VERSION=$VERSION" -f Dockerfile . -t $IMAGE_NAME:$arch && \
        podman push $IMAGE_NAME:$arch
done

podman image rm -f $IMAGE_NAME

podman manifest create $IMAGE_NAME && \
    podman manifest add --arch arm64 --os linux --variant v8 $IMAGE_NAME $IMAGE_NAME:arm64v8 && \
    podman manifest add --arch arm --variant v7 --os linux $IMAGE_NAME $IMAGE_NAME:arm32v7 && \
    podman manifest add $IMAGE_NAME $IMAGE_NAME:amd64 && \
    podman manifest push --format v2s2 --all $IMAGE_NAME docker://$IMAGE_NAME:latest && \
    podman manifest push --format v2s2 --all --purge $IMAGE_NAME docker://$IMAGE_NAME:$VERSION

echo "DONE -- $IMAGE_NAME"
