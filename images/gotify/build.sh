#!/usr/bin/env bash

ARCHS=("arm32v7" "arm64v8" "amd64")
GOARCHS=("arm" "arm64" "")
OCI_ARCHS=("armhf" "arm64" "")
OCI_VARIANTS=("v7" "v8" "")


IMAGE_NAME=ghcr.io/renlord/gotify
VERSION="2.0.22"

bail() {
    echo "$1"
    exit 1
}

echo "download source"
wget -4 https://github.com/gotify/server/archive/v$VERSION.tar.gz
bsdtar xf v$VERSION.tar.gz
rm v$VERSION.tar.gz

SRCDIR=server-$VERSION

podman image rm $IMAGE_NAME:latest
podman image rm $IMAGE_NAME:$VERSION
podman manifest create $IMAGE_NAME
i=0
for ARCH in "${ARCHS[@]}"; do
    echo "BUILDING FOR $ARCH using ${GOARCHS[$i]}"
    cd $SRCDIR
    rm -f server
    GOOS=linux CGO=disable GOARCH=${GOARCHS[$i]} go build
    cd -
    DOCKER_IMAGE="$IMAGE_NAME:$ARCH"
    podman build --no-cache --squash --build-arg ARCH="$ARCH" --build-arg GOBIN="$SRCDIR/server" . -t "$DOCKER_IMAGE" || bail "fail build for arch $ARCH"
    podman push $DOCKER_IMAGE
    ((i+=1))
done

podman manifest create $IMAGE_NAME && \
    podman manifest add --arch arm64 --os linux --variant v8 $IMAGE_NAME $IMAGE_NAME:arm64v8 && \
    podman manifest add --arch arm --variant v7 --os linux $IMAGE_NAME $IMAGE_NAME:arm32v7 && \
    podman manifest add $IMAGE_NAME $IMAGE_NAME:amd64 && \
    # docker prefers v2s2 manifest format over oci.
    podman manifest push --format v2s2 --all $IMAGE_NAME docker://$IMAGE_NAME:latest && \
    podman manifest push --format v2s2 --all --purge $IMAGE_NAME docker://$IMAGE_NAME:$VERSION

rm -rf $SRCDIR

echo "DONE -- $IMAGE_NAME"
