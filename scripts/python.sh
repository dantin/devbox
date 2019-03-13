#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")

cd ${BASE_DIR}/Python-3.7.2
./configure --enable-optimizations --enable-shared
make -j8 build_all
make -j8 altinstall
cp libpython3.7* /usr/lib64
ldconfig
