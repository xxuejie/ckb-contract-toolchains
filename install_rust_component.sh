#!/bin/bash
set -ex

DIST_FILE=$(realpath $1)
INSTALL_DIR=$(realpath $2)
TEMP_DIR=$(realpath $3)

UNCOMPRESSED_PATH=$(basename -- ${DIST_FILE} .tar.gz)
RUN_TMP_PATH=${UNCOMPRESSED_PATH}_runtmp

echo $DIST_FILE
echo $UNCOMPRESSED_PATH

rm -rf $TEMP_DIR/$UNCOMPRESSED_PATH
tar xzf $DIST_FILE -C $TEMP_DIR

rm -rf $TEMP_DIR/$RUN_TMP_PATH
mkdir $TEMP_DIR/$RUN_TMP_PATH

cd $TEMP_DIR/$RUN_TEMP_PATH
$TEMP_DIR/$UNCOMPRESSED_PATH/install.sh \
  --prefix=${INSTALL_DIR} \
  --sysconfdir=${INSTALL_DIR}/etc \
  --datadir=${INSTALL_DIR}/share \
  --docdir=${INSTALL_DIR}/share/doc/rust \
  --bindir=${INSTALL_DIR}/bin \
  --libdir=${INSTALL_DIR}/lib \
  --mandir=${INSTALL_DIR}/share/man \
  --disable-ldconfig

rm -rf $TEMP_DIR/$UNCOMPRESSED_PATH
rm -rf $TEMP_DIR/$RUN_TMP_PATH
