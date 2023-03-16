#!/bin/bash
set -ex

LATEST_VERSION="20230316-1"

VERSION=$1
if [ "x$VERSION" = "x" ]
then
  VERSION=$LATEST_VERSION
fi

TMP_ROOT=/tmp/_ckb_toolchain_install
rm -rf $TMP_ROOT
mkdir -p $TMP_ROOT

GNU_TOOLCHAIN_NAME="ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64.deb"
RUST_TARBALL_DIR="rust_${VERSION}_amd64"
RUST_TARBALL_NAME="${RUST_TARBALL_DIR}.tar.gz"

# Inspired from https://stackoverflow.com/a/246128
TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $TOP

cp ./${GNU_TOOLCHAIN_NAME} $TMP_ROOT/
cp ./${RUST_TARBALL_NAME} $TMP_ROOT/

cd $TMP_ROOT

sudo apt -y install $TMP_ROOT/$GNU_TOOLCHAIN_NAME

RUST_INSTALL_PATH=~/.ckb-rustup-toolchains/${VERSION}

tar xzf $TMP_ROOT/$RUST_TARBALL_NAME -C $TMP_ROOT
rm -rf $RUST_INSTALL_PATH
mkdir -p $RUST_INSTALL_PATH
mkdir -p $TMP_ROOT/_install_tmp
cd $TMP_ROOT/$RUST_TARBALL_DIR
./install_rust.sh . $RUST_INSTALL_PATH $TMP_ROOT/_install_tmp
cp libdummyatomics.a libdummylibc.a $RUST_INSTALL_PATH/lib/rustlib/riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf/lib
rustup toolchain link ckb-${VERSION} $RUST_INSTALL_PATH

rm -rf $TMP_ROOT

echo "Install complete, a new Rust toolchain named ckb-${VERSION} is now available!"
