#!/bin/bash
set -ex

# This scripts builds the Rust distribution on Linux aarch64 instances
# for both x64 and aarch64 Linux

if [ "x$OPENSSL_X64" = "x" ]
then
  echo "Please set the OPENSSL_X64 environment variable!"
  exit 1
fi

VERSION=$1

./build_rust.sh ${VERSION} true

export OPENSSL_STATIC=1
export OPENSSL_INCLUDE_DIR=${OPENSSL_AARCH64}/include
export OPENSSL_LIB_DIR=${OPENSSL_AARCH64}
export CC_x86_64_unknown_linux_gnu=x86_64-linux-gnu-gcc
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
./build_rust.sh ${VERSION} true x86_64-unknown-linux-gnu
