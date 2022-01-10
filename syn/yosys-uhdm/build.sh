#!/bin/bash

set -e
set -x

export LDFLAGS="$LDFLAGS -lrt -ltinfo"

cd Surelog && \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_POSITION_INDEPENDENT_CODE=ON -S . -B build && \
	cmake --build build -j$(nproc) && \
	cmake --install build && \
	cd ..

#Create aliases for gcc/gxx as `abc` uses them directly in Makefile
alias gcc=x86_64-conda_cos6-linux-gnu-gcc
alias gxx=x86_64-conda_cos6-linux-gnu-gcc
cd yosys && git apply ../yosys-patches/* && cd ..
make -C yosys ENABLE_READLINE=0 CONFIG=conda-linux PROGRAM_PREFIX=uhdm- install -j$(nproc)

make -C $PWD/yosys-symbiflow-plugins/ UHDM_INSTALL_DIR=$PREFIX install -j$(nproc)

