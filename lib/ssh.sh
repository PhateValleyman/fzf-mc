#!/usr/bin/env bash
# lib/ssh.sh — v0.3.0 SSH Integration
#
# Profily jsou uloženy v profiles/*.conf ve tvaru:
#   name=ZyXEL NSA320
#   host=192.168.1.20
#   user=root
#   port=22
#   identity=~/.ssh/server
#
# Doporučení: vždy autentizace klíčem (identity), nikdy heslem.

ssh::load_profile() {
    local profile_name="$1"
    local profile_path="$FZFMC_PROFILES/${profile_name}.conf"

    if [ ! -f "$profile_path" ]; then
        echo "fzf-mc: SSH profil '$profile_name' nenalezen." >&2
        return 1
    fi

    local name host user port identity
    # shellcheck disable=SC1090
    source "$profile_path"
    name="${name:-$profile_name}"
    host="${host:?ssh profil musí definovat host}"
    user="${user:-root}"
    port="${port:-22}"
    identity="${identity:-$HOME/.ssh/server}"

    export SSH_CURRENT_HOST="$host"
    export SSH_CURRENT_USER="$user"
    export SSH_CURRENT_PORT="$port"
    export SSH_CURRENT_IDENTITY="$identity"

    utils::log INFO "SSH profil načten: $name ($user@$host:$port)"
    ui::set_active_path "ssh://${user}@${host}/"
}

# ssh::_opts sestaví společné SSH/SCP volby (klíč, port)
ssh::_opts() {
    printf -- '-p %s -i %s -o BatchMode=yes' \
        "${SSH_CURRENT_PORT:-22}" "${SSH_CURRENT_IDENTITY:-$HOME/.ssh/server}"
}

backends_ssh::list() {
    local remote_path
    remote_path="$(utils::strip_backend_prefix "$1")"
    remote_path="${remote_path#*@}"
    remote_path="${remote_path#*/}"
    remote_path="/${remote_path}"

    # shellcheck disable=SC2086
    ssh $(ssh::_opts) "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}" \
        "ls -1ap '${remote_path}'" 2>/dev/null
}

backends_ssh::copy() {
    local src="$1" dst="$2"
    # shellcheck disable=SC2086
    scp $(ssh::_opts) -r \
        "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}:$(utils::strip_backend_prefix "$src")" \
        "$dst"
}

backends_ssh::move() {
    local src="$1" dst="$2"
    backends_ssh::copy "$src" "$dst" && backends_ssh::delete "$src" ""
}

backends_ssh::delete() {
    local target
    target="$(utils::strip_backend_prefix "$1")"
    # shellcheck disable=SC2086
    ssh $(ssh::_opts) "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}" "rm -rf '${target}'"
}

backends_ssh::mkdir() {
    local target
    target="$(utils::strip_backend_prefix "$1")"
    # shellcheck disable=SC2086
    ssh $(ssh::_opts) "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}" "mkdir -p '${target}'"
}

backends_ssh::rename() {
    local src dst
    src="$(utils::strip_backend_prefix "$1")"
    dst="$(utils::strip_backend_prefix "$2")"
    # shellcheck disable=SC2086
    ssh $(ssh::_opts) "${SSH_CURRENT_USER}@${SSH_CURRENT_HOST}" "mv '${src}' '${dst}'"
}
