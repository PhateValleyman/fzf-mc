#!/usr/bin/env bash
# plugins/magisk.sh — zkratky pro rootovaná zařízení s Magiskem
# Aktivace: ln -s ../magisk.sh plugins/enabled/magisk.sh

magisk_plugin_init() {
    :
}

magisk_plugin_menu() {
    echo "Magisk: moduly, su přístup k /data"
}

magisk_plugin_action() {
    local choice
    choice="$(printf '%s\n' \
        "/data/adb/modules" \
        "/data/adb/magisk" \
        | fzf --prompt="magisk> ")"
    [ -n "$choice" ] && ui::set_active_path "$choice"
}
