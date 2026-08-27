#!/usr/bin/env bash
# lib/operations.sh — compatibility wrappers for high-level file operations
# The backend-aware implementations live in files.sh.

operations::copy() {
    files::copy "$@"
}

operations::copy_async() {
    echo "Asynchronní kopírování zatím není podporováno pro všechny backendy." >&2
    return 1
}

operations::move() {
    files::move "$@"
}

operations::delete() {
    files::delete_prompt "$@"
}

operations::mkdir() {
    files::_dispatch mkdir "$1" ""
}

operations::rename() {
    files::_dispatch rename "$1" "$2"
}
