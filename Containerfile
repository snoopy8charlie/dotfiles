# go-builder {{{
FROM golang:1.26 AS go-builder

RUN go install github.com/antonmedv/fx@latest

RUN go install github.com/noahgorstein/jqp@latest

RUN go install github.com/oz/tz@latest
# }}}

# rust-builder {{{
FROM rust:1.93 AS rust-builder 

RUN cargo install jinja-lsp csvlens stylua viddy

RUN LIBSQLITE3_FLAGS="-DSQLITE_ENABLE_MATH_FUNCTIONS" cargo install intelli-shell --locked

# }}}

FROM fedora:44

COPY --from=rust-builder /usr/local/cargo/bin/jinja-lsp /usr/bin/jinja-lsp

COPY --from=rust-builder /usr/local/cargo/bin/intelli-shell /usr/bin/intelli-shell

COPY --from=rust-builder /usr/local/cargo/bin/csvlens /usr/bin/csvlens

COPY --from=rust-builder /usr/local/cargo/bin/stylua /usr/bin/stylua

COPY --from=rust-builder /usr/local/cargo/bin/viddy /usr/bin/viddy

COPY --from=go-builder /go/bin/fx /usr/bin/fx

COPY --from=go-builder /go/bin/jqp /usr/bin/jqp

COPY --from=go-builder /go/bin/tz /usr/bin/tz

RUN mkdir /opt/lua-language-server && curl -LO https://github.com/LuaLS/lua-language-server/releases/download/3.17.1/lua-language-server-3.17.1-linux-x64.tar.gz && tar xzf lua-language-server-3.17.1-linux-x64.tar.gz -C "/opt/lua-language-server" && chmod -R 777 /opt/lua-language-server 

RUN echo -e '#!/bin/bash\nexec "/opt/lua-language-server/bin/lua-language-server" "$@"' > /usr/bin/lua-language-server && chmod 555 /usr/bin/lua-language-server

RUN dnf install -y \
  git \
  python3.14 \
  gcc \
  ShellCheck \
  neovim \ 
  nodejs \
  fd-find \
  ripgrep \
  bat \
  git-delta \
  jq

RUN python -m ensurepip && python -m pip install -U pip && pip install djlint ruff ty

# have to install starship in /usr/bin/ because it seems like the PATH variable does not get set before bashrc is sourced
# if we try to let starship exist in ~/bin, we get the below error:
# bash: starship: command not found
# [dylan@devcontainer-pc-01 ~]$
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

RUN npm i -g bash-language-server @ansible/ansible-language-server @hyperupcall/autoenv

RUN useradd dylan

VOLUME /home/dylan

WORKDIR /home/dylan

USER dylan

CMD ["bash", "-li"]
