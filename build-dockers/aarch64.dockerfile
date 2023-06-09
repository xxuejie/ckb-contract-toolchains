# This file (and the accompanying files) is modified from
# https://github.com/rust-lang/rust/blob/bb548f964572f7fe652716f5897d9050a31c936e/src/ci/docker/host-x86_64/dist-aarch64-linux/Dockerfile

FROM ubuntu:22.04

COPY build-dockers/cross-apt-packages.sh /scripts/
RUN sh /scripts/cross-apt-packages.sh

COPY build-dockers/crosstool-ng.sh /scripts/
RUN sh /scripts/crosstool-ng.sh

COPY build-dockers/rustbuild-setup.sh /scripts/
RUN sh /scripts/rustbuild-setup.sh
WORKDIR /tmp

COPY build-dockers/crosstool-ng-build.sh /scripts/
COPY build-dockers/aarch64-linux-gnu.defconfig /tmp/crosstool.defconfig
RUN /scripts/crosstool-ng-build.sh

ENV PATH=$PATH:/x-tools/aarch64-unknown-linux-gnu/bin

ENV CC_aarch64_unknown_linux_gnu=aarch64-unknown-linux-gnu-gcc \
    AR_aarch64_unknown_linux_gnu=aarch64-unknown-linux-gnu-ar \
    CXX_aarch64_unknown_linux_gnu=aarch64-unknown-linux-gnu-g++
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-unknown-linux-gnu-gcc

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add aarch64-unknown-linux-gnu

RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main" \
      > /etc/apt/sources.list.d/llvm.list && \
    wget -qO /etc/apt/trusted.gpg.d/llvm.asc \
        https://apt.llvm.org/llvm-snapshot.gpg.key && \
    apt-get update && \
    apt-get install -y clang-16 lld-16 llvm-16
