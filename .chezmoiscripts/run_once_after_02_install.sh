#!/usr/bin/env bash

if [[ $CHEZMOI_OS == "windows" ]]; then

# python {{{ 
echo "Execution paused. Install Python now via Python install manager."
read -s -p "Press [Enter] to resume..."

if command -v python >/dev/null 2>&1; then
    echo "Python is installed and executable."
else
    echo "Error: python not found in PATH."
    exit 1
fi

python -m pip install -U pip

pip install djlint ruff ty

# }}}

# nvim {{{

# We want the path to be ~/bin/nvim for both platforms so we have to do some slight manipulation to get that done

curl -LO https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-win64.zip
unzip nvim-win64.zip 
mv nvim-win64 nvim
mv nvim ~/bin/
rm nvim-win64.zip
# }}}

# zig {{{

# We want the path to be ~/bin/zig
# We like zig for Windows because it is easily downloadable and we can just put it in our path so we have access to a C compiler

curl -LO https://ziglang.org/builds/zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
unzip zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip
mv zig-x86_64-windows-0.16.0-dev.2535+b5bd49460 zig
mv zig ~/bin/
rm zig-x86_64-windows-0.16.0-dev.2535+b5bd49460.zip

# }}}

# wezterm {{{

# We want the path to be ~/bin/wezterm

FILE="WezTerm-windows-20240203-110809-5046fc22.zip"
curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-windows-20240203-110809-5046fc22.zip
unzip $FILE
mv "${FILE%.zip}" wezterm
mv wezterm ~/bin/
rm $FILE
# }}}

# eget {{{

# We want the path to be ~/bin/eget for both platforms so we have to do some slight manipulation to get that done

FILE=eget-1.3.4-windows_amd64.zip
curl -LO https://github.com/zyedidia/eget/releases/download/v1.3.4/eget-1.3.4-windows_amd64.zip
unzip $FILE
mv "${FILE%.zip}" eget
mv eget ~/bin/
rm $FILE

eget -D
# }}}

# lua-language-server {{{

# We want the path to be ~/bin/lua-language-server

FILE="lua-language-server-3.17.1-win32-x64.zip"
mkdir lua-language-server
(
  cd lua-language-server
  curl -LO https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-win32-x64.zip
  unzip $FILE
)
mv lua-language-server ~/bin/
rm ~/bin/lua-language-server/$FILE

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

fi
