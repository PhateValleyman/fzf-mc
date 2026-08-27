#!/usr/bin/env bash

# User interface functions

fzfmc_main()
{
    while true; do
        clear
        echo "fzf-mc"
        echo "Active panel: $ACTIVE_PANEL"
        echo

        if [ "$ACTIVE_PANEL" = "LEFT" ]; then
            PATH_VIEW="$LEFT_PANEL"
        else
            PATH_VIEW="$RIGHT_PANEL"
        fi

        echo "Directory: $PATH_VIEW"
        echo

        find "$PATH_VIEW" -maxdepth 1 2>/dev/null | fzf || break
    done
}
