#!/usr/bin/env bash
# lib/dialogs.sh — user confirmation dialogs

confirm() {
    local message="$1"
    read -r -p "$message [y/N] " answer
    case "$answer" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}
