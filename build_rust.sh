#!/bin/bash
set -ex

GNU_ROOT=$1
RUST_VERSION=$2

export PATH=${GNU_ROOT}/bin:$PATH

cd lib-dummy-atomics
make clean
make CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
# make clean
cd ..

cd ckb-c-stdlib
make clean
make libdummylibc.a CC=riscv64-ckb-elf-gcc AR=riscv64-ckb-elf-ar
# make clean
cd ..

cd rust
sed "s/^#compression-formats.*/compression-formats = \[\"gz\"\]/ ; s/^#channel.*/channel = \"nightly\"/" config-ckb.toml.example > config.toml
./x build --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
./x dist --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,x86_64-unknown-linux-gnu
cd ..