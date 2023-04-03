#!/bin/bash
set -ex

NATIVE_TARGET=$1
GNU_ROOT=$(realpath $2)
VERSION=$3
MOVE_PACKAGE_TO_DIST=$4

export PATH=${GNU_ROOT}/bin:$PATH

PACKAGE=rust_${VERSION}_amd64

rm -rf ${PACKAGE}
mkdir ${PACKAGE}

RUST_VERSION=$(cat rust/src/version)
sed "s/##VERSION##/${RUST_VERSION}/ ; s/##NATIVE_TARGET##/${NATIVE_TARGET}/" rustfiles.template > ${PACKAGE}/rustfiles
cp install_rust.sh ${PACKAGE}
cp install_rust_component.sh ${PACKAGE}

cd lib-dummy-atomics
make clean
make CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummyatomics.a ../${PACKAGE}
# make clean
cd ..

cd ckb-c-stdlib
make clean
make libdummylibc.a CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummylibc.a ../${PACKAGE}
# make clean
cd ..

cd rust
sed "s/^#compression-formats.*/compression-formats = \[\"gz\"\]/ ; s/^#ignore-git.*/ignore-git = false/" config-ckb.toml.example > config.toml
./x build --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,${NATIVE_TARGET}
./x dist --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,${NATIVE_TARGET}
cd ..

for f in $(cat ${PACKAGE}/rustfiles); do
  tar xzf rust/build/dist/${f}.tar.gz -C ${PACKAGE}
done

if [ "x$MOVE_PACKAGE_TO_DIST" = "xtrue" ]
then
  tar czf ${PACKAGE}.tar.gz ${PACKAGE}
  rm -rf ${PACKAGE}

  mkdir -p dist_${VERSION}
  mv ${PACKAGE}.tar.gz dist_${VERSION}
fi

echo "Build completed!"
