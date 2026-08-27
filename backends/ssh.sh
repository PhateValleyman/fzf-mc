#!/usr/bin/env bash
# backends/ssh.sh — VFS vstupní bod pro SSH backend
#
# Skutečná implementace (backends_ssh::list/copy/move/delete/mkdir/rename)
# žije v lib/ssh.sh spolu s profil managementem (ssh::load_profile), aby
# konfigurace spojení a I/O operace zůstaly na jednom místě.
#
# Tento soubor slouží jako dokumentovaný vstupní bod VFS vrstvy a místo pro
# budoucí backend-specifické rozšíření (např. SFTP mount, connection pool).

# shellcheck disable=SC1091
[ -n "${FZFMC_LIB:-}" ] && source "$FZFMC_LIB/ssh.sh"
