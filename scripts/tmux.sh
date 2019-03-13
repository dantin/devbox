#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")

cd ${BASE_DIR}/tmux-2.8
./configure
make
make install
