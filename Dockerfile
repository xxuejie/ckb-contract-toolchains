FROM docker.io/ubuntu:jammy
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && apt-get install -y sudo curl lsb-release build-essential autoconf automake libtool && apt-get clean

RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain none -y
ENV PATH=/root/.cargo/bin:$PATH

COPY ./install.sh /root/install.sh
RUN /root/install.sh 20230331-2
RUN rustup default ckb-20230331-2
CMD ["riscv64-ckb-elf-gcc", "--version"]
