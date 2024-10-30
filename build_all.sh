#!/usr/bin/bash

# This script is meant to allow to build all the artifacts needed for this demo
# in a simple manner locally.
# It assumes the following packages are available on the system:
# podman skopeo ostree python3-yaml uuidgen (uuid-runtime on ubuntu) git jq
# tree ostree
#
# Usage: build_all.sh

set -e
#set -x

ARCH=$(arch)
REMOTE_REGISTRY=false
TARGET=${TARGET:-qemu}
EXPORT=${EXPORT:-qcow2}
MODE=${MODE:-image}

echo "Cleaning up all .artifact files"
rm -f *.artifact

# Build all the container images
echo "====================================================================="
echo "Building the different container images"
echo "====================================================================="
echo ""

for container in can-utils validator; do
  podman build --platform linux/$ARCH -t localhost/$container:latest -f containers/Containerfile.$container .
done

# Build the OS images
echo "====================================================================="
echo "Building the OS (qcow2) images"
echo "====================================================================="
echo ""

./images/create-images.sh autosd9 $TARGET $MODE $EXPORT

