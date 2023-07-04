#!/bin/bash
set -ex

CHECK_DIFF=$1

RUST_REPO="https://github.com/xxuejie/rust"
RUST_COMMIT="2ea6fc05ccbf700f840ceeacd67203650a2f3ed9"

LIB_DUMMY_ATOMICS_REPO="https://github.com/xxuejie/lib-dummy-atomics"
LIB_DUMMY_ATOMICS_COMMIT="50dc5fefb215bc93e761fb655d7a4fdade04c2d1"

CKB_C_STDLIB_REPO="https://github.com/nervosnetwork/ckb-c-stdlib"
CKB_C_STDLIB_COMMIT="74a14572881916d2ea73b8f085b6874f22630997"

CLANG_RV_CC_REPO="https://github.com/xxuejie/clang-rv-cc"
CLANG_RV_CC_COMMIT="1a19cfd3489f971151c0e30b8bccde2af8ea55c6"

if [ ! -d "rust" ]
then
  git clone $RUST_REPO rust
else
  cd rust
  git fetch origin
  cd ..
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
else
  cd lib-dummy-atomics
  git fetch origin
  cd ..
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
else
  cd ckb-c-stdlib
  git fetch origin
  cd ..
fi

cd ckb-c-stdlib
git checkout $CKB_C_STDLIB_COMMIT
git submodule update --init
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..

if [ ! -d "clang-rv-cc" ]
then
  git clone $CLANG_RV_CC_REPO clang-rv-cc
else
  cd clang-rv-cc
  git fetch origin
  cd ..
fi

cd clang-rv-cc
git checkout $CLANG_RV_CC_COMMIT
if [ "x$CHECK_DIFF" = "xtrue" ]
then
  git diff --exit-code
fi
cd ..
