#!/usr/bin/env bash
# lib/files.sh — v0.2.0 File Operations
#
# copy/move/delete/mkdir/rename fungují napříč backendy (local/ssh/rclone)
# delegací na backends/*.sh. Všechny destruktivní operace vyžadují
# potvrzení (utils::confirm) a logují se přes database::add_operation.

files::edit() {
    local target="$1"
    [ -z "$target" ] && return
    "${EDITOR:-nano}" "$target"
}

files::copy() {
    local src="$1" dst_dir="$2"
    [ -z "$src" ] && return

    utils::confirm "Kopírovat '$src' do '$dst_dir'?" || return 1

    files::_dispatch copy "$src" "$dst_dir" || return 1
    database::add_operation "copy" "$src" "$dst_dir"
    utils::log INFO "copy: $src -> $dst_dir"
}

files::move() {
    local src="$1" dst_dir="$2"
    [ -z "$src" ] && return

    utils::confirm "Přesunout '$src' do '$dst_dir'?" || return 1

    files::_dispatch move "$src" "$dst_dir" || return 1
    database::add_operation "move" "$src" "$dst_dir"
    utils::log INFO "move: $src -> $dst_dir"
}

files::delete_prompt() {
    local target="$1"
    [ -z "$target" ] && return

    if [ "${USE_TRASH:-true}" = "true" ]; then
        utils::confirm "Přesunout '$target' do koše?" || return 1
        files::_trash "$target"
    else
        utils::confirm "TRVALE smazat '$target'? Tuto akci nelze vrátit zpět." || return 1
        files::_dispatch delete "$target" "" || return 1
    fi

    database::add_operation "delete" "$target" ""
    utils::log INFO "delete: $target (trash=${USE_TRASH:-true})"
}

files::mkdir_prompt() {
    local base_dir="$1"
    local name
    read -r -p "Název nového adresáře: " name
    [ -z "$name" ] && return

    files::_dispatch mkdir "${base_dir%/}/$name" "" || return 1
    database::add_operation "mkdir" "${base_dir%/}/$name" ""
}

files::rename_prompt() {
    local target="$1"
    local new_name
    read -r -p "Nový název pro '$target': " new_name
    [ -z "$new_name" ] && return

    files::_dispatch rename "$target" "$(dirname -- "$target")/$new_name" || return 1
    database::add_operation "rename" "$target" "$(dirname "$target")/$new_name"
}

# ---------------------------------------------------------------------------
# Interní dispatch na backend podle prefixu cesty (local/ssh/rclone)
# ---------------------------------------------------------------------------
files::_dispatch() {
    local action="$1" src="$2" dst="$3"
    local backend
    backend="$(utils::backend_of "$src")"

    case "$backend" in
        local)  backends_local::"$action" "$src" "$dst" ;;
        ssh)    backends_ssh::"$action" "$src" "$dst" ;;
        rclone) backends_rclone::"$action" "$src" "$dst" ;;
        *)      utils::log ERROR "Neznámý backend '$backend' pro akci '$action'"; return 1 ;;
    esac
}

files::_trash() {
    local target="$1"
    local trash_dir="${FZFMC_DATA}/trash"
    mkdir -p "$trash_dir"
    mv "$target" "$trash_dir/$(basename "$target").$(date +%s)" 2>/dev/null
}
