#!/usr/bin/env bash
# lib/operations.sh — high level file operations

operations::copy() {
    local src="$1"
    local dst="$2"

    if [ -e "$dst/$(basename -- "$src")" ]; then
        local target="$dst/$(basename -- "$src")"
        local action
        action="$(conflict_dialog "$src" "$target")"

        case "$action" in
            overwrite)
                rm -rf -- "$target"
                ;;
            skip)
                return 0
                ;;
            rename)
                dst="$(dirname -- "$(conflict_rename_target "$target")")"
                ;;
            cancel)
                return 1
                ;;
        esac
    fi

    progress::start "Copy: $src -> $dst"
    cp -a -- "$src" "$dst"
    progress::done
}

operations::move() {
    local src="$1"
    local dst="$2"

    if [ -e "$dst/$(basename -- "$src")" ]; then
        local target="$dst/$(basename -- "$src")"
        local action
        action="$(conflict_dialog "$src" "$target")"

        case "$action" in
            overwrite)
                rm -rf -- "$target"
                ;;
            skip)
                return 0
                ;;
            rename)
                dst="$(dirname -- "$(conflict_rename_target "$target")")"
                ;;
            cancel)
                return 1
                ;;
        esac
    fi

    progress::start "Move: $src -> $dst"
    mv -- "$src" "$dst"
    progress::done
}

operations::delete() {
    local target="$1"
    if confirm "Delete '$target'?"; then
        rm -rf -- "$target"
    fi
}

operations::mkdir() {
    mkdir -p -- "$1"
}

operations::rename() {
    mv -- "$1" "$2"
}
