#!/bin/bash
set -ex

VERSION=$1
MOVE_PACKAGE_TO_DIST=$2
NATIVE_TARGET=$3

CROSS_COMPILE="false"

INFERRED_TARGET=$(rustc -vV | sed -n 's|host: ||p')

if [ "x$NATIVE_TARGET" = "x" ]
then
  NATIVE_TARGET=$INFERRED_TARGET
elif [ "x$NATIVE_TARGET" != "x$INFERRED_TARGET" ]
then
  CROSS_COMPILE="true"
fi

PACKAGE=rust_${VERSION}_${NATIVE_TARGET}

rm -rf ${PACKAGE}
mkdir ${PACKAGE}

RUST_VERSION=$(cat rust/src/version)
sed "s/##VERSION##/${RUST_VERSION}/ ; s/##NATIVE_TARGET##/${NATIVE_TARGET}/" rustfiles.template > ${PACKAGE}/rustfiles
cp install_rust.sh ${PACKAGE}

mkdir -p ${PACKAGE}/clang-rv-cc
cd clang-rv-cc
cargo clean
cargo build --release
if [ "x$CROSS_COMPILE" = "xtrue" ]
then
  cargo build --release --target=${NATIVE_TARGET}
  cp target/${NATIVE_TARGET}/release/clang-rv-cc ../${PACKAGE}/clang-rv-cc/
else
  cp target/release/clang-rv-cc ../${PACKAGE}/clang-rv-cc/
fi
cd ..

cd lib-dummy-atomics
make clean
make CC=../clang-rv-cc/clang AR=../clang-rv-cc/llvm-ar \
  CFLAGS="-Wall -Werror -Wextra -O3 -g -fdata-sections -ffunction-sections -fno-builtin --target=riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf"
cp libdummyatomics.a ../${PACKAGE}
# make clean
cd ..

cd ckb-c-stdlib
make clean
make libdummylibc.a CC=../clang-rv-cc/clang AR=../clang-rv-cc/llvm-ar \
  CFLAGS="-Wall -Werror -Wextra -Wno-unused-parameter -Wno-nonnull -fno-builtin-printf -fno-builtin-memcmp -O3 -g -fdata-sections -ffunction-sections -fno-builtin --target=riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf"
cp libdummylibc.a ../${PACKAGE}
# make clean
cd ..
cp -r ckb-c-stdlib/libc ${PACKAGE}/clang-rv-cc/

cd rust
sed "s/^#compression-formats.*/compression-formats = \[\"gz\"\]/ ; s/^#ignore-git.*/ignore-git = false/" config-ckb.toml.example > config.toml
./x build --build ${INFERRED_TARGET} --host ${NATIVE_TARGET} --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,${NATIVE_TARGET}
./x dist --build ${INFERRED_TARGET} --host ${NATIVE_TARGET} --target riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf,${NATIVE_TARGET}
cd ..

for f in $(cat ${PACKAGE}/rustfiles); do
  tar xzf rust/build/dist/${f}.tar.gz -C ${PACKAGE}
done

if [ "x$MOVE_PACKAGE_TO_DIST" = "xtrue" ]
then
  tar cvf - ${PACKAGE} | gzip -9 - > ${PACKAGE}.tar.gz
  rm -rf ${PACKAGE}

  mkdir -p dist_${VERSION}
  mv ${PACKAGE}.tar.gz dist_${VERSION}
fi

echo "Build completed!"
