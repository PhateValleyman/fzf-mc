#!/usr/bin/env bash

# Core functions and global state

export FZF_MC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fzfmc_init()
{
    LEFT_PANEL="$HOME"
    RIGHT_PANEL="/sdcard"
    ACTIVE_PANEL="LEFT"
}
