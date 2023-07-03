#!/bin/bash
set -ex

# Inspired from https://stackoverflow.com/a/246128
DIST_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIST_PATH

INSTALL_DIR=$1
RUSTUP_LINK=$2

rm -rf $INSTALL_DIR
mkdir -p $INSTALL_DIR
INSTALL_DIR=$(realpath $INSTALL_DIR)

TEMP_DIR=/tmp/_ckb_toolchain_install
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

for f in $(cat rustfiles); do
  COMPONENT_PATH=${DIST_PATH}/$f
  RUN_TMP_PATH=$TEMP_DIR/_runtmp
  rm -rf $RUN_TMP_PATH
  mkdir $RUN_TMP_PATH

  pushd .
  cd $RUN_TMP_PATH
  $COMPONENT_PATH/install.sh \
    --prefix=${INSTALL_DIR} \
    --sysconfdir=${INSTALL_DIR}/etc \
    --datadir=${INSTALL_DIR}/share \
    --docdir=${INSTALL_DIR}/share/doc/rust \
    --bindir=${INSTALL_DIR}/bin \
    --libdir=${INSTALL_DIR}/lib \
    --mandir=${INSTALL_DIR}/share/man \
    --disable-ldconfig
  popd
done

cp libdummyatomics.a libdummylibc.a $INSTALL_DIR/lib/rustlib/riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf/lib
cp -r clang-rv-cc $INSTALL_DIR/

cd $INSTALL_DIR/clang-rv-cc
ln -s clang-rv-cc clang
ln -s clang-rv-cc clang++
ln -s clang-rv-cc llvm-ar
ln -s clang-rv-cc llvm-ranlib

if [ "x$RUSTUP_LINK" = "xtrue" ]
then
  TOOLCHAIN_NAME="$(basename "${INSTALL_DIR}")"
  rustup toolchain link $TOOLCHAIN_NAME $INSTALL_DIR
fi
