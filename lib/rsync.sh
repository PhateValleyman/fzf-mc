#!/usr/bin/env bash
# lib/rsync.sh — optional fast transfer helper

rsync::available() {
    command -v rsync >/dev/null 2>&1
}

rsync::copy() {
    local src="$1" dst="$2"

    if rsync::available; then
        rsync -a --info=progress2 -- "$src" "$dst"
    else
        progress::copy "$src" "$dst"
    fi
}

rsync::remote_copy() {
    local src="$1" host="$2" dst="$3"

    if rsync::available; then
        rsync -a --info=progress2 "$src" "$host:$dst"
    else
        return 1
    fi
}
