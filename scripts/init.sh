#!/usr/bin/env bash

cd $HOME
# code structure.
ln -s /data documents
mkdir -p documents/code

# prepare dot file.
cd $HOME/documents/code
git clone https://github.com/dantin/dotfile.git
git clone https://github.com/dantin/vim-config.git
ln -s $HOME/documents/code/vim-config $HOME/.vim
ln -s $HOME/documents/code/dotfile/vimrc $HOME/.vimrc
ln -s $HOME/documents/code/dotfile/tmux.conf $HOME/.tmux.conf

# install vim plugins
$HOME/.vim/update_plugin.sh
vim +PlugInstall +qall
