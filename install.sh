#!/bin/bash
set -e

LATEST_VERSION=$(curl https://raw.githubusercontent.com/xxuejie/ckb-contract-toolchains/main/version)
HOST="${GITHUB_HOST:-https://github.com}"
REPO="xxuejie/ckb-contract-toolchains"

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

need_cmd curl
need_cmd rustup
need_cmd rustc
need_cmd tar
need_cmd gzip

TMP_ROOT=/tmp/_ckb_toolchain_extract
rm -rf $TMP_ROOT
mkdir -p $TMP_ROOT

TARGET=$(rustc -vV | sed -n 's|host: ||p')

RUST_TARBALL_DIR="rust_${VERSION}_${TARGET}"
RUST_TARBALL_NAME="${RUST_TARBALL_DIR}.tar.gz"

cd $TMP_ROOT
curl -fLO "$HOST/$REPO/releases/download/${VERSION}/${RUST_TARBALL_NAME}"

RUST_INSTALL_PATH=~/.ckb-rustup-toolchains/ckb-${VERSION}

tar xzf $TMP_ROOT/$RUST_TARBALL_NAME -C $TMP_ROOT
$TMP_ROOT/$RUST_TARBALL_DIR/install_rust.sh $RUST_INSTALL_PATH true

rm -rf $TMP_ROOT

echo "Install complete, a new Rust toolchain named ckb-${VERSION} is now available!"
