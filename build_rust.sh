#!/bin/bash
set -ex

GNU_ROOT=$(realpath $1)
VERSION=$2

export PATH=${GNU_ROOT}/bin:$PATH

rm -rf dummylibs
mkdir dummylibs

cd lib-dummy-atomics
make clean
make CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummyatomics.a ../dummylibs
# make clean
cd ..

cd ckb-c-stdlib
make clean
make libdummylibc.a CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummylibc.a ../dummylibs
# make clean
cd ..

tar czf dummylibs.tar.gz dummylibs
rm -rf dummylibs

cd rust
sed "s/^#compression-formats.*/compression-formats = \[\"gz\"\]/ ; s/^#channel.*/channel = \"nightly\"/" config-ckb.toml.example > config.toml
./x build --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
./x dist --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
cd ..

mkdir -p dist-${VERSION}
for f in $(cat rustfiles); do
  cp rust/build/dist/$f dist-${VERSION}
done
cp rustfiles dist-${VERSION}
mv dummylibs.tar.gz dist-${VERSION}

echo "Build completed!"
