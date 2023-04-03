#!/bin/bash
set -ex

cd $1

for s in $(find usr/local/bin/*); do
  rm $s
done

for b in $(find usr/local/lib/ckb-toolchain/*/bin/*); do
  ln -sf ../../../$b usr/local/bin/"$(basename -- $b)"
done
