#!/bin/bash

OPT=(
    "-it"
    "--rm"
    "-e" "HOME=/root"
    "-v" "$HOME:$HOME"
    "--workdir" "$(pwd)"
)

# Mac以外のときはユーザーidを変更する
# https://qiita.com/s10akir/items/19e130682204e4dbbf3b
if [ "$(uname)" != "Darwin" ]; then
    OPT+=(
        "-u" "$(id -u):$(id -g)"
    )
fi

# WSL2環境のときは/mnt/c/Usersをマウントする
if [[ "$(uname -r)" == *-microsoft-standard-WSL2 ]]; then
    OPT+=(
        "-v" "/mnt/c/Users:/mnt/c/Users"
    )
fi

docker run "${OPT[@]}" ghcr.io/kihachi2000/kihachi-env "$@"
