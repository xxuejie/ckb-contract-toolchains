#!/bin/bash

# Uninstalling all components of ckb-contract-toolchain

if command -v apt-get &> /dev/null
then
  sudo apt-get remove -y ckb-riscv-toolchain
fi

sudo rm -rf /usr/lib/ckb-toolchain
sudo rm -rf /usr/local/lib/ckb-toolchain
sudo rm -rf /usr/local/bin/riscv64-ckb-elf-*
rm -rf ~/.ckb-rustup-toolchains
rm -rf ~/.rustup/toolchains/ckb-*
