#!/usr/bin/env bash
# lib/preview.sh — náhled souborů v pravém/preview panelu fzf (F3)
#
# Používá $PREVIEW z konfigurace (výchozí: cat, doporučeno: bat).
# Pro adresáře používá ls, pro obrázky/binárky vypisuje jen `file`.

preview::show() {
    local target="$1"
    [ -z "$target" ] && return

    if [ -d "$target" ]; then
        ls -la --color=always "$target" 2>/dev/null | ${PAGER:-less}
        return
    fi

    if [ -f "$target" ]; then
        preview::render_file "$target" | ${PAGER:-less} -R
        return
    fi

    echo "Náhled není k dispozici pro: $target"
}

preview::render_file() {
    local file="$1"
    local mime
    mime="$(file --mime-type -b "$file" 2>/dev/null)"

    case "$mime" in
        text/*|application/json|application/x-sh|application/xml)
            if command -v "$PREVIEW" >/dev/null 2>&1; then
                "$PREVIEW" --color=always "$file" 2>/dev/null || cat "$file"
            else
                cat "$file"
            fi
            ;;
        image/*)
            echo "[obrázek] $file"
            file "$file"
            ;;
        *)
            echo "[binární soubor] $file"
            file "$file"
            ;;
    esac
}
