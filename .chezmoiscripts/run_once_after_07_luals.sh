#!/usr/bin/env bash

# We want the path to be ~/bin/wezterm

if [[ $CHEZMOI_OS == "windows" ]]; then
  FILE="lua-language-server-3.17.1-win32-x64.zip"
  mkdir lua-language-server
  (
    cd lua-language-server
    curl -LO https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-win32-x64.zip
    unzip $FILE
  )
  mv lua-language-server ~/bin/
  rm ~/bin/lua-language-server/$FILE
fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  FILE="lua-language-server-3.17.1-linux-x64.tar.gz"
  mkdir ~/bin/lua-language-server
  curl -LO https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-linux-x64.tar.gz
  tar xzf $FILE -C "$HOME/bin/lua-language-server" --strip-components=1
  rm $FILE
fi
