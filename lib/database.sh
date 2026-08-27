#!/usr/bin/env bash
# lib/database.sh — v0.6.0 SQLite Database
#
# Ukládá historii navigace, tagy souborů a log operací pro rychlé
# vyhledávání a "inteligentní" našeptávání cest. Pokud sqlite3 není
# nainstalováno, modul se degraduje na no-op (funkce vrací tiše 0) a
# textové logy v data/ zůstávají jediným zdrojem historie.

database::_available() {
    command -v sqlite3 >/dev/null 2>&1
}

database::init() {
    database::_available || return 0
    mkdir -p "$(dirname "$FZFMC_DB")"

    sqlite3 "$FZFMC_DB" <<'SQL'
CREATE TABLE IF NOT EXISTS history (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    path      TEXT NOT NULL,
    backend   TEXT NOT NULL,
    timestamp TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS tags (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    file TEXT NOT NULL,
    tag  TEXT NOT NULL,
    note TEXT
);

CREATE TABLE IF NOT EXISTS operations (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    action      TEXT NOT NULL,
    source      TEXT NOT NULL,
    destination TEXT,
    time        TEXT NOT NULL
);
SQL
}

database::add_history() {
    database::_available || return 0
    local path="$1" backend="$2"
    sqlite3 "$FZFMC_DB" \
        "INSERT INTO history (path, backend, timestamp) VALUES ('$(database::_esc "$path")', '$(database::_esc "$backend")', '$(utils::timestamp)');"
}

database::add_operation() {
    database::_available || return 0
    local action="$1" source="$2" destination="$3"
    sqlite3 "$FZFMC_DB" \
        "INSERT INTO operations (action, source, destination, time) VALUES ('$(database::_esc "$action")', '$(database::_esc "$source")', '$(database::_esc "$destination")', '$(utils::timestamp)');"
}

database::add_tag() {
    database::_available || return 0
    local file="$1" tag="$2" note="${3:-}"
    sqlite3 "$FZFMC_DB" \
        "INSERT INTO tags (file, tag, note) VALUES ('$(database::_esc "$file")', '$(database::_esc "$tag")', '$(database::_esc "$note")');"
}

database::search_history() {
    database::_available || return 0
    local term="$1"
    sqlite3 "$FZFMC_DB" \
        "SELECT path FROM history WHERE path LIKE '%$(database::_esc "$term")%' ORDER BY id DESC LIMIT 50;"
}

database::_esc() {
    printf '%s' "$1" | sed "s/'/''/g"
}
