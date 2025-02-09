FROM alpine:latest

WORKDIR /root

# apk
RUN apk update --no-cache \
    && apk add --no-cache \
    ccls \
    curl \
    gcc \
    git \
    libc6-compat \
    musl-dev \
    neovim \
    nodejs \
    npm \
    openjdk17-jre \
    python3 \
    tar \
    xz

# typescript related
RUN npm install -g eslint prettier typescript-language-server typescript

# rust-analyzer
ENV PATH $PATH:/root/.rust-analyzer
RUN PLATFORM=$(case $(uname -m) in \
        "x86_64") echo "x86_64";; \
        "aarch64") echo "aarch64";; \
    esac) \
    && mkdir .rust-analyzer \
    && curl -fLsS https://github.com/rust-lang/rust-analyzer/releases/download/2024-12-02/rust-analyzer-${PLATFORM}-unknown-linux-gnu.gz > /root/.rust-analyzer/rust-analyzer.gz \
    && gzip -d /root/.rust-analyzer/rust-analyzer.gz

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

# jdtls
ENV PATH $PATH:/root/.jdtls/bin
RUN curl -fLsS https://www.eclipse.org/downloads/download.php?file=/jdtls/snapshots/jdt-language-server-latest.tar.gz > /root/jdtls.tar.gz \
    && mkdir .jdtls \
    && tar -zxvf /root/jdtls.tar.gz -C /root/.jdtls \
    && rm /root/jdtls.tar.gz

# haskell-language-server
ENV PATH $PATH:/root/.haskell-language-server/haskell-language-server-2.9.0.1/bin
RUN FILENAME=$(case $(uname -m) in \
        "x86_64") echo "x86_64-linux-unknown";; \
        "aarch64") echo "aarch64-linux-ubuntu20";; \
    esac) \
    && curl -fLsS https://github.com/haskell/haskell-language-server/releases/download/2.9.0.1/haskell-language-server-2.9.0.1-${FILENAME}.tar.xz > /root/haskell-language-server.tar.xz \
    && mkdir .haskell-language-server \
    && tar -Jxvf /root/haskell-language-server.tar.xz -C /root/.haskell-language-server \
    && rm /root/haskell-language-server.tar.xz

# dotfiles
RUN git clone https://github.com/kihachi2000/dotfiles.git --branch=dev --depth=1 .dotfiles \
    && mkdir .config \
    && ln -s ~/.dotfiles/nvim ~/.config/nvim \
    && nvim --headless +"Lazy! sync" +qa

RUN chmod -R 777 /root

ENTRYPOINT ["nvim"]
