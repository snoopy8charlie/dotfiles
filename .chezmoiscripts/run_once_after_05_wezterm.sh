#!/usr/bin/env bash

# We want the path to be ~/bin/wezterm

if [[ $CHEZMOI_OS == "windows" ]]; then
  FILE="WezTerm-windows-20240203-110809-5046fc22.zip"
  curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-windows-20240203-110809-5046fc22.zip
  unzip $FILE
  mv "${FILE%.zip}" wezterm
  mv wezterm ~/bin/
  rm $FILE
fi
