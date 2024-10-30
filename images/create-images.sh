#!/bin/bash
# usage: ./create-images.sh <distro> <target> <mode> <export>

set -x

mkdir _build

distro=$1
target=$2
mode=$3
export=$4

aib=$(mktemp -d --suffix=-aib)
wd=$(pwd)
build=$wd/_build
ostree_repo=$wd/_ostree

# Retrieve the tools we need
git clone https://gitlab.com/CentOS/automotive/src/automotive-image-builder.git $aib

# This doesn't quite seem to work atm
#curl -o $aib/automotive-image-builder \
    #"https://gitlab.com/CentOS/automotive/sample-images/-/raw/main/auto-image-builder.sh?inline=false"

# Build the base image
# sudo sh $aib/automotive-image-builder \

# Build the base image
$aib/automotive-image-builder \
    --verbose \
    --container \
    --include=/var/lib/containers/storage/ \
    build \
    --distro $distro \
    --target $target \
    --mode $mode \
    --arch $(arch) \
    --build-dir=$build \
    --ostree-repo=$ostree_repo \
    --cache-max-size=1GB \
    --export $export \
    --osbuild-manifest=$build/$distro-$target-$mode.$(arch).json \
    $wd/images/base.mpp.yml \
    $wd/$distro-$target-$mode.$(arch)-base.$export

# /!\ "--include=/var/lib/containers/storage/" is required to have the
# local container images available in the container
