#!/bin/bash
set -ex

# This script builds GNU toolchain and leaves the installed files at
# /usr/local/lib/ckb-toolchain/${VERSION}

VERSION=$1
GNU_TOOLCHAIN_PATH=$(realpath $2)
LIB_DUMMY_ATOMICS_PATH=$(realpath $3)
LINK_BINS=$4

sudo mkdir -p /usr/local/lib/ckb-toolchain
if [ "x$USER" != "x" ]
then
  sudo chown -R $USER /usr/local/lib/ckb-toolchain
fi
rm -rf /usr/local/lib/ckb-toolchain/${VERSION}

EXTRA_ARGS=""
if [ $(uname -m) == "arm64" ] && [ $(uname -s) == "Darwin" ]
then
  # Fix the issue that gdb 12.1 cannot locate gmp installed via homebrew on Apple Silicon
  export host_configargs="--with-libgmp-prefix=/opt/homebrew"
fi

cd $GNU_TOOLCHAIN_PATH
export CFLAGS_FOR_TARGET_EXTRA="-Os -DCKB_NO_MMU -D__riscv_soft_float -D__riscv_float_abi_soft"
./configure --prefix=/usr/local/lib/ckb-toolchain/${VERSION} --with-arch=rv64imc_zba_zbb_zbc_zbs
make clean
make -j$(nproc)
# make clean

cd $LIB_DUMMY_ATOMICS_PATH
make clean
make \
  CC=/usr/local/lib/ckb-toolchain/${VERSION}/bin/riscv64-ckb-elf-gcc \
  AR=/usr/local/lib/ckb-toolchain/${VERSION}/bin/riscv64-ckb-elf-ar
cp libdummyatomics.a /usr/local/lib/ckb-toolchain/${VERSION}/riscv64-ckb-elf/lib/

if [ "x$LINK_BINS" = "xtrue" ]
then
  for b in $(find /usr/local/lib/ckb-toolchain/${VERSION}/bin/*); do
    sudo ln -sf ../../..$b /usr/local/bin/"$(basename -- $b)"
  done
fi
