#!/bin/bash
set -ex

# This scripts builds the Rust distribution on Linux aarch64 instances
# for both x64 and aarch64 Linux

# Note this is not used in production now, since x64 distribution requires
# special attention on GLIBC version. It is merely included here for
# reference reason.

if [ "x$OPENSSL_AARCH64" = "x" ]
then
  echo "Please set the OPENSSL_AARCH64 environment variable!"
  exit 1
fi

if [ "x$OPENSSL_X64" = "x" ]
then
  echo "Please set the OPENSSL_X64 environment variable!"
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
./build_rust.sh ${VERSION} true

export OPENSSL_STATIC=1
export OPENSSL_INCLUDE_DIR=${OPENSSL_X64}/include
export OPENSSL_LIB_DIR=${OPENSSL_X64}
export CC_x86_64_unknown_linux_gnu=x86_64-linux-gnu-gcc
export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
./build_rust.sh ${VERSION} true x86_64-unknown-linux-gnu
