#!/bin/bash
set -ex

DIST_PATH=$(realpath $1)
INSTALL_DIR=$(realpath $2)
TEMP_DIR=$(realpath $3)

for f in $(cat rustfiles); do
  ./install_rust_component.sh ${DIST_PATH}/$f $INSTALL_DIR $TEMP_DIR
done
