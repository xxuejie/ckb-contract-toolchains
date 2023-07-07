#!/bin/bash
set -ex

# This scripts builds the Rust distribution on Linux x64 instances
# for x64 Linux. Typically this is used inside a centos docker image built via:
# https://github.com/rust-lang/rust/blob/master/src/ci/docker/host-x86_64/dist-aarch64-linux/Dockerfile

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
export OPENSSL_INCLUDE_DIR=${OPENSSL_X64}/include
export OPENSSL_LIB_DIR=${OPENSSL_X64}
./build_rust.sh ${VERSION} true
