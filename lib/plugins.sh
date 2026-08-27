#!/usr/bin/env bash
# lib/plugins.sh — v0.5.0 Plugin System
#
# Plugin API (každý plugin implementuje tři funkce s vlastním prefixem,
# viz plugins/README.md pro konvenci pojmenování):
#
#   plugin_init()    — volá se při načtení pluginu (core::bootstrap)
#   plugin_menu()    — vrátí popisek pro položku v F9 menu
#   plugin_action()  — spustí se po výběru pluginu z menu
#
# Aktivní pluginy jsou symlinky/soubory v plugins/enabled/*.sh.

declare -a PLUGINS_LOADED=()

plugins::load_enabled() {
    PLUGINS_LOADED=()
    local dir="$FZFMC_PLUGINS/enabled"
    [ -d "$dir" ] || return 0

    local f
    for f in "$dir"/*.sh; do
        [ -e "$f" ] || continue
        # shellcheck disable=SC1090
        source "$f"
        local base
        base="$(basename "$f" .sh)"
        if declare -f "${base}_plugin_init" >/dev/null 2>&1; then
            "${base}_plugin_init"
        fi
        PLUGINS_LOADED+=("$base")
        utils::log INFO "plugin načten: $base"
    done
}

plugins::menu() {
    if [ "${#PLUGINS_LOADED[@]}" -eq 0 ]; then
        echo "Žádné aktivní pluginy. Přidej je do plugins/enabled/." | fzf --prompt="pluginy> "
        return
    fi

    local choice
    choice="$(printf '%s\n' "${PLUGINS_LOADED[@]}" | fzf --prompt="plugin> ")"
    [ -z "$choice" ] && return

    if declare -f "${choice}_plugin_action" >/dev/null 2>&1; then
        "${choice}_plugin_action"
    fi
}
