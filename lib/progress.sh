#!/usr/bin/env bash
# lib/progress.sh — operation progress helpers

progress::start() {
    local message="$1"
    printf '%s\n' "$message"
}

progress::done() {
    printf '%s\n' "Done"
}

# Get file size in bytes
progress::size() {
    stat -c '%s' "$1" 2>/dev/null || stat -f '%z' "$1" 2>/dev/null || echo 0
}

# Calculate directory size recursively
progress::dir_size() {
    du -sb "$1" 2>/dev/null | awk '{print $1}' || echo 0
}

# Copy a single file with pv when available
progress::copy_file() {
    local src="$1"
    local dst="$2"

    if command -v pv >/dev/null 2>&1; then
        local size
        size="$(progress::size "$src")"
        pv -p -t -e -r -b -s "$size" "$src" > "$dst"
    else
        cp -a -- "$src" "$dst"
    fi
}

# Copy files or directories recursively with progress support
progress::copy() {
    local src="$1"
    local dst="$2"

    if [ -f "$src" ]; then
        progress::copy_file "$src" "$dst"
        return
    fi

    if [ -d "$src" ]; then
        local total copied file rel target
        total="$(progress::dir_size "$src")"
        copied=0

        mkdir -p -- "$dst"

        while IFS= read -r -d '' file; do
            rel="${file#"$src"/}"
            target="$dst/$rel"

            mkdir -p -- "$(dirname -- "$target")"
            progress::copy_file "$file" "$target"

            copied=$((copied + $(progress::size "$file")))

            if [ "$total" -gt 0 ]; then
                printf 'Progress: %s/%s bytes\n' "$copied" "$total"
            fi
        done < <(find "$src" -type f -print0)

        return
    fi

    cp -a -- "$src" "$dst"
}
