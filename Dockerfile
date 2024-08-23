# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set environment variables
ARG GCC_VERSION
ARG PREFIX

# Install dependencies
RUN apt-get update && apt-get install -y build-essential

# Download and extract GCC source code
RUN mkdir -p /gcc && cd /gcc \
    && wget https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz \
    && tar -xzf gcc-${GCC_VERSION}.tar.gz

# Build AArch64 GCC with custom prefix
RUN mkdir -p /gcc-aarch64 && cd /gcc-aarch64 \
    && /gcc/gcc-${GCC_VERSION}/configure --prefix=${PREFIX} --target=aarch64-linux-gnu --disable-multilib \
    && make -j$(nproc) && make install

# Verify GCC installation
RUN ${PREFIX}/bin/aarch64-linux-gnu-gcc --version
