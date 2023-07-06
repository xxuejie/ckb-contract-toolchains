#!/bin/bash
set -ex

# This scripts builds the Rust distribution on Linux x64 instances
# for both x64 and aarch64 Linux

if [ "x$OPENSSL_AARCH64" = "x" ]
then
  echo "Please set the OPENSSL_AARCH64 environment variable!"
  exit 1
fi

VERSION=$1

./build_rust.sh ${VERSION} true

export OPENSSL_STATIC=1
export OPENSSL_INCLUDE_DIR=${OPENSSL_AARCH64}/include
export OPENSSL_LIB_DIR=${OPENSSL_AARCH64}
export CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
export CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc
./build_rust.sh ${VERSION} true aarch64-unknown-linux-gnu
