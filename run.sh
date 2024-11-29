#!/bin/bash

VOLUMES=(
    #"-v" "$HOME/git/yash:/root/yash"
)

docker run -it --rm "${VOLUMES[@]}" nvim-dev-env
