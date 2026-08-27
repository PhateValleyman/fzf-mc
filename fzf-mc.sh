#!/usr/bin/env bash
# fzf-mc — terminálový dvoupanelový souborový manažer
# Repo: https://github.com/PhateValleyman/fzf-mc

set -uo pipefail

FZFMC_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
export FZFMC_ROOT
export FZFMC_VERSION="0.1.1"
export FZFMC_CONFIG="${FZFMC_CONFIG:-$FZFMC_ROOT/config/config.conf}"
export FZFMC_LIB="$FZFMC_ROOT/lib"
export FZFMC_BACKENDS="$FZFMC_ROOT/backends"
export FZFMC_PLUGINS="$FZFMC_ROOT/plugins"
export FZFMC_PROFILES="$FZFMC_ROOT/profiles"
export FZFMC_THEMES="$FZFMC_ROOT/themes"
export FZFMC_DATA="$FZFMC_ROOT/data"
export FZFMC_DB="$FZFMC_ROOT/database/fzf-mc.db"

source "$FZFMC_LIB/core.sh"

fzfmc::preview_helper() {
    local target="$1"
    if [ -d "$target" ]; then
        ls -lah "$target"
    elif command -v bat >/dev/null 2>&1; then
        bat --color=always --style=numbers "$target" 2>/dev/null || file "$target"
    else
        file "$target"
    fi
}

fzfmc::parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --config)
                FZFMC_CONFIG="$2"
                shift 2
                ;;
            --preview-helper)
                fzfmc::preview_helper "$2"
                exit 0
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
                exit 1
                ;;
        esac
    done
}

fzfmc::print_help() {
    cat <<'EOF'
fzf-mc — dvoupanelový terminálový souborový manažer

Volby:
  --config FILE
  --preview-helper FILE
  --version
  --help
EOF
}

fzfmc::main() {
    fzfmc::parse_args "$@"
    core::bootstrap
}

fzfmc::main "$@"
