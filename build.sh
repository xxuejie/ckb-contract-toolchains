#!/bin/bash
set -ex

# Build deps:
# sudo apt-get install build-essential git lsb-release curl autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build cmake pkg-config libssl-dev

VERSION="20230316-1"

GNU_TOOLCHAIN_REPO="https://github.com/nervosnetwork/ckb-riscv-gnu-toolchain"
GNU_TOOLCHAIN_COMMIT="0643dc530859ff557e498c3131e43a3026f88d88"

RUST_REPO="https://github.com/xxuejie/rust"
RUST_COMMIT="e9db5b2e710dbcbbd2b7625130f58e682df9107c"

LIB_DUMMY_ATOMICS_REPO="https://github.com/xxuejie/lib-dummy-atomics"
LIB_DUMMY_ATOMICS_COMMIT="3bcff6a3190780415527cc4d67f9242082dd3594"

CKB_C_STDLIB_REPO="https://github.com/nervosnetwork/ckb-c-stdlib"
CKB_C_STDLIB_COMMIT="74a14572881916d2ea73b8f085b6874f22630997"

if [ ! -d "ckb-riscv-gnu-toolchain" ]
then
  git clone $GNU_TOOLCHAIN_REPO ckb-riscv-gnu-toolchain
fi

cd ckb-riscv-gnu-toolchain
git checkout $GNU_TOOLCHAIN_COMMIT
git diff --exit-code
cd ..

if [ ! -d "rust" ]
then
  git clone $RUST_REPO rust
fi

cd rust
git checkout $RUST_COMMIT
git submodule update --init
git diff --exit-code
cd ..

if [ ! -d "lib-dummy-atomics" ]
then
  git clone $LIB_DUMMY_ATOMICS_REPO lib-dummy-atomics
fi

cd lib-dummy-atomics
git checkout $LIB_DUMMY_ATOMICS_COMMIT
git diff --exit-code
cd ..

if [ ! -d "ckb-c-stdlib" ]
then
  git clone $CKB_C_STDLIB_REPO ckb-c-stdlib
fi

cd ckb-c-stdlib
git checkout $CKB_C_STDLIB_COMMIT
git submodule update --init
git diff --exit-code
cd ..

./build_deb.sh ${VERSION}
./build_rust.sh ./ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64/usr/lib/ckb-toolchain/${VERSION} ${VERSION}

rm -rf ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64
