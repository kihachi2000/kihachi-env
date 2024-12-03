FROM alpine:latest

ARG TARGETPLATFORM

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
RUN PLATFORM=$(case $(uname -m) in \
        "x86_64") echo "x64";; \
        "aarch64") echo "arm64";; \
    esac) \
    && curl -fLsS https://github.com/LuaLS/lua-language-server/releases/download/3.13.2/lua-language-server-3.13.2-linux-${PLATFORM}.tar.gz > /root/lua-ls.tar.gz \
    && mkdir .lua-ls \
    && tar -zxvf /root/lua-ls.tar.gz -C /root/.lua-ls \
    && rm /root/lua-ls.tar.gz

# stylua
ENV PATH $PATH:/root/.stylua
RUN PLATFORM=$(case $(uname -m) in \
        "x86_64") echo "x86_64";; \
        "aarch64") echo "aarch64";; \
    esac) \
    && curl -fLsS https://github.com/JohnnyMorganz/StyLua/releases/download/v2.0.1/stylua-linux-${PLATFORM}.zip > /root/stylua.zip \
    && mkdir .stylua \
    && unzip /root/stylua.zip -d /root/.stylua \
    && rm /root/stylua.zip


# dotfiles
RUN git clone https://github.com/kihachi2000/dotfiles.git --branch=dev --depth=1 .dotfiles \
    && mkdir .config \
    && ln -s ~/.dotfiles/nvim ~/.config/nvim \
    && nvim --headless +"Lazy! sync" +qa

RUN chmod -R 777 /root

#ENTRYPOINT ["nvim"]
