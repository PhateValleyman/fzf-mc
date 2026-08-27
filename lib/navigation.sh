#!/usr/bin/env bash
# lib/navigation.sh — pohyb v adresářové struktuře (local/ssh/rclone)

navigation::enter() {
    local entry="$1"
    [ -z "$entry" ] && return

    local backend
    backend="$(utils::backend_of "$(ui::active_path)")"

    case "$backend" in
        local)  navigation::enter_local "$entry" ;;
        ssh)    navigation::enter_ssh "$entry" ;;
        rclone) navigation::enter_rclone "$entry" ;;
    esac

    navigation::record_history "$(ui::active_path)"
}

navigation::enter_local() {
    local entry="$1"
    if [ "$entry" = ".." ]; then
        ui::set_active_path "$(dirname "$(ui::active_path)")"
    elif [ -d "$entry" ]; then
        ui::set_active_path "$entry"
    elif [ -f "$entry" ]; then
        files::edit "$entry"
    fi
}

navigation::enter_ssh() {
    local entry="$1"
    # entry přichází ve tvaru ssh://host/path/to/dir nebo relativní název
    if [ "$entry" = ".." ]; then
        ui::set_active_path "ssh://$(dirname "$(utils::strip_backend_prefix "$(ui::active_path)")")"
    else
        ui::set_active_path "$entry"
    fi
}

navigation::enter_rclone() {
    local entry="$1"
    if [ "$entry" = ".." ]; then
        ui::set_active_path "rclone://$(dirname "$(utils::strip_backend_prefix "$(ui::active_path)")")"
    else
        ui::set_active_path "$entry"
    fi
}

navigation::record_history() {
    local path="$1"
    echo "$path" >> "$FZFMC_DATA/history"
    database::add_history "$path" "$(utils::backend_of "$path")"
}
