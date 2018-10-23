#!/bin/bash

set -e
shopt -s extglob

set -x

cd application
rm -rf ./!(.gitignore|.git|.|..)

RELEASE_DIR=".release/KendryteIDE/resources/app"
SOURCE_GLOB="!(node_modules*|.|..)"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*|Darwin*)
        cp ../../kendryte-ide/$RELEASE_DIR/$SOURCE_GLOB ./ -r
        ;;
    CYGWIN*)
        cp /cygdrive/x/kendryte-ide/$RELEASE_DIR/$SOURCE_GLOB ./ -r
        ;;
    MINGW*)
        cp /x/kendryte-ide/$RELEASE_DIR/$SOURCE_GLOB ./ -r
        ;;
    *)
        die "Error: Unknown platform: ${unameOut}"
esac


