#!/bin/bash
set -ex

COMPONENT_PATH=$(realpath $1)
INSTALL_DIR=$(realpath $2)
TEMP_DIR=$(realpath $3)

RUN_TMP_PATH=$TEMP_DIR/_runtmp

rm -rf $RUN_TMP_PATH
mkdir $RUN_TMP_PATH

cd $RUN_TEMP_PATH
$COMPONENT_PATH/install.sh \
  --prefix=${INSTALL_DIR} \
  --sysconfdir=${INSTALL_DIR}/etc \
  --datadir=${INSTALL_DIR}/share \
  --docdir=${INSTALL_DIR}/share/doc/rust \
  --bindir=${INSTALL_DIR}/bin \
  --libdir=${INSTALL_DIR}/lib \
  --mandir=${INSTALL_DIR}/share/man \
  --disable-ldconfig

rm -rf $RUN_TMP_PATH
