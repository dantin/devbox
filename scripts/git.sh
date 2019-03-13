#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")

cd ${BASE_DIR}/git-2.20.1
make configure
./configure --prefix=/usr
make all
make install
