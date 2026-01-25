#!/bin/bash

ln -sf ~/.files/.zshrc ~/.zshrc

mkdir -p ~/.config
ln -sf ~/.files/nvim ~/.config/nvim
ln -sf ~/.files/tmux ~/.config/tmux

echo "Dotfiles installed!"


