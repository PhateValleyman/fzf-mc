#!/usr/bin/env bash
# lib/core.sh — bootstrap, modulový loader, globální stav aplikace
#
# core::bootstrap je vstupní bod volaný z fzf-mc.sh. Zodpovídá za:
#   1. kontrolu závislostí (fzf, bash >= 4)
#   2. načtení konfigurace
#   3. import ostatních modulů z lib/
#   4. inicializaci panelů
#   5. spuštění hlavní smyčky (ui::main_loop)

core::require_bin() {
    local bin="$1"
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "fzf-mc: chybí závislost '$bin'. Nainstaluj ji a spusť znovu." >&2
        return 1
    fi
    return 0
}

core::check_dependencies() {
    local missing=0
    for bin in fzf bash; do
        core::require_bin "$bin" || missing=1
    done

    if [ "${BASH_VERSINFO[0]:-0}" -lt 4 ]; then
        echo "fzf-mc: vyžaduje bash >= 4 (nalezeno: ${BASH_VERSION:-neznámá})." >&2
        missing=1
    fi

    # Volitelné, ale doporučené závislosti — pouze varování.
    for bin in bat rsync ssh rclone sqlite3; do
        command -v "$bin" >/dev/null 2>&1 || \
            echo "fzf-mc: varování — volitelná závislost '$bin' nenalezena." >&2
    done

    return "$missing"
}

# core::load_module NAME
# Načte lib/NAME.sh pokud existuje.
core::load_module() {
    local name="$1"
    local path="$FZFMC_LIB/${name}.sh"
    if [ -f "$path" ]; then
        # shellcheck disable=SC1090
        source "$path"
    else
        echo "fzf-mc: modul '$name' nenalezen v $path" >&2
        return 1
    fi
}

core::load_all_modules() {
    local modules=(utils local ui menu navigation preview files operations ssh rclone plugins database)
    local mod
    for mod in "${modules[@]}"; do
        core::load_module "$mod" || return 1
    done
    return 0
}

core::load_config() {
    if [ -f "$FZFMC_CONFIG" ]; then
        # shellcheck disable=SC1090
        source "$FZFMC_CONFIG"
    else
        echo "fzf-mc: konfigurace $FZFMC_CONFIG nenalezena, používám výchozí hodnoty." >&2
    fi

    # Výchozí hodnoty (pokud config.conf nedefinuje jinak)
    : "${LEFT_PATH:=$HOME}"
    : "${RIGHT_PATH:=/tmp}"
    : "${EDITOR:=nano}"
    : "${PREVIEW:=cat}"
    : "${USE_TRASH:=true}"
    : "${DEFAULT_BACKEND:=local}"
    : "${THEME:=default}"

    export LEFT_PATH RIGHT_PATH EDITOR PREVIEW USE_TRASH DEFAULT_BACKEND THEME
}

core::bootstrap() {
    core::check_dependencies || return 1
    mkdir -p "$FZFMC_DATA"
    core::load_config
    core::load_all_modules || return 1

    database::init
    plugins::load_enabled

    ui::init
    ui::main_loop
}
