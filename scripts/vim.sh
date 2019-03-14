#!/usr/bin/env bash

BASE_DIR=$(dirname "$0")

cd ${BASE_DIR}/vim-8.1.0702
./configure --prefix=/usr/local                \
            --with-features=huge               \
            --enable-cscope                    \
            --enable-multibyte                 \
            --enable-perlinterp                \
            --enable-pythoninterp              \
            --with-python-command=python       \
            --enable-python3interp             \
            --with-python3-command=python3.7   \
            --enable-rubyinterp                \
            --with-ruby-command=/usr/bin/ruby  \
            --enable-luainterp                 \
            --with-lua-prefix=/usr             \
            --with-compiledby="David Ding"
