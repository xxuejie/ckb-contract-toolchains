# This file (and the accompanying files) is modified from
# https://github.com/rust-lang/rust/blob/06082086b42629adee0d37e4e67aa1816a447e23/src/ci/docker/host-x86_64/dist-x86_64-linux/Dockerfile

# We document platform support for minimum glibc 2.17 and kernel 3.2.
# CentOS 7 has headers for kernel 3.10, but that's fine as long as we don't
# actually use newer APIs in rustc or std without a fallback. It's more
# important that we match glibc for ELF symbol versioning.
FROM centos:7

WORKDIR /build

RUN yum upgrade -y && \
    yum install -y epel-release && \
    yum install -y \
      automake \
      bzip2 \
      file \
      cmake3 \
      gcc \
      gcc-c++ \
      git \
      glibc-devel.i686 \
      glibc-devel.x86_64 \
      libedit-devel \
      libstdc++-devel.i686 \
      libstdc++-devel.x86_64 \
      make \
      ncurses-devel \
      openssl-devel \
      patch \
      perl \
      pkgconfig \
      python3 \
      unzip \
      wget \
      xz \
      zlib-devel.i686 \
      zlib-devel.x86_64 \
      && yum clean all

RUN mkdir -p /rustroot/bin && ln -s /usr/bin/cmake3 /rustroot/bin/cmake

ENV PATH=/rustroot/bin:$PATH
ENV LD_LIBRARY_PATH=/rustroot/lib64:/rustroot/lib32:/rustroot/lib
ENV PKG_CONFIG_PATH=/rustroot/lib/pkgconfig
WORKDIR /tmp
RUN mkdir /home/user
COPY build-dockers/shared.sh /tmp/

# Need at least GCC 5.1 to compile LLVM nowadays
COPY build-dockers/build-gcc.sh /tmp/
RUN ./build-gcc.sh && yum remove -y gcc gcc-c++

# Now build LLVM+Clang, afterwards configuring further compilations to use the
# clang/clang++ compilers.
COPY build-dockers/build-clang.sh /tmp/
RUN ./build-clang.sh
ENV CC=clang CXX=clang++

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=/root/.cargo/bin:$PATH

ENV RUST_CONFIGURE_ARGS \
      --set target.x86_64-unknown-linux-gnu.linker=clang \
      --set target.x86_64-unknown-linux-gnu.ar=/rustroot/bin/llvm-ar \
      --set target.x86_64-unknown-linux-gnu.ranlib=/rustroot/bin/llvm-ranlib \
      --set llvm.thin-lto=true \
      --set llvm.ninja=false \
      --set rust.jemalloc \
      --set rust.use-lld=true \
      --set rust.lto=thin
ENV CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=clang
