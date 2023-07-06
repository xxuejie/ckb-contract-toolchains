FROM docker.io/ubuntu:jammy
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && \
  apt-get install -y sudo curl lsb-release build-essential \
    autoconf automake libtool wget software-properties-common gnupg

RUN echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-16 main" \
      > /etc/apt/sources.list.d/llvm.list && \
    wget -qO /etc/apt/trusted.gpg.d/llvm.asc \
        https://apt.llvm.org/llvm-snapshot.gpg.key && \
    apt-get update && \
    apt_get install -y clang-16 lld-16 llvm-16

RUN apt-get clean

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain none -y
ENV PATH=/root/.cargo/bin:$PATH

COPY ./install.sh /root/install.sh
COPY ./version /root/version
RUN /root/install.sh $(cat /root/version)
RUN rustup default ckb-$(cat /root/version)
CMD ["rustc", "--version"]
