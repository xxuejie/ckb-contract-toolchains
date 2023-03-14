#!/bin/bash
set -ex

cd $1

for s in $(find usr/local/bin/*); do
  rm $s
done

for b in $(find usr/lib/ckb-toolchain/*/bin/* -executable); do
  ln -sf ../../../$b usr/local/bin/"$(basename -- $b)"
done
