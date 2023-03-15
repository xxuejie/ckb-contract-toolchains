#!/bin/bash
set -ex

GNU_ROOT=$(realpath $1)
VERSION=$2

export PATH=${GNU_ROOT}/bin:$PATH

rm -rf starter
mkdir starter
cp rustfiles starter/

cd lib-dummy-atomics
make clean
make CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummyatomics.a ../starter
# make clean
cd ..

cd ckb-c-stdlib
make clean
make libdummylibc.a CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
cp libdummylibc.a ../starter
# make clean
cd ..

tar czf starter.tar.gz starter
rm -rf starter

cd rust
sed "s/^#compression-formats.*/compression-formats = \[\"gz\"\]/ ; s/^#channel.*/channel = \"nightly\"/" config-ckb.toml.example > config.toml
./x build --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
./x dist --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
cd ..

mkdir -p dist-${VERSION}
for f in $(cat rustfiles); do
  cp rust/build/dist/$f dist-${VERSION}
done
mv starter.tar.gz dist-${VERSION}

echo "Build completed!"
