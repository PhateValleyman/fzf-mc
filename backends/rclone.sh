#!/usr/bin/env bash
# backends/rclone.sh — VFS vstupní bod pro rclone backend
#
# Skutečná implementace (backends_rclone::list/copy/move/delete/mkdir/rename)
# žije v lib/rclone.sh. Tento soubor je dokumentovaný vstupní bod VFS vrstvy,
# připravený pro budoucí rozšíření (mount, cache, paralelní přenosy).

# shellcheck disable=SC1091
[ -n "${FZFMC_LIB:-}" ] && source "$FZFMC_LIB/rclone.sh"
