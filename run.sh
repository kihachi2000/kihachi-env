#!/bin/bash

OPT=(
    "-it"
    "--rm"
    "--workdir" "/root/virtual-home"
    "-e" "HOME=/root"
    "-v" "$(pwd):/root/virtual-home"
)

# Mac以外のときはユーザーidを変更する
# https://qiita.com/s10akir/items/19e130682204e4dbbf3b
if [ "$(uname)" != "Darwin" ]; then
    OPT+=(
        "-u" "$(id -u):$(id -g)"
    )
fi

docker run "${OPT[@]}" kihachi-env
