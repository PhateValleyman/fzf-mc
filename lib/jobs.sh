#!/usr/bin/env bash
# lib/jobs.sh — background operation manager

JOBS_DIR="${JOBS_DIR:-${HOME}/.local/share/fzf-mc/jobs}"

jobs::init() {
    mkdir -p -- "$JOBS_DIR"
}

jobs::add() {
    local pid="$1"
    local type="$2"
    local source="$3"
    local target="$4"

    jobs::init
    cat > "$JOBS_DIR/$pid" <<EOF
PID=$pid
TYPE=$type
SOURCE=$source
TARGET=$target
START=$(date +%s)
EOF
}

jobs::list() {
    jobs::init
    for job in "$JOBS_DIR"/*; do
        [ -e "$job" ] || continue
        # shellcheck disable=SC1090
        source "$job"
        if kill -0 "$PID" 2>/dev/null; then
            printf '[RUNNING] %s %s -> %s\n' "$PID" "$SOURCE" "$TARGET"
        else
            printf '[DONE] %s %s -> %s\n' "$PID" "$SOURCE" "$TARGET"
            rm -f -- "$job"
        fi
    done
}

jobs::cancel() {
    local pid="$1"
    kill "$pid" 2>/dev/null || true
    rm -f -- "$JOBS_DIR/$pid"
}
