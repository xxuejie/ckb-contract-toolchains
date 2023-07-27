#!/bin/bash
set -ex

# This script builds openssl for both Intel and Apple Silicon macs

# Note this script works on current directory instead of directory
# containing the shell script.

VERSION="openssl-1.1.1u"

curl -LO https://www.openssl.org/source/${VERSION}.tar.gz
tar xzf ${VERSION}.tar.gz
mv ${VERSION} ${VERSION}-arm64
tar xzf ${VERSION}.tar.gz
mv ${VERSION} ${VERSION}-x64

# 11.0 is the first macOS version supporting Apple Silicon
export MACOSX_STD_DEPLOYMENT_TARGET=11.0
export MACOSX_DEPLOYMENT_TARGET=11.0
cd ${VERSION}-arm64
./Configure darwin64-arm64-cc
make -j$(nproc)
cd ..

export MACOSX_STD_DEPLOYMENT_TARGET=10.7
export MACOSX_DEPLOYMENT_TARGET=10.7
cd ${VERSION}-x64
./Configure darwin64-x86_64-cc
make -j$(nproc)
cd ..

CURRENT_DIR=$(pwd)

echo "Use the following lines to configure openssl:"
echo "export OPENSSL_AARCH64=${CURRENT_DIR}/${VERSION}-arm64"
echo "export OPENSSL_X64=${CURRENT_DIR}/${VERSION}-x64"
