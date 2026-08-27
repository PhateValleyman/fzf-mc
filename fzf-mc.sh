#!/data/data/com.termux/files/usr/bin/bash

# fzf-mc main launcher
# Midnight Commander inspired file manager using fzf

set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$ROOT_DIR/lib/core.sh"
source "$ROOT_DIR/lib/ui.sh"

fzfmc_init
fzfmc_main
