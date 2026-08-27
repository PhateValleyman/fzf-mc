#!/usr/bin/env bash
# lib/rclone.sh — v0.4.0 rclone Integration
#
# Cesty ve tvaru rclone://remote/path se mapují na `rclone lsf/copy/moveto`
# volání. Vyžaduje nakonfigurovaný `rclone config` na hostitelském systému.

rclone::_require() {
    core::require_bin rclone
}

backends_rclone::list() {
    local path
    path="$(utils::strip_backend_prefix "$1")"
    rclone::_require || return 1
    rclone lsf "$path" 2>/dev/null
}

backends_rclone::copy() {
    local src dst
    src="$(utils::strip_backend_prefix "$1")"
    dst="$2"
    rclone::_require || return 1
    rclone copy "$src" "$dst" --progress
}

backends_rclone::move() {
    local src dst
    src="$(utils::strip_backend_prefix "$1")"
    dst="$2"
    rclone::_require || return 1
    rclone move "$src" "$dst" --progress
}

backends_rclone::delete() {
    local target
    target="$(utils::strip_backend_prefix "$1")"
    rclone::_require || return 1
    rclone delete "$target"
}

backends_rclone::mkdir() {
    local target
    target="$(utils::strip_backend_prefix "$1")"
    rclone::_require || return 1
    rclone mkdir "$target"
}

backends_rclone::rename() {
    local src dst
    src="$(utils::strip_backend_prefix "$1")"
    dst="$(utils::strip_backend_prefix "$2")"
    rclone::_require || return 1
    rclone moveto "$src" "$dst"
}
