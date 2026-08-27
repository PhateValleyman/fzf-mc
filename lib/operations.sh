#!/usr/bin/env bash
# lib/operations.sh — high level file operations

operations::copy() {
    local src="$1"
    local dst="$2"
    local target="$dst/$(basename -- "$src")"

    if [ -e "$target" ]; then
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
                target="$(conflict_rename_target "$target")"
                ;;
            cancel)
                return 1
                ;;
        esac
    fi

    progress::start "Copy: $src -> $target"

    if [ -f "$src" ]; then
        progress::copy "$src" "$target"
    else
        cp -a -- "$src" "$target"
    fi

    progress::done
}

operations::move() {
    local src="$1"
    local dst="$2"
    local target="$dst/$(basename -- "$src")"

    if [ -e "$target" ]; then
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
                target="$(conflict_rename_target "$target")"
                ;;
            cancel)
                return 1
                ;;
        esac
    fi

    progress::start "Move: $src -> $target"
    mv -- "$src" "$target"
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
