#!/bin/bash
set -ex

# Inspired from https://stackoverflow.com/a/246128
TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $TOP

LATEST_VERSION=$(cat version)

VERSION=$1
if [ "x$VERSION" = "x" ]
then
  VERSION=$LATEST_VERSION
fi

./check_git.sh false
./build_gnu_toolchain.sh ${VERSION} ./ckb-riscv-gnu-toolchain ./lib-dummy-atomics true
./build_rust.sh /usr/lib/ckb-toolchain/${VERSION} ${VERSION} false

RUST_PACKAGE=rust_${VERSION}_amd64
RUST_INSTALL_PATH=~/.ckb-rustup-toolchains/${VERSION}
TMP_DIR=/tmp/_ckb_toolchain_install

rm -rf $RUST_INSTALL_PATH
mkdir -p $RUST_INSTALL_PATH
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

cd $RUST_PACKAGE
./install_rust.sh . $RUST_INSTALL_PATH $TMP_DIR
cp libdummyatomics.a libdummylibc.a $RUST_INSTALL_PATH/lib/rustlib/riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf/lib
rustup toolchain link ckb-${VERSION} $RUST_INSTALL_PATH

rm -rf $TMP_DIR
rm -rf $RUST_PACKAGE

echo "Install complete, a new Rust toolchain named ckb-${VERSION} is now available!"
