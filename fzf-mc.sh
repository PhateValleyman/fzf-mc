#!/usr/bin/env bash
#
# fzf-mc — terminálový dvoupanelový souborový manažer
# Autor: PhateValleyman
# Repo:  https://github.com/PhateValleyman/fzf-mc
#
# Kombinuje: dvoupanelové UI (Midnight Commander) + fuzzy hledání (fzf)
#            + VFS vrstvu (local / ssh / rclone) + plugin systém.
#
# Použití:
#   ./fzf-mc.sh                 spustí manažer s výchozí konfigurací
#   ./fzf-mc.sh --config FILE   spustí s vlastním konfiguračním souborem
#   ./fzf-mc.sh --version       vypíše verzi
#   ./fzf-mc.sh --help          nápověda

set -uo pipefail

# ---------------------------------------------------------------------------
# Základní cesty
# ---------------------------------------------------------------------------
FZFMC_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
export FZFMC_ROOT
export FZFMC_VERSION="0.1.0"
export FZFMC_CONFIG="${FZFMC_CONFIG:-$FZFMC_ROOT/config/config.conf}"
export FZFMC_LIB="$FZFMC_ROOT/lib"
export FZFMC_BACKENDS="$FZFMC_ROOT/backends"
export FZFMC_PLUGINS="$FZFMC_ROOT/plugins"
export FZFMC_PROFILES="$FZFMC_ROOT/profiles"
export FZFMC_THEMES="$FZFMC_ROOT/themes"
export FZFMC_DATA="$FZFMC_ROOT/data"
export FZFMC_DB="$FZFMC_ROOT/database/fzf-mc.db"

# ---------------------------------------------------------------------------
# Modulový loader — viz lib/core.sh
# ---------------------------------------------------------------------------
# shellcheck source=lib/core.sh
source "$FZFMC_LIB/core.sh"

fzfmc::parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --config)
                FZFMC_CONFIG="$2"
                shift 2
                ;;
            --version|-v)
                echo "fzf-mc v${FZFMC_VERSION}"
                exit 0
                ;;
            --help|-h)
                fzfmc::print_help
                exit 0
                ;;
            *)
                echo "Neznámý argument: $1" >&2
                fzfmc::print_help
                exit 1
                ;;
        esac
    done
}

fzfmc::print_help() {
    cat <<'EOF'
fzf-mc — dvoupanelový terminálový souborový manažer

Použití:
  fzf-mc.sh [volby]

Volby:
  --config FILE   použije vlastní konfigurační soubor
  --version, -v   vypíše verzi
  --help,    -h   zobrazí tuto nápovědu

Klávesy (viz README.md pro plný přehled):
  Tab     přepnutí panelu     F5  copy
  Enter   otevřít             F6  move
  F3      preview             F7  mkdir
  F4      edit                F8  delete
  F9      menu                F10 exit
EOF
}

fzfmc::main() {
    fzfmc::parse_args "$@"
    core::bootstrap
}

fzfmc::main "$@"
