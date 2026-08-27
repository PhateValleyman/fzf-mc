#!/usr/bin/env bash
# lib/progress.sh — operation progress helpers

progress::start() {
    local message="$1"
    printf '%s\n' "$message"
}

progress::done() {
    printf '%s\n' "Done"
}

# progress::copy SRC DST copies files with pv when available
progress::copy() {
    local src="$1"
    local dst="$2"

    if command -v pv >/dev/null 2>&1 && [ -f "$src" ]; then
        local size
        size="$(stat -c '%s' "$src" 2>/dev/null || stat -f '%z' "$src" 2>/dev/null || echo 0)"

        pv -p -t -e -r -b -s "$size" "$src" > "$dst"
    else
        cp -a -- "$src" "$dst"
    fi
}
