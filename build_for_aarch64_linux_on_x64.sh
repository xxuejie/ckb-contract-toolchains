#!/bin/bash
set -ex

# This scripts builds the Rust distribution on Linux x64 instances
# for aarch64 Linux. Typically this is built on Ubuntu 22.04

if [ "x$OPENSSL_AARCH64" = "x" ]
then
  echo "Please set the OPENSSL_AARCH64 environment variable!"
  exit 1
fi

VERSION=$(cat version)

SKIP_GIT=$1

if [ "x$SKIP_GIT" != "xtrue" ]
then
  ./check_git.sh true
fi

export OPENSSL_STATIC=1
export OPENSSL_INCLUDE_DIR=${OPENSSL_AARCH64}/include
export OPENSSL_LIB_DIR=${OPENSSL_AARCH64}

if [ "x$CC_aarch64_unknown_linux_gnu" = "x" ]
then
  export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
fi
if [ "x$CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER" = "x" ]
then
  export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
fi

./build_rust.sh ${VERSION} true aarch64-unknown-linux-gnu
