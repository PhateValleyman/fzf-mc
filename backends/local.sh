#!/usr/bin/env bash
# backends/local.sh — lokální filesystem backend
#
# Tento soubor je zdrojován samostatně (ne přes core::load_module),
# protože implementace local backendu je natolik jednoduchá, že nemá
# vlastní stav — jde jen o tenkou vrstvu nad standardními coreutils.
# lib/files.sh a lib/ui.sh na tyto funkce odkazují jako backends_local::*.

backends_local::list() {
    local path="$1"
    printf '..\n'
    ls -1ap "$path" 2>/dev/null | grep -v '^\./$'
}

backends_local::copy() {
    local src="$1" dst="$2"
    cp -a -- "$src" "$dst"
}

backends_local::move() {
    local src="$1" dst="$2"
    mv -- "$src" "$dst"
}

backends_local::delete() {
    local target="$1"
    rm -rf -- "$target"
}

backends_local::mkdir() {
    local target="$1"
    mkdir -p -- "$target"
}

backends_local::rename() {
    local src="$1" dst="$2"
    mv -- "$src" "$dst"
}
