#!/usr/bin/env bash
# plugins/media.sh — hromadné akce nad mediálními soubory (obrázky, video, audio)
# Aktivace: ln -s ../media.sh plugins/enabled/media.sh

media_plugin_init() {
    :
}

media_plugin_menu() {
    echo "Media: náhled EXIF, hromadné přejmenování podle data"
}

media_plugin_action() {
    local target="$1"
    if command -v exiftool >/dev/null 2>&1 && [ -f "$target" ]; then
        exiftool "$target" | ${PAGER:-less}
    else
        echo "media plugin: exiftool nenalezen nebo cíl není soubor."
    fi
}
