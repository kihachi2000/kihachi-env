FROM alpine:latest

RUN apk update --no-cache && \
    apk add --no-cache git neovim gcc musl-dev

RUN chmod -R 777 /root

WORKDIR /root
RUN nvim --headless +"Lazy! sync" +qa
RUN git clone https://github.com/thombergs/code-examples.git

ENTRYPOINT ["nvim"]
