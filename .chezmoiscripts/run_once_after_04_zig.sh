#!/usr/bin/env bash

# We want the path to be ~/bin/zig
# We like zig for Windows because it is easily downloadable and we can just put it in our path so we have access to a C compiler

if [[ $CHEZMOI_OS == "windows" ]]; then
  curl -LO https://ziglang.org/builds/zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
  unzip zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
  mv zig-x86_64-windows-0.16.0-dev.2535+b5bd49460 zig
  mv zig ~/bin/
  rm zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  mkdir ~/bin/zig
  curl -LO https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz
  tar xaf zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz -C "$HOME/bin/zig" --strip-components=1
  rm zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz
fi
# Probably don't need zig for Linux because we can use GCC or Clang
