#!/usr/bin/env bash

# python {{{ 
if [[ $CHEZMOI_OS == "windows" ]]; then
  echo "Execution paused. Install Python now."
  read -s -p "Press [Enter] to resume..."

  if command -v python >/dev/null 2>&1; then
      echo "Python is installed and executable."
  else
      echo "Error: python not found in PATH."
      exit 1
  fi

  python -m pip install -U pip

fi

if [[ $CHEZMOI_OS == "linux" ]]; then
  if command -v python >/dev/null 2>&1; then
      echo "Python is installed and executable."
  else
      echo "Error: python not found in PATH."
      exit 1
  fi
  python -m ensurepip
  python -m pip install -U pip
fi

pip install djlint ruff ty
# }}}

# nvim {{{

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
# }}}

# zig {{{

# We want the path to be ~/bin/zig
# We like zig for Windows because it is easily downloadable and we can just put it in our path so we have access to a C compiler

if [[ $CHEZMOI_OS == "windows" ]]; then
  curl -LO https://ziglang.org/builds/zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
  unzip zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
  mv zig-x86_64-windows-0.16.0-dev.2535+b5bd49460 zig
  mv zig ~/bin/
  rm zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
fi

# if [[ $CHEZMOI_OS == "linux" ]]; then
#   mkdir ~/bin/zig
#   curl -LO https://ziglang.org/builds/zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz
#   tar xaf zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz -C "$HOME/bin/zig" --strip-components=1
#   rm zig-x86_64-linux-0.16.0-dev.2535+b5bd49460.tar.xz
# fi
# Probably don't need zig for Linux because we can use GCC or Clang

# }}}

# wezterm {{{

# We want the path to be ~/bin/wezterm

if [[ $CHEZMOI_OS == "windows" ]]; then
  FILE="WezTerm-windows-20240203-110809-5046fc22.zip"
  curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-windows-20240203-110809-5046fc22.zip
  unzip $FILE
  mv "${FILE%.zip}" wezterm
  mv wezterm ~/bin/
  rm $FILE
fi
# }}}

# eget {{{

# We want the path to be ~/bin/eget for both platforms so we have to do some slight manipulation to get that done

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

eget -D
# }}}

# lua-language-server {{{

# We want the path to be ~/bin/lua-language-server

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
# }}}

# autoenv {{{
git clone 'https://github.com/hyperupcall/autoenv' ~/.autoenv
# }}}

# intell-shell {{{
export INTELLI_HOME="$HOME/.local/share/intelli-shell"
curl -sSf https://raw.githubusercontent.com/lasantosr/intelli-shell/main/install.sh | sh
# }}}

# starship {{{
curl -sS https://starship.rs/install.sh | sh -s -- -b $HOME/bin -y
# }}}
