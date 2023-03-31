#!/bin/bash
set -ex

# Build deps:
# sudo apt-get install build-essential git lsb-release curl autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build cmake pkg-config libssl-dev

# Inspired from https://stackoverflow.com/a/246128
TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $TOP

VERSION=$(cat version)

./check_git.sh true
./build_deb.sh ${VERSION}
./build_rust.sh x86_64-unknown-linux-gnu tmp/ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64/usr/lib/ckb-toolchain/${VERSION} ${VERSION} true

rm -rf tmp/ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64
