FROM alpine:latest

WORKDIR /root

# apk
RUN apk update --no-cache \
    && apk add --no-cache \
    curl \
    gcc \
    git \
    libc6-compat \
    musl-dev \
    neovim \
    nodejs \
    npm \
    tar

# eslint & prettier
RUN npm install -g eslint prettier

# rust-analyzer & stylua
#ENV PATH $PATH:/root/.cargo/bin
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /root/install-rustup.sh \
    #&& sh /root/install-rustup.sh -y \
    #&& rm /root/install-rustup.sh \
    #&& rustup component add rust-analyzer \
    #&& cargo install stylua

# lua-ls
ENV PATH $PATH:/root/.lua-ls/bin
RUN curl -fLsS https://github.com/LuaLS/lua-language-server/releases/download/3.13.2/lua-language-server-3.13.2-linux-arm64.tar.gz > /root/lua-ls.tar.gz \
    && mkdir .lua-ls \
    && tar -zxvf /root/lua-ls.tar.gz -C /root/.lua-ls \
    && rm /root/lua-ls.tar.gz

# dotfiles
RUN git clone https://github.com/kihachi2000/dotfiles.git --branch=dev --depth=1 .dotfiles \
    && mkdir .config \
    && ln -s ~/.dotfiles/nvim ~/.config/nvim \
    && nvim --headless +"Lazy! sync" +qa

RUN chmod -R 777 /root

#ENTRYPOINT ["nvim"]
