#!/usr/bin/env bash
# Basic smoke test for fzf-mc

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash -n "$ROOT/fzf-mc.sh"
find "$ROOT/lib" -name '*.sh' -exec bash -n {} \;
find "$ROOT/backends" -name '*.sh' -exec bash -n {} \;

echo "fzf-mc syntax OK"
