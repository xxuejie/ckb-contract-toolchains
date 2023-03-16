#!/bin/bash
set -ex

VERSION=$1
PACKAGE_REVISION=$2

BUILD_DIR=ckb-riscv-toolchain_${VERSION}_${PACKAGE_REVISION}_ubuntu_jammy_amd64

echo "Building $BUILD_DIR"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/usr/lib/ckb-toolchain
mkdir -p $BUILD_DIR/usr/local/bin
rm -rf /usr/lib/ckb-toolchain/${VERSION}

cd ckb-riscv-gnu-toolchain
export CFLAGS_FOR_TARGET_EXTRA="-Os -DCKB_NO_MMU -D__riscv_soft_float -D__riscv_float_abi_soft"
./configure --prefix=/usr/lib/ckb-toolchain/${VERSION} --with-arch=rv64imc_zba_zbb_zbc_zbs
make clean
make -j$(nproc)
# make clean
cd ..

cp -r /usr/lib/ckb-toolchain/${VERSION} $BUILD_DIR/usr/lib/ckb-toolchain/
# rm -rf /usr/lib/ckb-toolchain/${VERSION}
./link_bins.sh $BUILD_DIR

cd lib-dummy-atomics
make clean
make CC=../${BUILD_DIR}/usr/local/bin/riscv64-ckb-elf-gcc AR=../${BUILD_DIR}/usr/local/bin/riscv64-ckb-elf-ar
# make clean
cd ..

cp lib-dummy-atomics/libdummyatomics.a ${BUILD_DIR}/usr/lib/ckb-toolchain/${VERSION}/riscv64-ckb-elf/lib/

mkdir -p $BUILD_DIR/DEBIAN
sed "s/##VERSION##/${VERSION}/" deb/ubuntu_jammy_control > $BUILD_DIR/DEBIAN/control

dpkg-deb --build -Zxz --root-owner-group $BUILD_DIR

mkdir -p dist_${VERSION}_${PACKAGE_REVISION}
mv ${BUILD_DIR}.deb dist_${VERSION}_${PACKAGE_REVISION}/

echo "Build completed!"
