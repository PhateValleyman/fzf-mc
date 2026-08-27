#!/usr/bin/env bash
# lib/dialogs.sh — user confirmation and conflict dialogs

confirm() {
    local message="$1"
    read -r -p "$message [y/N] " answer
    case "$answer" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

# Ask what to do when destination already exists
# Returns: overwrite, skip, rename, cancel
conflict_dialog() {
    local source="$1"
    local destination="$2"

    echo ""
    echo "Conflict detected"
    echo "Source:      $source"
    echo "Destination: $destination"
    echo ""

    local choice
    choice="$(printf '%s\n' \
        "overwrite" \
        "skip" \
        "rename" \
        "cancel" | fzf --prompt="Action> " --height=6)"

    case "$choice" in
        overwrite|skip|rename|cancel)
            echo "$choice"
            ;;
        *)
            echo "cancel"
            ;;
    esac
}

# Generate non-conflicting filename
conflict_rename_target() {
    local target="$1"
    local dir base ext i

    dir="$(dirname -- "$target")"
    base="$(basename -- "$target")"
    i=1

    while [ -e "$dir/$base.$i" ]; do
        i=$((i + 1))
    done

    echo "$dir/$base.$i"
}
