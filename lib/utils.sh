#!/usr/bin/env bash
# lib/utils.sh — obecné pomocné funkce sdílené napříč moduly

# utils::log LEVEL MESSAGE
utils::log() {
    local level="$1"; shift
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    printf '[%s] [%s] %s\n' "$ts" "$level" "$*" >> "${FZFMC_DATA}/history.log"
}

utils::confirm() {
    # utils::confirm "Opravdu smazat 3 soubory?" -> 0 = ano, 1 = ne
    local prompt="$1"
    local answer
    read -r -p "$prompt [y/N]: " answer
    case "$answer" in
        y|Y|yes|ano) return 0 ;;
        *) return 1 ;;
    esac
}

utils::human_size() {
    # utils::human_size BYTES
    local bytes="$1"
    numfmt --to=iec --suffix=B "$bytes" 2>/dev/null || echo "${bytes}B"
}

utils::is_remote_path() {
    # rozpozná ssh:// nebo rclone:// prefix
    case "$1" in
        ssh://*|rclone://*) return 0 ;;
        *) return 1 ;;
    esac
}

utils::backend_of() {
    case "$1" in
        ssh://*) echo "ssh" ;;
        rclone://*) echo "rclone" ;;
        *) echo "local" ;;
    esac
}

utils::strip_backend_prefix() {
    local path="$1"
    path="${path#ssh://}"
    path="${path#rclone://}"
    echo "$path"
}

utils::timestamp() {
    date '+%Y-%m-%dT%H:%M:%S%z'
}
