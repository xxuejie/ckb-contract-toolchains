#!/bin/bash
set -ex

LATEST_VERSION="20230314_1"
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
need_cmd apt

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

GNU_TOOLCHAIN_NAME="ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64.deb"
RUST_TARBALL_DIR="rust_${VERSION}_amd64"
RUST_TARBALL_NAME="${RUST_TARBALL_DIR}.tar.gz"

cd $TMP_ROOT
curl -fLO "$HOST/$REPO/releases/download/${VERSION}/${GNU_TOOLCHAIN_NAME}"
curl -fLO "$HOST/$REPO/releases/download/${VERSION}/${RUST_TARBALL_NAME}"

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
