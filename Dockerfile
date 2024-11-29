FROM alpine:latest

WORKDIR /root

RUN apk update --no-cache \
    && apk add --no-cache curl gcc git musl-dev neovim nodejs npm

# eslint & prettier
RUN npm install -g eslint prettier

# stylua
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install_rustup.sh \
    && sh install_rustup.sh -y \
    && rm install_rustup.sh \
    && echo "export PATH=\$PATH:~/.cargo/bin" > .bashrc \
    && source .bashrc \
    && cargo install stylua

RUN git clone https://github.com/kihachi2000/dotfiles.git --branch=main --depth=1 .dotfiles \
    && mkdir .config \
    && ln -s ~/.dotfiles/nvim ~/.config/nvim \
    && nvim --headless +"Lazy! sync" +qa

RUN chmod -R 777 /root

#ENTRYPOINT ["nvim"]
