#!/usr/bin/env bash
# plugins/docker.sh — rychlý přehled kontejnerů/volumes (pro Server/NAS profily)
# Aktivace: ln -s ../docker.sh plugins/enabled/docker.sh

docker_plugin_init() {
    :
}

docker_plugin_menu() {
    echo "Docker: seznam kontejnerů a volumes na aktivním SSH cíli"
}

docker_plugin_action() {
    if [ "$(utils::backend_of "$(ui::active_path)")" != "ssh" ]; then
        echo "docker plugin: aktivní panel není SSH cíl."
        return
    fi
    # shellcheck disable=SC2086
    ssh $(ssh::_opts) "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}" \
        "docker ps -a && echo --- && docker volume ls" 2>/dev/null | ${PAGER:-less}
}
