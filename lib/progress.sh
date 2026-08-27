#!/usr/bin/env bash
# lib/progress.sh — operation progress helpers

progress::start() {
    local message="$1"
    printf '%s\n' "$message"
}

progress::done() {
    printf '%s\n' "Done"
}
