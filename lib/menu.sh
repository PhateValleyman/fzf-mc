#!/usr/bin/env bash
# lib/menu.sh — kontextová nabídka (F9)
# Nabízí přepínání backendu aktivního panelu, správu profilů, pluginy, atd.

menu::show() {
    local choice
    choice="$(printf '%s\n' \
        "Přepnout backend panelu (local/ssh/rclone)" \
        "Připojit SSH profil…" \
        "Připojit rclone remote…" \
        "Bookmarks" \
        "Historie" \
        "Pluginy" \
        "Zpět" \
        | fzf --prompt="menu> " --header="F9 — hlavní menu")"

    case "$choice" in
        "Přepnout backend panelu (local/ssh/rclone)") menu::switch_backend ;;
        "Připojit SSH profil…") menu::connect_ssh_profile ;;
        "Připojit rclone remote…") menu::connect_rclone_remote ;;
        "Bookmarks") menu::bookmarks ;;
        "Historie") menu::history ;;
        "Pluginy") plugins::menu ;;
        *) : ;;
    esac
}

menu::switch_backend() {
    local backend
    backend="$(printf 'local\nssh\nrclone\n' | fzf --prompt="backend> ")"
    [ -z "$backend" ] && return

    case "$backend" in
        local)  ui::set_active_path "$HOME" ;;
        ssh)    ui::set_active_path "ssh://$(menu::pick_ssh_target)" ;;
        rclone) ui::set_active_path "rclone://$(menu::pick_rclone_target)" ;;
    esac
}

menu::pick_ssh_target() {
    ls "$FZFMC_PROFILES"/*.conf 2>/dev/null \
        | xargs -n1 basename 2>/dev/null \
        | sed 's/\.conf$//' \
        | fzf --prompt="ssh profil> "
}

menu::connect_ssh_profile() {
    local profile
    profile="$(menu::pick_ssh_target)"
    [ -z "$profile" ] && return
    ssh::load_profile "$profile"
}

menu::connect_rclone_remote() {
    local remote
    remote="$(rclone listremotes 2>/dev/null | sed 's#:$##' | fzf --prompt="rclone remote> ")"
    [ -z "$remote" ] && return
    ui::set_active_path "rclone://${remote}/"
}

menu::pick_rclone_target() {
    rclone listremotes 2>/dev/null | sed 's#:$##' | fzf --prompt="rclone remote> "
}

menu::bookmarks() {
    local file="$FZFMC_DATA/bookmarks"
    [ -f "$file" ] || touch "$file"
    local pick
    pick="$(fzf --prompt="bookmark> " < "$file")"
    [ -n "$pick" ] && ui::set_active_path "$pick"
}

menu::history() {
    local file="$FZFMC_DATA/history"
    [ -f "$file" ] || touch "$file"
    local pick
    pick="$(tac "$file" 2>/dev/null | fzf --prompt="historie> ")"
    [ -n "$pick" ] && ui::set_active_path "$pick"
}
