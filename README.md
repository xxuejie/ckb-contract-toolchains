# ckb-contract-toolchains

A customized Rust toolchain for building CKB smart contracts. Some of the highlights are:

* RISC-V B extension is enabled by default
* An accompanying GNU toolchain is provided for now to build C code
* A new Rust target `riscv64imac_zba_zbb_zbc_zbs-unknown-ckb-elf` enables `std` in Rust
* Other useful optimizations for CKB, e.g.:
    + All stderr output will be automatically emitted to CKB's debug output

Notice all the changes made here are optimizations. CKB-VM still strictly obeys RISC-V specification, which means the official Rust toolchain / GNU toolchain can still be used to build CKB smart contracts.

## Usage

### Native Binary Package

Right now native binary `ckb-contract-toolchains` release only supports Ubuntu 22.04 running on x86_64 architecture.

In case you are on a bare minimal environment(such as the official jammy docker image), a few basic dependencies are required:

```bash
$ # If you are on absolute bare minimal machine, install sudo first:
$ apt-get update && apt-get install sudo
$ # Now install 2 dependencies used by installation tool
$ sudo apt-get install lsb-release curl
```

[rustup](https://rustup.rs/) is also needed here, please refer to rustup's installation steps.

Now use the following command to install the toolchain:

```bash
$ curl -f https://raw.githubusercontent.com/xxuejie/ckb-contract-toolchains/main/install.sh | bash
```

When succeeded, the final message generated by the installation script will show the new Rust toolchain version installed.

You can also manually list all installed toolchains:

```
$ rustup toolchain list
```

All toolchains provided by this repo starts with `ckb`.

### Docker

A docker image has been made available [here](https://hub.docker.com/r/xxuejie/ckb-contract-toolchains/tags). You can use it pretty much like [ckb-riscv-gnu-toolchain](https://hub.docker.com/r/nervos/ckb-riscv-gnu-toolchain/tags):

```bash
$ docker run --rm -it docker.io/xxuejie/ckb-contract-toolchains:20230331-2 bash
```

## Build from source

Depending on your specific OS, different steps are required to install dependencies at build time. Here we include installation steps for certain OSes, but please understand that there is no way we can maintain an exhaustive list.

### Ubuntu

On Ubuntu, the following commands can be used:

```bash
$ sudo apt-get install cmake pkg-config libssl-dev git lsb-release curl autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build
```

### CentOS

On CentOS 7, the following commands can be used:

```bash
$ sudo yum install openssl-devel git make autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel
$ sudo yum install centos-release-scl
$ sudo yum install devtoolset-9
$ source /opt/rh/devtoolset-9/enable
$ # Either use the following commands which require an external repo, or install
$ # ninja-build and cmake3 in ways comfortable to you:
$ yum install http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm
$ yum install ninja-build cmake3
$ sudo ln -s /usr/bin/cmake3 /usr/local/bin/cmake
```

### Fedora

On Fedora 37, the following commands can be used:

```bash
$ sudo yum install diffutils openssl-devel git cmake make autoconf automake python3 libmpc-devel mpfr-devel gmp-devel gawk  bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel ninja-build
```

### Arch Linux

On Arch Linux, the following commands can be used:

```bash
$ sudo pacman -Syyu ninja openssl cmake git autoconf automake curl python3 libmpc mpfr gmp gawk base-devel bison flex texinfo gperf libtool patchutils bc zlib expat
```

### macOS

We have tested and supported installation from source in all of the following configurations:

* x86_64 Macs on macOS Big Sur
* x86_64 Macs on macOS Monterey
* x86_64 Macs on macOS Ventura
* Apple Silicon Macs on macOS Big Sur
* Apple Silicon Macs on macOS Monterey
* Apple Silicon Macs on macOS Ventura

To install dependencies, the following commands leveraging [homebrew](https://brew.sh/) can be used:

```bash
$ brew install coreutils gawk gnu-sed gmp mpfr libmpc isl zlib expat flock cmake pkg-config ninja openssl texinfo autoconf
```

You will also need to make sure that this repo lives on a case-sensitive file system. Please refer to this [article](https://brianboyko.medium.com/a-case-sensitive-src-folder-for-mac-programmers-176cc82a3830) as an example to setup case-sensitive file systems on macOS.

A `CLI` tip(e.g., when you are launching a Mac instance on AWS): for APFS file system, the following CLI command can help you create a new case-sensitive volume named `Code` on `disk5`:

```bash
$ sudo diskutil apfs addVolume disk5 APFSX Code
```

There is not need to set a volume size beforehand, APFS will manage disk space for you.

Here we are using `disk5` but it might differ on your system, to check available disks, use `diskutil list`.

### General Steps

Note that [rustup](https://rustup.rs/) is also a dependency used to manage Rust toolchain.

When the dependencies are installed, use the following command to build and install from source:

```bash
$ ./install_from_source.sh
```

## Uninstalling

To uninstall `ckb-contract-toolchains`, use the following command:

```bash
$ curl -f https://raw.githubusercontent.com/xxuejie/ckb-contract-toolchains/main/uninstall.sh | bash
```
