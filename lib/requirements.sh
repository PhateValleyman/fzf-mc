#!/usr/bin/env bash
# lib/requirements.sh — dependency checks

requirements::check() {
    local missing=()

    for cmd in fzf find; do
        command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    done

    if [ "${#missing[@]}" -gt 0 ]; then
        printf 'Missing dependencies: %s\n' "${missing[*]}" >&2
        return 1
    fi
}
