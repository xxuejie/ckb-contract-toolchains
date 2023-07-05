#!/bin/bash
set -ex

# This scripts builds the Rust distribution on macOS m1/m2 instances
# for both Intel and Apple Silicon macs

if [ "x$OPENSSL_X64" = "x" ]
then
  echo "Please set the OPENSSL_X64 environment variable!"
  exit 1
fi

VERSION=$1

# 11.0 is the first macOS version supporting Apple Silicon
export MACOSX_STD_DEPLOYMENT_TARGET=11.0
export MACOSX_DEPLOYMENT_TARGET=11.0
./build_rust.sh ${VERSION} true

export MACOSX_STD_DEPLOYMENT_TARGET=10.7
export MACOSX_DEPLOYMENT_TARGET=10.7
export OPENSSL_STATIC=1
export OPENSSL_INCLUDE_DIR=${OPENSSL_X64}/include
export OPENSSL_LIB_DIR=${OPENSSL_X64}
./build_rust.sh ${VERSION} true x86_64-apple-darwin