#!/usr/bin/env bash
# plugins/git.sh — základní git status/log náhled pro aktivní adresář
# Aktivace: ln -s ../git.sh plugins/enabled/git.sh

git_plugin_init() {
    core::require_bin git 2>/dev/null || true
}

git_plugin_menu() {
    echo "Git: status a log aktivního adresáře"
}

git_plugin_action() {
    local path
    path="$(ui::active_path)"
    if [ -d "$path/.git" ]; then
        (cd "$path" && git status && echo "---" && git log --oneline -n 20) | ${PAGER:-less}
    else
        echo "git plugin: '$path' není git repozitář."
    fi
}
