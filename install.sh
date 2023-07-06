#!/bin/bash
set -e

LATEST_VERSION="20230706-1"
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

need_cmd uname
need_cmd lsb_release
need_cmd curl
need_cmd rustup
need_cmd tar
need_cmd gzip

ARCH=$(uname -m)
DISTRO=$(lsb_release -is)
DISTRO_VERSION=$(lsb_release -sr)

if [ "$ARCH" != "x86_64" ] || [ "$DISTRO" != "Ubuntu" ] || [ "$DISTRO_VERSION" != "22.04" ]
then
  echo "Currently only Ubuntu 22.04 running on x86_64 architecture is supported!"
  exit 1
fi

TMP_ROOT=/tmp/_ckb_toolchain_install
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
