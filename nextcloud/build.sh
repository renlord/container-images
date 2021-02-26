#!/bin/bash

# This build routine uses systemd-binfmt to compile target architectures
# in their native containers emulated in amd64.

BASE_IMAGE=docker.io/library/nextcloud:apache
IMAGE_NAME=ghcr.io/renlord/nextcloud
VERSION=21
ARCHS=(arm64 arm amd64)

for arch in ${ARCHS[@]}; do
    echo "building for $arch"
    podman image rm -f $BASE_IMAGE
    if [ "$arch" == "arm" ]; then
        podman pull --override-arch "$arch" --override-variant v7 "$BASE_IMAGE"
    else
        podman pull --override-arch "$arch" "$BASE_IMAGE"
    fi
    podman build --no-cache -f Dockerfile . -t $IMAGE_NAME:$arch && \
        podman push $IMAGE_NAME:$arch
done

podman image rm $IMAGE_NAME

podman manifest create $IMAGE_NAME && \
    podman manifest add --arch arm64 --os linux --variant v8 $IMAGE_NAME $IMAGE_NAME:arm64 && \
    podman manifest add --arch arm --variant v7 --os linux $IMAGE_NAME $IMAGE_NAME:arm && \
    podman manifest add $IMAGE_NAME $IMAGE_NAME:amd64 && \
    # docker prefers v2s2 manifest format over oci.
    podman manifest push --format v2s2 --all $IMAGE_NAME docker://$IMAGE_NAME:latest && \
    podman manifest push --format v2s2 --all --purge $IMAGE_NAME docker://$IMAGE_NAME:$VERSION
echo "DONE"
