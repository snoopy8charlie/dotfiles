#!/usr/bin/env bash

if [[ $CHEZMOI_OS == "windows" ]]; then

  if [[ -d ~/bin ]]; then
    echo "~/bin exists"
  else
    mkdir ~/bin
  fi

fi
