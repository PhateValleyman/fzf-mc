#!/usr/bin/env bash
# lib/operations.sh — high level file operations

operations::copy() {
    local src="$1" dst="$2"
    local target="$dst/$(basename -- "$src")"

    if [ -e "$target" ]; then
        case "$(conflict_dialog "$src" "$target")" in
            overwrite) rm -rf -- "$target" ;;
            skip) return 0 ;;
            rename) target="$(conflict_rename_target "$target")" ;;
            cancel) return 1 ;;
        esac
    fi

    progress::copy "$src" "$target"
}

operations::copy_async() {
    local src="$1" dst="$2"
    local pid

    pid="$(progress::copy_async "$src" "$dst")"
    jobs::add "$pid" COPY "$src" "$dst"
    printf 'Job started: %s\n' "$pid"
}

operations::move() {
    local src="$1" dst="$2"
    mv -- "$src" "$dst/$(basename -- "$src")"
}

operations::delete() {
    confirm "Delete '$1'?" && rm -rf -- "$1"
}

operations::mkdir() {
    mkdir -p -- "$1"
}

operations::rename() {
    mv -- "$1" "$2"
}
