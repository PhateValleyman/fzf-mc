#!/usr/bin/env bash
# lib/ui.sh — dvoupanelové rozhraní postavené nad fzf

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
    utils::log INFO "UI inicializováno"
}

ui::active_path() {
    [ "$UI_ACTIVE_PANEL" = "left" ] && echo "$UI_LEFT_PATH" || echo "$UI_RIGHT_PATH"
}

ui::inactive_path() {
    [ "$UI_ACTIVE_PANEL" = "left" ] && echo "$UI_RIGHT_PATH" || echo "$UI_LEFT_PATH"
}

ui::toggle_panel() {
    [ "$UI_ACTIVE_PANEL" = "left" ] && UI_ACTIVE_PANEL="right" || UI_ACTIVE_PANEL="left"
}

ui::header() {
    local left_marker right_marker
    left_marker=" "
    right_marker=" "
    [ "$UI_ACTIVE_PANEL" = "left" ] && left_marker=">"
    [ "$UI_ACTIVE_PANEL" = "right" ] && right_marker=">"

    printf '%s %-45s | %s %-45s\n' \
        "$left_marker" "$UI_LEFT_PATH" \
        "$right_marker" "$UI_RIGHT_PATH"
}

ui::list_entries() {
    local backend="$1" path="$2"
    case "$backend" in
        local) backends_local::list "$path" ;;
        ssh) backends_ssh::list "$path" ;;
        rclone) backends_rclone::list "$path" ;;
        *) echo "Unknown backend: $backend" >&2 ;;
    esac
}

ui::fuzzy_pick() {
    local path selection
    path="$(ui::active_path)"

    selection="$(ui::list_entries "$(utils::backend_of "$path")" "$path" | fzf \
        --prompt="${UI_ACTIVE_PANEL}> " \
        --header="$(ui::header)" \
        --preview 'bash '"$FZFMC_LIB"'/../fzf-mc.sh --preview-helper {} 2>/dev/null || true' \
        --preview-window=right:50%:wrap \
        --bind "tab:accept" \
        --expect="enter,f3,f4,f5,f6,f7,f8,f9,f10")"

    printf '%s\n' "$selection"
}

# Handle MC compatible function keys
ui::handle_file_operation() {
    local operation="$1"
    local source="$2"
    local target="$(ui::inactive_path)"

    case "$operation" in
        f5)
            files::copy "$source" "$target"
            ;;
        f6)
            files::move "$source" "$target"
            ;;
        f7)
            files::mkdir_prompt "$(ui::active_path)"
            ;;
        f8)
            files::delete_prompt "$source"
            ;;
    esac
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
            ""|enter) navigation::enter "$entry" ;;
            tab) ui::toggle_panel ;;
            f3) preview::show "$entry" ;;
            f4) files::edit "$entry" ;;
            f5|f6|f7|f8) ui::handle_file_operation "$key" "$entry" ;;
            f9) menu::show ;;
            f10) UI_RUNNING=0 ;;
        esac
    done
}
