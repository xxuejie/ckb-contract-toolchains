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

need_cmd() {
    if ! check_cmd "$1"; then
        echo "need '$1' (command not found)"
        exit 1
    fi
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

need_cmd uname
need_cmd git
need_cmd gcc
need_cmd rustc
need_cmd rustup

NATIVE_TARGET=$(rustc -vV | sed -n 's|host: ||p')

./check_git.sh false
./build_rust.sh ${VERSION} false ${NATIVE_TARGET}

RUST_PACKAGE=rust_${VERSION}_${NATIVE_TARGET}
RUST_INSTALL_PATH=~/.ckb-rustup-toolchains/ckb-${VERSION}

cd $RUST_PACKAGE
./install_rust.sh $RUST_INSTALL_PATH true

rm -rf $RUST_PACKAGE

echo "Install complete, a new Rust toolchain named ckb-${VERSION} is now available!"
