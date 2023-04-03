#!/bin/bash
set -ex

VERSION=$1

# Inspired from https://stackoverflow.com/a/246128
TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $TOP

BUILD_DIR=tmp/ckb-riscv-toolchain_${VERSION}_ubuntu_jammy_amd64

echo "Building $BUILD_DIR"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/usr/local/lib/ckb-toolchain
mkdir -p $BUILD_DIR/usr/local/bin

./build_gnu_toolchain.sh ${VERSION} ./ckb-riscv-gnu-toolchain ./lib-dummy-atomics false

cp -r /usr/local/lib/ckb-toolchain/${VERSION} $BUILD_DIR/usr/local/lib/ckb-toolchain/
# rm -rf /usr/local/lib/ckb-toolchain/${VERSION}
./link_bins.sh $BUILD_DIR

mkdir -p $BUILD_DIR/DEBIAN
sed "s/##VERSION##/${VERSION}/" deb/ubuntu_jammy_control > $BUILD_DIR/DEBIAN/control

dpkg-deb --build -Zxz --root-owner-group $BUILD_DIR

mkdir -p dist_${VERSION}
mv ${BUILD_DIR}.deb dist_${VERSION}/

echo "Build completed!"
