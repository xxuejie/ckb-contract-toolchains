#!/bin/bash
set -ex

GNU_ROOT=$(realpath $1)
VERSION=$2

export PATH=${GNU_ROOT}/bin:$PATH

PACKAGE=rust_${VERSION}

rm -rf ${PACKAGE}
mkdir ${PACKAGE}

RUST_VERSION=$(cat rust/src/version)
sed "s/##VERSION##/${RUST_VERSION}/" rustfiles.template > ${PACKAGE}/rustfiles
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
./x build --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
./x dist --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
cd ..

mkdir -p dist-${VERSION}
for f in $(cat ${PACKAGE}/rustfiles); do
  tar xzf rust/build/dist/${f}.tar.gz -C ${PACKAGE}
done

tar czf ${PACKAGE}.tar.gz ${PACKAGE}
rm -rf ${PACKAGE}
mv ${PACKAGE}.tar.gz dist-${VERSION}

echo "Build completed!"
