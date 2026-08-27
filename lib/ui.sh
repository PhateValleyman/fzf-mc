#!/usr/bin/env bash
# lib/ui.sh — dvoupanelové rozhraní postavené nad fzf
#
# Stav aplikace (panel, cesty, backend) je držen v globálních proměnných
# s prefixem UI_. Aktivní panel je buď "left" nebo "right".

UI_ACTIVE_PANEL="left"
UI_LEFT_PATH=""
UI_RIGHT_PATH=""
UI_LEFT_BACKEND="local"
UI_RIGHT_BACKEND="local"
UI_RUNNING=1

ui::init() {
    UI_LEFT_PATH="$LEFT_PATH"
    UI_RIGHT_PATH="$RIGHT_PATH"
    UI_LEFT_BACKEND="$(utils::backend_of "$LEFT_PATH")"
    UI_RIGHT_BACKEND="$(utils::backend_of "$RIGHT_PATH")"
    UI_RUNNING=1
    utils::log INFO "UI inicializováno (left=$UI_LEFT_PATH right=$UI_RIGHT_PATH)"
}

ui::active_path() {
    if [ "$UI_ACTIVE_PANEL" = "left" ]; then
        echo "$UI_LEFT_PATH"
    else
        echo "$UI_RIGHT_PATH"
    fi
}

ui::inactive_path() {
    if [ "$UI_ACTIVE_PANEL" = "left" ]; then
        echo "$UI_RIGHT_PATH"
    else
        echo "$UI_LEFT_PATH"
    fi
}

ui::set_active_path() {
    if [ "$UI_ACTIVE_PANEL" = "left" ]; then
        UI_LEFT_PATH="$1"
    else
        UI_RIGHT_PATH="$1"
    fi
}

ui::toggle_panel() {
    if [ "$UI_ACTIVE_PANEL" = "left" ]; then
        UI_ACTIVE_PANEL="right"
    else
        UI_ACTIVE_PANEL="left"
    fi
}

# ui::header vypíše stavový řádek nad panely (cesty, aktivní panel, backend)
ui::header() {
    local left_marker right_marker
    left_marker=" "
    right_marker=" "
    [ "$UI_ACTIVE_PANEL" = "left" ] && left_marker=">"
    [ "$UI_ACTIVE_PANEL" = "right" ] && right_marker=">"

    printf '%s [%s] %-40s | %s [%s] %-40s\n' \
        "$left_marker" "$UI_LEFT_BACKEND" "$UI_LEFT_PATH" \
        "$right_marker" "$UI_RIGHT_BACKEND" "$UI_RIGHT_PATH"
}

# ui::list_entries BACKEND PATH — deleguje na příslušný backend
ui::list_entries() {
    local backend="$1" path="$2"
    case "$backend" in
        local)  backends_local::list "$path" ;;
        ssh)    backends_ssh::list "$path" ;;
        rclone) backends_rclone::list "$path" ;;
        *)      echo "fzf-mc: neznámý backend '$backend'" >&2 ;;
    esac
}

# ui::fuzzy_pick zobrazí fzf výběr aktivního panelu s náhledem (F3 = preview)
ui::fuzzy_pick() {
    local backend path selection
    backend="$(utils::backend_of "$(ui::active_path)")"
    path="$(ui::active_path)"

    selection="$(ui::list_entries "$backend" "$path" | fzf \
        --prompt="${UI_ACTIVE_PANEL}> " \
        --header="$(ui::header)" \
        --preview 'bash '"$FZFMC_LIB"'/../fzf-mc.sh --preview-helper {} 2>/dev/null || true' \
        --preview-window=right:50%:wrap \
        --bind "tab:accept" \
        --expect="enter,f3,f4,f5,f6,f7,f8,f9,f10")"

    printf '%s\n' "$selection"
}

ui::main_loop() {
    while [ "$UI_RUNNING" -eq 1 ]; do
        clear
        ui::header
        echo "----------------------------------------------------------------------"

        local result key entry
        result="$(ui::fuzzy_pick)"
        key="$(echo "$result" | head -n1)"
        entry="$(echo "$result" | tail -n1)"

        case "$key" in
            "")       navigation::enter "$entry" ;;
            enter)    navigation::enter "$entry" ;;
            tab)      ui::toggle_panel ;;
            f3)       preview::show "$entry" ;;
            f4)       files::edit "$entry" ;;
            f5)       files::copy "$entry" "$(ui::inactive_path)" ;;
            f6)       files::move "$entry" "$(ui::inactive_path)" ;;
            f7)       files::mkdir_prompt "$(ui::active_path)" ;;
            f8)       files::delete_prompt "$entry" ;;
            f9)       menu::show ;;
            f10)      UI_RUNNING=0 ;;
            *)        : ;;
        esac
    done
    utils::log INFO "fzf-mc ukončen uživatelem"
}
