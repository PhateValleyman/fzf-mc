#!/usr/bin/env bash
# lib/progress.sh — operation progress helpers

progress::start() {
    printf '%s\n' "$1"
}

progress::done() {
    printf '%s\n' "Done"
}

progress::size() {
    stat -c '%s' "$1" 2>/dev/null || stat -f '%z' "$1" 2>/dev/null || echo 0
}

progress::dir_size() {
    du -sb "$1" 2>/dev/null | awk '{print $1}' || echo 0
}

progress::copy_file() {
    local src="$1" dst="$2"
    if command -v pv >/dev/null 2>&1; then
        pv -p -t -e -r -b -s "$(progress::size "$src")" "$src" > "$dst"
    else
        cp -a -- "$src" "$dst"
    fi
}

progress::copy() {
    local src="$1" dst="$2"
    trap 'return 130' INT TERM

    if [ -f "$src" ]; then
        progress::copy_file "$src" "$dst"
        return
    fi

    if [ -d "$src" ]; then
        mkdir -p -- "$dst"
        while IFS= read -r -d '' file; do
            local rel target
            rel="${file#"$src"/}"
            target="$dst/$rel"
            mkdir -p -- "$(dirname -- "$target")"
            progress::copy_file "$file" "$target" || return
        done < <(find "$src" -type f -print0)
        return
    fi

    cp -a -- "$src" "$dst"
}

progress::copy_async() {
    local src="$1" dst="$2"
    (
        progress::copy "$src" "$dst"
    ) &
    printf '%s\n' "$!"
}

progress::wait() {
    wait "$1"
}
