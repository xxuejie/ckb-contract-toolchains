#!/bin/bash
set -ex

CHECK_DIFF=$1

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
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..

if [ ! -d "rust" ]
then
  git clone $RUST_REPO rust
fi

cd rust
git checkout $RUST_COMMIT
git submodule update --init
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..

if [ ! -d "lib-dummy-atomics" ]
then
  git clone $LIB_DUMMY_ATOMICS_REPO lib-dummy-atomics
fi

cd lib-dummy-atomics
git checkout $LIB_DUMMY_ATOMICS_COMMIT
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..

if [ ! -d "ckb-c-stdlib" ]
then
  git clone $CKB_C_STDLIB_REPO ckb-c-stdlib
fi

cd ckb-c-stdlib
git checkout $CKB_C_STDLIB_COMMIT
git submodule update --init
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..
