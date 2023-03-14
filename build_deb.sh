#!/bin/bash
set -ex

VERSION=$1
PACKAGE_REVISION=$2
ARCH=$3
CONTROL_FILE=$4

BUILD_DIR=ckb-riscv-toolchain_${VERSION}_${PACKAGE_REVISION}_${ARCH}

echo "Building $BUILD_DIR"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/usr/lib/ckb-toolchain
mkdir -p $BUILD_DIR/usr/local/bin

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
cp deb/${CONTROL_FILE} $BUILD_DIR/DEBIAN/control

dpkg-deb --build -Zxz --root-owner-group $BUILD_DIR
tar czf ${BUILD_DIR}.tar.gz -C $BUILD_DIR/usr/lib/ckb-toolchain ${VERSION}

echo "Build completed!"
