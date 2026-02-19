#!/usr/bin/env bash

# We want the path to be ~/bin/nvim for both platforms so we have to do some slight manipulation to get that done

if [[ $CHEZMOI_OS == "windows" ]]; then
  FILE=eget-1.3.4-windows_amd64.zip
  curl -LO https://github.com/zyedidia/eget/releases/download/v1.3.4/eget-1.3.4-windows_amd64.zip
  unzip $FILE
  mv "${FILE%.zip}" eget
  mv eget ~/bin/
  rm $FILE
fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  FILE=eget-1.3.4-linux_amd64.tar.gz
  mkdir ~/bin/eget_dir
  curl -LO https://github.com/zyedidia/eget/releases/download/v1.3.4/eget-1.3.4-linux_amd64.tar.gz
  tar xzf $FILE -C "$HOME/bin/eget_dir" --strip-components=1
  mv $HOME/bin/eget_dir/eget $HOME/bin/eget
  rm -r $HOME/bin/eget_dir
  rm $FILE
fi
