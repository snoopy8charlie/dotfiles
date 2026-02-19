#!/usr/bin/env bash

# We want the path to be ~/bin/nvim for both platforms so we have to do some slight manipulation to get that done

if [[ $CHEZMOI_OS == "windows" ]]; then
  curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-win64.zip
  unzip nvim-win64.zip 
  mv nvim-win64 nvim
  mv nvim ~/bin/
  rm nvim-win64.zip
fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  mkdir ~/bin/nvim
  curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz
  tar xzf nvim-linux-x86_64.tar.gz -C "$HOME/bin/nvim" --strip-components=1
  rm nvim-linux-x86_64.tar.gz
fi
