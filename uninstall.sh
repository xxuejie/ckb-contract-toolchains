#!/bin/bash
set -ex

# Uninstalling all components of ckb-contract-toolchain

sudo rm -rf /usr/lib/ckb-toolchain
sudo rm -rf /usr/local/bin/riscv64-ckb-elf-*
rm -rf ~/.ckb-rustup-toolchains
rm -rf ~/.rustup/toolchains/ckb-*
