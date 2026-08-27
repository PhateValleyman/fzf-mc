#!/usr/bin/env bash
# plugins/android.sh — rychlé zkratky pro Android/Termux prostředí
# Aktivace: ln -s ../android.sh plugins/enabled/android.sh

android_plugin_init() {
    :
}

android_plugin_menu() {
    echo "Android: rychlý přechod do /sdcard, /storage/emulated/0"
}

android_plugin_action() {
    local choice
    choice="$(printf '%s\n' \
        "/sdcard" \
        "/storage/emulated/0" \
        "/data/data/com.termux/files/home" \
        | fzf --prompt="android> ")"
    [ -n "$choice" ] && ui::set_active_path "$choice"
}
